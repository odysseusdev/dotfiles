#!/usr/bin/env python3
"""Sync ZSA Oryx layouts: fetch from API, convert to QMK JSON, and render SVGs."""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from api import fetch_layout
from colors import BOLD, DIM, GREEN, MAUVE, RED, RESET, TEAL
from convert import build_keymap_yaml, convert_to_qmk

SCRIPTS_DIR = Path(__file__).parent   # zsa/.sync/
ZSA_DIR = SCRIPTS_DIR.parent          # zsa/
LAYOUTS_FILE = ZSA_DIR / "layouts"


def render_svg(keymap_yaml: str, svg_path: Path) -> None:
    """
    Invoke the keymap-drawer CLI to render a keymap YAML string to an SVG file.

    Writes the YAML to a temp file (never persisted to the output directory)
    and removes it when the subprocess exits.

    Args:
        keymap_yaml: YAML content produced by build_keymap_yaml.
        svg_path: Destination path for the rendered SVG.

    Raises:
        RuntimeError: If keymap-drawer exits with a non-zero status.
    """
    # invoke via python -m rather than the keymap wrapper script; the wrapper's
    # shebang is hardcoded to the venv path at install time and breaks if the venv moves
    python_bin = SCRIPTS_DIR / ".venv" / "bin" / "python"
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yaml", delete=False) as tmp:
        tmp.write(keymap_yaml)
        tmp_path = Path(tmp.name)
    try:
        result = subprocess.run(
            [str(python_bin), "-m", "keymap_drawer", "draw", str(tmp_path), "-o", str(svg_path)],
            capture_output=True,
            text=True,
        )
    finally:
        tmp_path.unlink(missing_ok=True)
    if result.returncode != 0:
        raise RuntimeError(f"keymap-drawer failed:\n{result.stderr}")


def sync_layout(layout_id: str) -> None:
    """
    Fetch, convert, and render a single Oryx layout.

    Args:
        layout_id: The Oryx layout hash ID (e.g. "QJ07g").
    """
    print(f"    {DIM}fetching {layout_id}...{RESET}")

    oryx_data = fetch_layout(layout_id)

    layout_name: str = oryx_data["title"].lower().replace(" ", "-")
    revision_hash: str = oryx_data["revision"]["hashId"]
    output_dir = ZSA_DIR / layout_name
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"    {GREEN}✓{RESET}  {TEAL}{layout_name}{RESET}  {DIM}({revision_hash}){RESET}")

    (output_dir / "oryx.json").write_text(json.dumps(oryx_data, indent=2))
    print(f"      {GREEN}✓{RESET}  oryx.json")

    (output_dir / "qmk.json").write_text(json.dumps(convert_to_qmk(oryx_data), indent=2))
    print(f"      {GREEN}✓{RESET}  qmk.json")

    print(f"         {DIM}rendering svg...{RESET}")
    render_svg(build_keymap_yaml(oryx_data), output_dir / "layout.svg")
    print(f"      {GREEN}✓{RESET}  layout.svg")


def _stale_layout_dirs(layout_ids: set[str]) -> list[Path]:
    """
    Return layout output directories whose hash ID is no longer in the layouts file.

    Identifies layout dirs by the presence of oryx.json with a top-level hashId field.
    Dirs that can't be identified (missing file, malformed JSON) are left untouched.

    Args:
        layout_ids: The set of currently active Oryx hash IDs.

    Returns:
        List of directories safe to remove.
    """
    stale: list[Path] = []
    for directory in ZSA_DIR.iterdir():
        if not directory.is_dir():
            continue
        oryx_json = directory / "oryx.json"
        if not oryx_json.exists():
            continue
        try:
            data = json.loads(oryx_json.read_text())
            hash_id: str | None = data.get("hashId")
            if hash_id is not None and hash_id not in layout_ids:
                stale.append(directory)
        except (json.JSONDecodeError, OSError):
            pass
    return stale


def main() -> None:
    """Read layout IDs from the layouts file and sync each one."""
    if not LAYOUTS_FILE.exists():
        print(f"  {RED}✗{RESET}  layouts file not found at {LAYOUTS_FILE}", file=sys.stderr)
        sys.exit(1)

    layout_ids: list[str] = [
        line.strip()
        for line in LAYOUTS_FILE.read_text().splitlines()
        if line.strip()
    ]

    if not layout_ids:
        print(f"  {RED}✗{RESET}  no layout IDs found in layouts file", file=sys.stderr)
        sys.exit(1)

    count = len(layout_ids)
    label = "layout" if count == 1 else "layouts"
    print(f"\n  {MAUVE}{BOLD}syncing {count} {label}{RESET}\n")

    stale_dirs = _stale_layout_dirs(set(layout_ids))

    failed: list[str] = []
    for i, layout_id in enumerate(layout_ids):
        if i > 0:
            print()  # blank line between layout blocks
        try:
            sync_layout(layout_id)
        except Exception as error:
            print(f"\n    {RED}✗{RESET}  {error}", file=sys.stderr)
            failed.append(layout_id)

    for stale_dir in stale_dirs:
        shutil.rmtree(stale_dir)
        print(f"\n    {DIM}removed  {stale_dir.name}{RESET}")

    if failed:
        print(f"\n  {RED}{BOLD}✗  failed: {', '.join(failed)}{RESET}\n", file=sys.stderr)
        sys.exit(1)

    print(f"\n  {GREEN}{BOLD}✓  done{RESET}\n")


if __name__ == "__main__":
    main()

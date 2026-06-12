"""Convert Oryx layout data to QMK keymap JSON and keymap-drawer YAML."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import yaml

from keycodes import (
    VOYAGER_KEY_ORDER,
    VOYAGER_LEFT_INDICES,
    US_SHIFT_MAP,
    QMK_MOD_MAP,
    MOD_DISPLAY,
    ORYX_MOD_TO_QMK,
    KEYCODE_GLYPHS,
    KEYCODE_SYMBOLS,
    KEYCODE_LABELS,
    EMPTY_CODES,
    TRANSPARENT_CODES,
)

_THEME_FILE = Path(__file__).parent / "theme.yaml"


# ---------------------------------------------------------------------------
# Key parsing helpers
# ---------------------------------------------------------------------------

def _parse_keys(raw: Any) -> list[dict[str, Any]]:
    """
    Parse the `keys` field from the API response.

    The field may be a JSON scalar (string) or a native list depending on
    the API version; this handles both.
    """
    if isinstance(raw, str):
        return json.loads(raw)
    return raw  # type: ignore[return-value]


def _reorder_keys(keys: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """
    Reorder Oryx keys into keymap-drawer/QMK row-interleaved order.

    Oryx returns all left-half keys first then all right-half keys.
    keymap-drawer expects: row0_left, row0_right, row1_left, row1_right, ...
    """
    return [keys[i] for i in VOYAGER_KEY_ORDER]


def _active_mods(modifiers: dict[str, bool] | None) -> list[str]:
    """Return the list of active QMK modifier strings from an Oryx modifiers object."""
    if not modifiers:
        return []
    return [
        QMK_MOD_MAP[field]
        for field, active in modifiers.items()
        if active and field in QMK_MOD_MAP
    ]


# ---------------------------------------------------------------------------
# QMK JSON conversion
# ---------------------------------------------------------------------------

def _feature_to_qmk(feature: dict[str, Any] | None) -> str:
    """Convert a single Oryx key feature (tap or hold) to a QMK keycode string."""
    if not feature:
        return "KC_TRNS"

    code: str = feature.get("code") or ""
    layer: int | None = feature.get("layer")
    mods = _active_mods(feature.get("modifiers"))

    # Normalise Oryx verbose modifier codes to QMK shorthand
    qmk_code = ORYX_MOD_TO_QMK.get(code, code)

    # true when the keycode has no action of its own; wrapping it in LT/MT would be pointless
    non_action = not qmk_code or qmk_code in EMPTY_CODES or qmk_code in TRANSPARENT_CODES

    if code == "MO":
        return f"MO({layer})" if layer is not None else "KC_TRNS"

    if layer is not None and not non_action:
        return f"LT({layer}, {qmk_code})"

    if mods and not non_action:
        return f"MT({' | '.join(mods)}, {qmk_code})"

    if layer is not None:
        return f"MO({layer})"

    # modifier-only key with no base code: MOD_LCTL → KC_LCTL
    if mods:
        return mods[0].replace("MOD_", "KC_")

    # Normalise both transparent aliases to the canonical QMK shorthand
    if not qmk_code or qmk_code in TRANSPARENT_CODES:
        return "KC_TRNS"
    return qmk_code


def convert_to_qmk(oryx_data: dict[str, Any]) -> dict[str, Any]:
    """
    Convert Oryx layout data to QMK keymap JSON format.

    Args:
        oryx_data: Full layout object from the Oryx API.

    Returns:
        A dict matching the QMK keymap JSON schema (version 1).
    """
    revision = oryx_data["revision"]
    layers = sorted(revision["layers"], key=lambda layer: layer["position"])

    qmk_layers: list[list[str]] = []
    for layer in layers:
        keys = _reorder_keys(_parse_keys(layer["keys"]))
        qmk_layers.append([_feature_to_qmk(key.get("tap")) for key in keys])

    return {
        "version": 1,
        "keyboard": "zsa/voyager",
        "keymap": oryx_data["title"].lower().replace(" ", "_"),
        "layout": "LAYOUT",
        "layers": qmk_layers,
    }


# ---------------------------------------------------------------------------
# keymap-drawer YAML generation
# ---------------------------------------------------------------------------

def _tap_label(tap_feature: dict[str, Any] | None, custom_label: str | None) -> str:
    """
    Derive the primary display label for a key's tap action.

    Resolution order: glyphs → symbols → labels → function keys → alpha → digits → MO → KC_ strip.
    """
    if not tap_feature:
        return custom_label or ""

    code: str = tap_feature.get("code") or ""

    if not code or code in TRANSPARENT_CODES or code in EMPTY_CODES:
        return ""

    if custom_label:
        return custom_label

    if code in KEYCODE_GLYPHS:
        return KEYCODE_GLYPHS[code]

    if code in KEYCODE_SYMBOLS:
        return KEYCODE_SYMBOLS[code]

    if code in KEYCODE_LABELS:
        return KEYCODE_LABELS[code]

    # Function keys: KC_F1 → F1
    if code.startswith("KC_F") and code[4:].isdigit():
        return code[3:]

    # Single-letter alpha: KC_A → A (uppercase per convention)
    if code.startswith("KC_") and len(code) == 4 and code[3].isalpha():
        return code[3]

    # Digits: KC_1 → 1
    if code.startswith("KC_") and len(code) == 4 and code[3].isdigit():
        return code[3]

    # Layer momentary used as tap
    if code == "MO":
        layer = tap_feature.get("layer")
        return f"L{layer}" if layer is not None else "MO"

    if code.startswith("KC_"):
        return code[3:]

    return code


def _hold_label(hold_feature: dict[str, Any] | None) -> str | None:
    """Derive the display label for a key's hold action, or None if no hold."""
    if not hold_feature:
        return None

    code: str = hold_feature.get("code") or ""
    layer: int | None = hold_feature.get("layer")
    mods = _active_mods(hold_feature.get("modifiers"))

    if not code and layer is None and not mods:
        return None

    if code == "MO":
        return f"L{layer}" if layer is not None else "MO"

    # Empty/transparent hold: derive label from layer or modifier object
    if not code or code in TRANSPARENT_CODES or code in EMPTY_CODES:
        if layer is not None:
            return f"L{layer}"
        if mods:
            return MOD_DISPLAY.get(mods[0], mods[0])
        return None

    if layer is not None:
        return f"L{layer}"

    if mods:
        return MOD_DISPLAY.get(mods[0], mods[0])

    if label := KEYCODE_LABELS.get(code) or KEYCODE_SYMBOLS.get(code):
        return label

    return code[3:] if code.startswith("KC_") else code


def _build_key_entry(key: dict[str, Any], key_index: int) -> Any:
    """
    Build a single keymap-drawer key entry.

    Transparent keys render as ▽ with type:trans.
    Hold labels go to the lower corner (bl for left keys, br for right).
    Shifted labels go to the upper corner (tl for left keys, tr for right).
    """
    tap_feature = key.get("tap")
    hold_feature = key.get("hold")
    custom_label: str | None = key.get("customLabel") or None

    tap_code: str = (tap_feature or {}).get("code") or ""

    # Intentional empty key: dark background like transparent, but no symbol
    if tap_code in EMPTY_CODES and not hold_feature and not custom_label:
        return {"t": "", "type": "trans"}

    # Transparent: explicit KC_TRANSPARENT/KC_TRNS or null tap with no hold
    is_transparent = (
        tap_code in TRANSPARENT_CODES
        or (not tap_feature and not hold_feature and not custom_label)
        or (not tap_code and not hold_feature and not custom_label)
    )
    if is_transparent:
        return {"t": "▽", "type": "trans"}

    tap = _tap_label(tap_feature, custom_label)
    hold = _hold_label(hold_feature)
    shifted = US_SHIFT_MAP.get(tap_code)
    is_left = key_index in VOYAGER_LEFT_INDICES

    entry: dict[str, Any] = {}

    if tap:
        entry["t"] = tap
    if hold:
        entry["bl" if is_left else "br"] = hold
    if shifted:
        entry["tl" if is_left else "tr"] = shifted

    if not entry:
        return ""

    # Scalar shorthand when only the tap label is set
    if list(entry.keys()) == ["t"]:
        return entry["t"]

    return entry


def _held_key_positions(layers: list[dict[str, Any]], target_position: int) -> frozenset[int]:
    """
    Find key positions (in keymap-drawer order) that activate the given layer.

    Covers both MO (pure momentary) and LT (tap-hold with layer) on the hold action,
    plus the uncommon case of MO used as a tap action.

    Args:
        layers: All layers from the revision, in any order.
        target_position: The layer position to find activators for.

    Returns:
        Set of key indices (in keymap-drawer row-interleaved order) that activate the layer.
    """
    positions: set[int] = set()
    for layer in layers:
        if layer["position"] == target_position:
            continue
        for index, key in enumerate(_reorder_keys(_parse_keys(layer["keys"]))):
            tap = key.get("tap") or {}
            hold = key.get("hold") or {}
            activates = (
                (tap.get("code") == "MO" and tap.get("layer") == target_position)
                or hold.get("layer") == target_position  # covers both MO and LT on hold
            )
            if activates:
                positions.add(index)
    return frozenset(positions)


def build_keymap_yaml(oryx_data: dict[str, Any]) -> str:
    """
    Generate a keymap-drawer YAML document from Oryx layout data.

    Embeds draw_config from theme.yaml if present.

    Args:
        oryx_data: Full layout object from the Oryx API.

    Returns:
        YAML string ready to be passed to `keymap draw`.
    """
    revision = oryx_data["revision"]
    layers = sorted(revision["layers"], key=lambda layer: layer["position"])

    yaml_layers: dict[str, list[Any]] = {}
    for layer in layers:
        position: int = layer["position"]
        title: str = layer.get("title") or "Untitled"
        layer_name = f"L{position} - {title}"
        keys = _reorder_keys(_parse_keys(layer["keys"]))
        key_entries: list[Any] = [_build_key_entry(key, i) for i, key in enumerate(keys)]

        # Replace transparent entries at held-key positions with type:held so they
        # render with the held style rather than the standard transparent style.
        if position > 0:
            for held_pos in _held_key_positions(layers, position):
                entry = key_entries[held_pos]
                if isinstance(entry, dict) and entry.get("type") == "trans":
                    key_entries[held_pos] = {"t": "", "type": "held"}

        yaml_layers[layer_name] = key_entries

    doc: dict[str, Any] = {
        "layout": {"qmk_keyboard": "zsa/voyager"},
        "layers": yaml_layers,
    }

    if _THEME_FILE.exists():
        theme = yaml.safe_load(_THEME_FILE.read_text())
        if isinstance(theme, dict) and "draw_config" in theme:
            doc["draw_config"] = theme["draw_config"]

    # sort_keys=False preserves layer insertion order; default behaviour sorts alphabetically
    return yaml.dump(doc, default_flow_style=False, allow_unicode=True, sort_keys=False)

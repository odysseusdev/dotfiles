# dotfiles

_dotfiles for every odyssey. one config, a thousand shores._

personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 structure

```
dotfiles/
├── assets/           # wallpaper
├── aur/              # package list (arch)
├── brew/             # homebrew bundle (macOS)
├── ghostty/          # ghostty terminal
├── git/              # git config and global ignore
├── vscode/           # vscode settings
├── zsh/              # zshrc, aliases, syntax highlighting
├── zsa/              # ZSA keyboard sync (not managed by stow)
│   ├── <name>/       # generated output, one dir per layout
│   ├── layouts       # oryx hash IDs, one per line
│   └── sync.sh       # fetch, convert, and render all layouts
├── install.sh        # install packages
├── link.sh           # add symlinks
└── unlink.sh         # remove symlinks
```

## 🚀 installation

**1. prerequisites**

clone the repo, then make sure the following are available:

- [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow` / `pacman -S stow`
- macOS: [homebrew](https://brew.sh)
- arch: [yay](https://github.com/Jguer/yay) (covers both official and AUR packages)

```bash
git clone https://github.com/odysseus/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**2. install packages** _(optional)_

installs all packages for the current platform: homebrew bundle on macOS, yay on arch. yay handles both official pacman packages and AUR packages in a single pass, so the list in `aur/packages` covers everything. if zsh is the default shell, [oh-my-zsh](https://ohmyz.sh) is installed automatically. the script will also prompt to sync vscode extensions after install, with an option to clear existing ones first.

skip this if you only want the configs.

> **heads up**: the package lists also include apps i use as part of my personal setup that don't have configs here (e.g. obsidian, zen browser). feel free to trim them to your needs.

> **double heads up**: if you have vscode account sync enabled, it may re-apply your synced extensions and conflict with the list here. disable sync before running if you want a clean result.

```bash
./install.sh
```

**3. link configs**

stows all packages into `~` and handles platform differences automatically. for example, on macOS, vscode settings are additionally linked into `~/Library/Application Support/Code/User/`.

> **heads up**: any existing config files for these applications will be overwritten. back up anything you want to keep before running.

```bash
./link.sh
```

**unlinking**

to remove only the symlinks created by `link.sh`:

```bash
./unlink.sh
```

## ⌨️ keyboard sync

fetches [ZSA Voyager](https://www.zsa.io/voyager) layouts from the [Oryx](https://configure.zsa.io) cloud configurator and produces three files per layout under `zsa/<layout-name>/`:

- `oryx.json`: full layout export, re-importable into Oryx
- `qmk.json`: QMK-compatible keymap (version 1 schema)
- `layout.svg`: rendered keyboard diagram

**prerequisites:** python 3.x (no manual venv setup, bootstrapped automatically on first run)

```bash
./zsa/sync.sh
```

**adding or changing layouts**

add an Oryx layout hash ID to `zsa/layouts`, one per line. the hash is the short string in the Oryx URL (e.g. `nv4mJ`). the output directory name is taken from the layout title as it appears in Oryx.

## 📦 dependencies

- [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow` / `pacman -S stow`

## 📄 license

[MIT](LICENSE), feel free to borrow anything.

## 🤝 contributing

fork it, use it, make it yours. see [CONTRIBUTING.md](CONTRIBUTING.md).

# dotfiles

_dotfiles for every odyssey. one config, a thousand shores._

personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 structure

```
dotfiles/
├── aur/              # package list (arch)
├── brew/             # homebrew bundle (macOS)
├── fastfetch/        # fastfetch config
├── ghostty/          # ghostty terminal
├── git/              # git config and global ignore
├── hypr/             # hyprland window manager
├── nvim/             # neovim config
├── tmux/             # tmux config
├── vscode/           # vscode settings and extension list
├── wireplumber/      # wireplumber audio session manager
├── zen/              # zen browser theming
├── zsa/              # ZSA keyboard sync (not managed by stow)
│   ├── <name>/       # generated output, one dir per layout
│   ├── layouts       # oryx hash IDs, one per line
│   └── sync.sh       # fetch, convert, and render all layouts
├── zsh/              # zshrc, aliases, syntax highlighting
├── install.sh        # install packages
├── link.sh           # add symlinks
└── unlink.sh         # remove symlinks
```

## 🚀 installation

clone the repo and ensure the prerequisites are available:

- [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow` / `pacman -S stow`
- macOS: [homebrew](https://brew.sh)
- arch: [yay](https://github.com/Jguer/yay)

```bash
git clone https://github.com/odysseus/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**1. install packages** _(optional)_

installs packages for the current platform — homebrew bundle on macOS, yay on arch. also prompts to sync vscode extensions.

```bash
./install.sh
```

**2. link configs**

> **heads up**: existing configs will be overwritten. back up anything you want to keep first.

```bash
./link.sh
```

**unlinking**

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

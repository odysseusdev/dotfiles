# dotfiles

*dotfiles for every odyssey. one config, a thousand shores.*

personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 structure

```
dotfiles/
├── assets/       # wallpaper
├── ghostty/      # ghostty terminal
├── git/          # git config and global ignore
├── vscode/       # vscode settings
├── zsh/          # zshrc, aliases, syntax highlighting
├── zsa/          # ZSA keyboard layouts ^
├── link.sh       # add symlinks
└── unlink.sh     # remove symlinks
```

*^ not managed by stow*

## 🚀 installation

```bash
git clone https://github.com/odysseus/dotfiles.git ~/dotfiles
cd ~/dotfiles
./link.sh
```

`link.sh` stows all packages into `~` and handles platform differences automatically. for example, on macOS, vscode settings are additionally linked into `~/Library/Application Support/Code/User/`.

> **heads up** — any existing config files for these applications will be overwritten. back up anything you want to keep before running.

to remove only the symlinks created by `link.sh`:

```bash
./unlink.sh
```

## 📦 dependencies

- [GNU Stow](https://www.gnu.org/software/stow/) — `brew install stow` / `pacman -S stow`

## 📄 license

[MIT](LICENSE) — feel free to borrow anything.

## 🤝 contributing

guests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

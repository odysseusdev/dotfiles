# dotfiles

*dotfiles for every odyssey. one config, a thousand shores.*

personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 structure

```
dotfiles/
├── assets/       # wallpaper
├── brew/         # homebrew bundle (macOS)
├── ghostty/      # ghostty terminal
├── git/          # git config and global ignore
├── pacman/       # pacman & AUR package lists (arch)
├── vscode/       # vscode settings
├── zsh/          # zshrc, aliases, syntax highlighting
├── zsa/          # ZSA keyboard layouts ^
├── install.sh    # install packages
├── link.sh       # add symlinks
└── unlink.sh     # remove symlinks
```

*^ not managed by stow*

## 🚀 installation

**1. prerequisites**

clone the repo, then make sure the following are available:

- [GNU Stow](https://www.gnu.org/software/stow/) — `brew install stow` / `pacman -S stow`
- macOS: [homebrew](https://brew.sh)
- arch: `pacman` and `yay`

```bash
git clone https://github.com/odysseus/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**2. install packages** *(optional)*

installs all packages for the current platform — homebrew bundle on macOS, pacman and yay on arch. skip this if you only want the configs.

> **heads up** — the package lists also include apps i use as part of my personal setup that don't have configs here (e.g. obsidian, zen browser). feel free to trim them to your needs.

```bash
./install.sh
```

**3. link configs**

stows all packages into `~` and handles platform differences automatically. for example, on macOS, vscode settings are additionally linked into `~/Library/Application Support/Code/User/`.

> **heads up** — any existing config files for these applications will be overwritten. back up anything you want to keep before running.

```bash
./link.sh
```

**unlinking**

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

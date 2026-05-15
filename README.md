# Hammer's dotfiles

Symlink-based dotfile management. Tracked files live in this repo; the `install`
script symlinks them into the right places under `$HOME`.

## What's tracked

| Repo path        | Symlinked to               |
|------------------|----------------------------|
| `tmux.conf`      | `~/.tmux.conf`             |
| `zshrc`          | `~/.zshrc`                 |
| `zshenv`         | `~/.zshenv`                |
| `gitconfig`      | `~/.gitconfig`             |
| `gitignore`      | `~/.gitignore_global`      |
| `ghostty/config` | `~/.config/ghostty/config` |

## Per-machine overrides

Secrets and host-specific bits live in companion `*.local` files that are
**gitignored** (never committed):

- `~/.zshrc.local` — sourced at the end of `~/.zshrc`; holds env vars/secrets.
- `~/.gitconfig.local` — included by `~/.gitconfig` via git's `[include]`
  directive; holds the per-machine `user.email`.

Create those files by hand on each machine. Mode them `600`.

## Install

```bash
git clone git@github.com:thehammer/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install --dry-run   # preview
./install             # really do it
```

Existing files at the target paths are moved to `<target>.old` before the
symlink lands. `install` is idempotent — already-correct symlinks are skipped.

## Sync flow

Make a change locally → it edits the symlink target → which is the file in
this repo → commit and push. Other machines `git pull` and the change is live
on next shell / tmux reload.

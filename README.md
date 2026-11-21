# Personal Utilities

This repository provides a collection of Bash scripts to automate common setup tasks on a new machine. The scripts install modern development tools, configure aliases, and help you manage environments with support for both Bash and Zsh shells. Most tools also have a PowerShell counterpart for Windows — see [Windows Support](#windows-support).

## Prerequisites

* Ubuntu or another Debian-based distribution with `apt` available.
* `sudo` privileges to install packages.
* [ShellCheck](https://www.shellcheck.net/) if you plan to run `make lint`.

## Directory overview

| Folder | Purpose |
| ------ | ------- |
| `tools` | Individual installers for utilities like Docker, Git, Terraform, Google Cloud CLI, and modern tools |
| `airbyte` | Helper for installing [Airbyte](https://airbyte.io/) using Docker |
| `alias` | Convenience aliases and helper scripts with hybrid Bash/Zsh support |
| `lib` | Shared PowerShell helper used by the Windows installers |

The main entry point is `install.sh`, which scans these folders and presents an interactive menu so you can choose which scripts to execute.

## Available Tools

### 🛠️ Development Tools
- **Docker** - Container platform
- **Git** - Version control system
- **Terraform** - Infrastructure as Code
- **Google Cloud CLI** - Google Cloud Platform tools
- **pyenv** - Manage and switch between multiple Python versions (Linux/macOS via `tools/pyenv.sh`, Windows via `tools/pyenv.ps1`)

### 🎨 Modern Terminal Tools
- **Eza** - Modern replacement for `ls` with icons and colors
- **Batcat** - Modern replacement for `cat` with syntax highlighting
- **Ripgrep** - Ultra-fast text search tool

### 🖥️ Shell & Environment
- **Zsh** - Advanced shell with better features
- **Oh My Zsh** - Framework for managing Zsh configuration
- **Zsh Customization** - Spaceship theme and autocomplete plugins

### 📝 Editors & IDEs
- **Sublime Text** - Fast and lightweight code editor
- **Gedit** - Simple text editor
- **Cursor** - AI-first coding environment (Snap installation)

### 🔧 System Tools
- **OpenSSH Client** - SSH connectivity tools

### 📦 Other Tools
- **Airbyte** - Data integration platform

## Usage

### Quick Start
1. Clone or download this repository and enter its directory.
2. Optionally review the scripts you plan to run.
3. Run the installer:

   ```bash
   # Using make (recommended)
   make install

   # Or directly
   bash install.sh
   ```
4. When prompted, select the numbers corresponding to the scripts you want to run. Each script may require `sudo` privileges as it installs packages using `apt`.

### Individual Tool Installation
You can install specific tools using make commands:

```bash
# Development tools
make docker git terraform pyenv

# Modern terminal tools
make eza batcat ripgrep

# Shell setup
make zsh oh-my-zsh zsh-customization

# Editors
make sublime gedit

# System tools
make open_ssh_client
```

### Available Make Commands
```bash
make install           # Run main install.sh menu
make aliases           # Install aliases (hybrid bash/zsh)
make docker            # Install Docker
make gcloud            # Install Google Cloud CLI
make gedit             # Install Gedit
make git               # Install Git
make terraform         # Install Terraform
make airbyte           # Install Airbyte
make eza               # Install Eza (ls replacement)
make batcat            # Install Batcat (cat replacement)
make zsh               # Install Zsh
make oh-my-zsh         # Install Oh My Zsh
make zsh-customization # Customize Zsh with themes and plugins
make sublime           # Install Sublime Text
make cursor            # Install Cursor (Snap installation)
make ripgrep           # Install Ripgrep (fast text search)
make open_ssh_client   # Install OpenSSH Client
make pyenv             # Install pyenv (Python version manager)
make lint              # Run ShellCheck on scripts
make test              # Run the test suite (syntax + functional tests)
make help              # Show all available commands
```

## Aliases

Run `make aliases` or execute `alias/install_aliases.sh` directly to install helpful shortcuts. The script automatically detects your shell (Bash or Zsh) and installs aliases in the appropriate configuration file.

After running it you'll be able to launch the installer anywhere by simply typing:

```bash
utils
```

### Available Aliases
- `utils` - Launch the main installer
- `python` - Use Python 3
- `bashrc` - Edit and reload bashrc
- `zshrc` - Edit and reload zshrc
- `new_venv` - Create Python virtual environment
- `persist_env` - Persist environment variables
- `m` - Run make commands
- `sublime` - Open Sublime Text
- `ls` - Use Eza with icons and colors
- `cat` - Use Batcat with syntax highlighting
- `grep` - Use Ripgrep for faster searches

## Windows Support

Every `tools/*.sh`, `airbyte/airbyte.sh`, and `alias/*.sh` script has a `.ps1` counterpart living right next to it (e.g. `tools/git.sh` / `tools/git.ps1`), installed with [winget](https://learn.microsoft.com/windows/package-manager/winget/) instead of `apt`. The PowerShell `install.ps1` mirrors both `install.sh`'s interactive menu and the makefile's per-tool targets.

**Not yet run on an actual Windows machine.** CI parses every `.ps1` under Windows PowerShell 5.1 and smoke-tests `install.ps1 -List`, and `make test` checks that each Linux script has a counterpart — but the installs themselves have only been hand-reviewed against each tool's documented winget id and install flow. Sanity-check before relying on it, and open an issue/PR if a winget package id has moved.

### Prerequisites

* Windows 10 (1809+) or Windows 11.
* [winget](https://learn.microsoft.com/windows/package-manager/winget/) — preinstalled on current Windows; otherwise install "App Installer" from the Microsoft Store.
* PowerShell 5.1+ (built in) or [PowerShell 7](https://github.com/PowerShell/PowerShell).

### Quick Start

```powershell
# From the repo root, in PowerShell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Windows has no `make`, so the repo ships a `make.cmd` that forwards to `install.ps1`. The Linux commands work as typed, with `.\` in front (PowerShell doesn't run programs from the current folder without it):

```powershell
.\make install          # interactive menu
.\make git docker       # install specific tools
.\make help             # list everything
```

`make.cmd` also sidesteps the execution policy, so there's no `-ExecutionPolicy Bypass` to type. Calling `install.ps1` directly does the same thing:

```powershell
# Windows version of `make git docker terraform`
powershell -ExecutionPolicy Bypass -File install.ps1 git docker terraform

# See every name you can pass (the Windows `make help`)
powershell -ExecutionPolicy Bypass -File install.ps1 -List
```

The Linux make target names are accepted too and resolve to their Windows counterpart — `batcat` → `bat`, `zsh` → `powershell`, `oh-my-zsh` → `oh-my-posh`, `zsh-customization` → `powershell-customization`, `gedit` → `notepadplusplus`, `aliases` → `install_aliases`.

Each script can also still be run on its own, e.g. `powershell -ExecutionPolicy Bypass -File tools\git.ps1`.

If an install fails (winget error, unknown package id), the script says so and `install.ps1` exits non-zero and lists what failed, instead of reporting success.

### What's covered

| Linux | Windows script |
| ----- | -------------- |
| `make install` / `make <tool>` | `.\make install` / `.\make <tool>` (`make.cmd` → `install.ps1`) |
| Docker | `tools/docker.ps1` (Docker Desktop) |
| Git | `tools/git.ps1` |
| Terraform | `tools/terraform.ps1` |
| Google Cloud CLI | `tools/gcloud.ps1` |
| pyenv | `tools/pyenv.ps1` ([pyenv-win](https://github.com/pyenv-win/pyenv-win), not winget — uses its own official installer) |
| eza | `tools/eza.ps1` |
| bat (replaces `cat`) | `tools/bat.ps1` — note the command is `bat`, not `batcat`; the Debian-only rename doesn't apply here |
| ripgrep | `tools/ripgrep.ps1` |
| Sublime Text | `tools/sublime.ps1` |
| Cursor | `tools/cursor.ps1` |
| OpenSSH Client | `tools/openssh_client.ps1` (Windows optional feature; needs an elevated/Administrator PowerShell) |
| Airbyte | `airbyte/airbyte.ps1` (downloads `abctl` from its GitHub releases; Docker Desktop required) |
| Zsh | `tools/powershell.ps1` — PowerShell 7 (`pwsh`), the modern shell on Windows |
| Oh My Zsh | `tools/oh-my-posh.ps1` — [Oh My Posh](https://ohmyposh.dev/) prompt theme engine |
| Zsh Customization | `tools/powershell-customization.ps1` — Spaceship theme (Oh My Posh), git completion ([posh-git](https://github.com/dahlbyk/posh-git)), history autosuggestions and syntax highlighting (PSReadLine) |
| Gedit | `tools/notepadplusplus.ps1` — Notepad++ |
| Aliases | `alias/install_aliases.ps1` (see below) |

Zsh, Oh My Zsh and Gedit themselves don't exist natively on Windows, so those four rows install the closest Windows equivalent rather than the same program. If you want the originals, use WSL and the regular Bash scripts.

Unlike `zsh-customization.sh`, which replaces `~/.zshrc`, `powershell-customization.ps1` only adds one marked block to your `$PROFILE` (after backing it up); re-running it replaces just that block. Windows PowerShell 5.1 and PowerShell 7 have separate `$PROFILE` files, so run it — and `install_aliases.ps1` — from the shell you actually use.

### Aliases on Windows

There's no rc file to append to like `.bashrc`/`.zshrc` — PowerShell has a single `$PROFILE` file, and plain `Set-Alias` can't carry arguments the way `alias new_venv='...'` does in bash. So `alias/aliases.ps1` defines PowerShell **functions** instead (which take precedence over PowerShell's built-in `ls`/`cat` aliases, the same way the bash aliases override the Unix builtins), and `alias/install_aliases.ps1` dot-sources that file into your `$PROFILE`:

```powershell
powershell -ExecutionPolicy Bypass -File alias\install_aliases.ps1
```

This gives you the following functions in every new PowerShell session:

| Linux alias | Windows function |
| ----------- | ---------------- |
| `utils` | `utils` — launch the installer menu |
| `m <target>` | `m <tool> [<tool> ...]` — install tools by name; `m` alone lists them |
| `new_venv` | `new_venv` |
| `persist_env` | `persist_env` (user environment variable in the registry) |
| `bashrc` / `zshrc` | `profile` — open `$PROFILE` in Sublime Text (Notepad if `subl` isn't installed) |
| `sublime` | `sublime` |
| `ls` | `ls` (eza) |
| `cat` | `cat` (bat) |
| `grep` | `grep` (ripgrep) |

`cat` and `grep` accept piped input (`git log | grep fix`). There's no `python` → `python3` alias because the Windows Python installer already names the command `python`.

## Shell Support

This project supports both Bash and Zsh shells:

- **Hybrid Alias Installation**: Automatically detects your shell and installs aliases in the correct configuration file (`~/.bash_aliases` for Bash, `~/.zshrc` for Zsh)
- **Shell Detection**: Smart detection works even when scripts are executed via `make` or other methods
- **Cross-Shell Compatibility**: Tools work in both shells, with proper error handling

## Development

Run `make lint` to execute ShellCheck on all scripts and `make test` to run the test suite in `tests/` — syntax checks plus functional tests for `install.sh`'s script discovery and the alias/env-persistence scripts (run in a sandboxed `$HOME`, so nothing on your real machine is touched), and static checks that every Linux script has a `.ps1` counterpart saved as UTF-8 with BOM.

When adding a tool, add both `tools/<name>.sh` and `tools/<name>.ps1`. winget-based installers dot-source `lib/winget.ps1` and call `Install-WingetPackage`, which handles the missing-winget and failed-install cases.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).

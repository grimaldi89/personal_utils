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

Every `tools/*.sh`, `airbyte/airbyte.sh`, and `alias/*.sh` script has a `.ps1` counterpart living right next to it (e.g. `tools/git.sh` / `tools/git.ps1`), installed with [winget](https://learn.microsoft.com/windows/package-manager/winget/) instead of `apt`. There's a PowerShell `install.ps1` mirroring `install.sh`'s interactive menu.

**Not yet run/tested on an actual Windows machine** — this environment had no `pwsh`/Windows available to execute or lint any of it, only hand-review against each tool's documented winget id and install flow. Treat it as a first pass; sanity-check before relying on it, and open an issue/PR if a winget package id has moved.

### Prerequisites

* Windows 10 (1809+) or Windows 11.
* [winget](https://learn.microsoft.com/windows/package-manager/winget/) — preinstalled on current Windows; otherwise install "App Installer" from the Microsoft Store.
* PowerShell 5.1+ (built in) or [PowerShell 7](https://github.com/PowerShell/PowerShell).

### Quick Start

```powershell
# From the repo root, in PowerShell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Or install one tool directly, e.g.:

```powershell
powershell -ExecutionPolicy Bypass -File tools\git.ps1
```

### What's covered

| Area | Windows script |
| ---- | -------------- |
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
| Aliases | `alias/install_aliases.ps1` (see below) |

**Not ported:** Zsh, Oh My Zsh, and the Spaceship theme customization don't exist natively on Windows outside WSL, and Gedit has no maintained Windows build/winget package — none of the three have a `.ps1` counterpart. If you want those specifically, use WSL and the regular Bash scripts.

### Aliases on Windows

There's no rc file to append to like `.bashrc`/`.zshrc` — PowerShell has a single `$PROFILE` file, and plain `Set-Alias` can't carry arguments the way `alias new_venv='...'` does in bash. So `alias/aliases.ps1` defines PowerShell **functions** instead (which take precedence over PowerShell's built-in `ls`/`cat` aliases, the same way the bash aliases override the Unix builtins), and `alias/install_aliases.ps1` dot-sources that file into your `$PROFILE`:

```powershell
powershell -ExecutionPolicy Bypass -File alias\install_aliases.ps1
```

This gives you `utils`, `new_venv`, `persist_env`, `profile` (edit + reload `$PROFILE`), `ls` (eza), `cat` (bat), and `grep` (ripgrep) as functions in every new PowerShell session.

## Shell Support

This project supports both Bash and Zsh shells:

- **Hybrid Alias Installation**: Automatically detects your shell and installs aliases in the correct configuration file (`~/.bash_aliases` for Bash, `~/.zshrc` for Zsh)
- **Shell Detection**: Smart detection works even when scripts are executed via `make` or other methods
- **Cross-Shell Compatibility**: Tools work in both shells, with proper error handling

## Development

Run `make lint` to execute ShellCheck on all scripts and `make test` to run the test suite in `tests/` — syntax checks plus functional tests for `install.sh`'s script discovery and the alias/env-persistence scripts (run in a sandboxed `$HOME`, so nothing on your real machine is touched).

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).

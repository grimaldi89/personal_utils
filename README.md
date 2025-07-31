# Personal Utilities

This repository provides a collection of Bash scripts to automate common setup tasks on a new machine. The scripts install modern development tools, configure aliases, and help you manage environments with support for both Bash and Zsh shells.

## Prerequisites

* Ubuntu or another Debian-based distribution with `apt` available.
* `sudo` privileges to install packages.
* [ShellCheck](https://www.shellcheck.net/) if you plan to run `make lint`.

## Directory overview

| Folder | Purpose |
| ------ | ------- |
| `tools` | Individual installers for utilities like Docker, Git, Terraform, and modern tools |
| `gcloud` | Installs the Google Cloud CLI |
| `airbyte` | Helper for installing [Airbyte](https://airbyte.io/) using Docker |
| `alias` | Convenience aliases and helper scripts with hybrid Bash/Zsh support |

The main entry point is `install.sh`, which scans these folders and presents an interactive menu so you can choose which scripts to execute.

## Available Tools

### 🛠️ Development Tools
- **Docker** - Container platform
- **Git** - Version control system
- **Terraform** - Infrastructure as Code
- **Google Cloud CLI** - Google Cloud Platform tools

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
make docker git terraform

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
make ripgrep           # Install Ripgrep (fast text search)
make open_ssh_client   # Install OpenSSH Client
make lint              # Run ShellCheck on scripts
make test              # Run script syntax tests
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
- `new_venv` - Create Python virtual environment
- `persist_env` - Persist environment variables
- `m` - Run make commands
- `sublime` - Open Sublime Text
- `ls` - Use Eza with icons and colors
- `cat` - Use Batcat with syntax highlighting

## Shell Support

This project supports both Bash and Zsh shells:

- **Hybrid Alias Installation**: Automatically detects your shell and installs aliases in the correct configuration file (`~/.bash_aliases` for Bash, `~/.zshrc` for Zsh)
- **Shell Detection**: Smart detection works even when scripts are executed via `make` or other methods
- **Cross-Shell Compatibility**: Tools work in both shells, with proper error handling

## Development

Run `make lint` to execute ShellCheck on all scripts and `make test` to run simple syntax tests.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).

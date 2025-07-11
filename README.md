# Personal Utilities

This repository provides a collection of small Bash scripts to automate common setup tasks on a new machine. The scripts install tools, configure aliases, and help you manage environments.

## Prerequisites

* Ubuntu or another Debian-based distribution with `apt` available.
* `sudo` privileges to install packages.
* [ShellCheck](https://www.shellcheck.net/) if you plan to run `make lint`.

## Directory overview

| Folder | Purpose |
| ------ | ------- |
| `tools` | Individual installers for utilities like Docker, Gedit, Git and Terraform |
| `gcloud` | Installs the Google Cloud CLI |
| `airbyte` | Helper for installing [Airbyte](https://airbyte.io/) using Docker |
| `alias` | Convenience aliases and helper scripts |

The main entry point is `install.sh`, which scans these folders and presents an interactive menu so you can choose which scripts to execute.

## Usage

1. Clone or download this repository and enter its directory.
2. Optionally review the scripts you plan to run.
3. Run the installer:

   ```bash
   # Using make
   make install

   # Or directly
   bash install.sh
   ```
4. When prompted, select the numbers corresponding to the scripts you want to run. Each script may require `sudo` privileges as it installs packages using `apt`.

Feel free to inspect each script before running it to understand what will be installed or modified on your system.

## Aliases

Run `make aliases` or execute `alias/install_aliases.sh` directly to append helpful shortcuts to your `~/.bashrc`. After running it you'll be able to launch the installer anywhere by
simply typing:

```bash
utils
```


## Development

Run `make lint` to execute ShellCheck on all scripts and `make test` to run simple syntax tests.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).

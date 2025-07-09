# Personal Utilities

This repository provides a collection of small Bash scripts to automate common setup tasks on a new machine. The scripts install tools, configure aliases, and help you manage environments.

## Directory overview

- **tools** – Installation scripts for utilities like Docker and `gedit`.
- **gcloud** – Script to install the Google Cloud CLI.
- **airbyte** – Helper for installing [Airbyte](https://airbyte.io/) using Docker.
- **alias** – Convenience aliases and helper scripts to manage them.

The main entry point is `install.sh`, which scans these folders and presents an interactive menu so you can choose which scripts to execute.

## Usage

1. Clone or download this repository and enter its directory.
2. Run the installer:

   ```bash
   bash install.sh
   ```
3. When prompted, select the numbers corresponding to the scripts you want to run. Each script may require sudo privileges as it installs packages using `apt`.

Feel free to inspect each script before running it to understand what will be installed or modified on your system.


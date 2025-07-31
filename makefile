.PHONY: install aliases docker gcloud gedit git terraform airbyte eza batcat zsh oh-my-zsh zsh-customization sublime ripgrep open_ssh_client help lint test

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "Available commands:"
	@echo "  make install           - Run main install.sh menu"
	@echo "  make aliases           - Install aliases"
	@echo "  make docker            - Install Docker"
	@echo "  make gcloud            - Install GCloud"
	@echo "  make gedit             - Install Gedit"
	@echo "  make git               - Install Git"
	@echo "  make terraform         - Install Terraform"
	@echo "  make airbyte           - Install Airbyte"
	@echo "  make eza               - Install Eza (ls replacement)"
	@echo "  make batcat            - Install Batcat (cat replacement)"
	@echo "  make zsh               - Install Zsh"
	@echo "  make oh-my-zsh         - Install Oh My Zsh"
	@echo "  make zsh-customization - Customize Zsh with themes and plugins"
	@echo "  make sublime           - Install Sublime Text"
	@echo "  make ripgrep           - Install Ripgrep (fast text search)"
	@echo "  make open_ssh_client   - Install OpenSSH Client"
	@echo "  make lint              - Run ShellCheck on scripts"
	@echo "  make test              - Run script syntax tests"

install:
	@bash $(ROOT)/install.sh

aliases:
	@bash $(ROOT)/alias/install_aliases.sh

docker:
	@bash $(ROOT)/tools/docker.sh

gcloud:
	@bash $(ROOT)/tools/gcloud.sh

gedit:
	@bash $(ROOT)/tools/gedit.sh

git:
	@bash $(ROOT)/tools/git.sh

terraform:
	@bash $(ROOT)/tools/terraform.sh

airbyte:
	@bash $(ROOT)/airbyte/airbyte.sh

eza:
	@bash $(ROOT)/tools/eza.sh

batcat:
	@bash $(ROOT)/tools/batcat.sh

zsh:
	@bash $(ROOT)/tools/zsh.sh

oh-my-zsh:
	@bash $(ROOT)/tools/oh-my-zsh.sh

zsh-customization:
	@bash $(ROOT)/tools/zsh-customization.sh

sublime:
	@bash $(ROOT)/tools/sublime.sh

ripgrep:
	@bash $(ROOT)/tools/ripgrep.sh

open_ssh_client:
	@bash $(ROOT)/tools/open_ssh_client.sh

lint:
	@shellcheck --severity=error $(shell git ls-files '*.sh')

test:
	@./tests/test_syntax.sh

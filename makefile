.PHONY: install aliases docker gcloud gedit git terraform airbyte help lint test

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help:
	@echo "Available commands:"
	@echo "  make install     - Run main install.sh menu"
	@echo "  make aliases     - Install aliases"
	@echo "  make docker      - Install Docker"
	@echo "  make gcloud      - Install GCloud"
	@echo "  make gedit       - Install Gedit"
	@echo "  make git         - Install Git"
	@echo "  make terraform   - Install Terraform"
	@echo "  make airbyte     - Install Airbyte"
	@echo "  make lint        - Run ShellCheck on scripts"
	@echo "  make test        - Run script syntax tests"

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

lint:
	@shellcheck --severity=error $(shell git ls-files '*.sh')

test:
	@./tests/test_syntax.sh

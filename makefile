.PHONY: install aliases docker gcloud gedit git terraform airbyte help

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

install:
	@bash install.sh

aliases:
	@bash alias/install_aliases.sh

docker:
	@bash tools/docker.sh

gcloud:
	@bash tools/gcloud.sh

gedit:
	@bash tools/gedit.sh

git:
	@bash tools/git.sh

terraform:
	@bash tools/terraform.sh

airbyte:
	@bash airbyte/airbyte.sh

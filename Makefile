# ==============================================================================
# Nexovia Standard (NXS) Governance Automation
# Purpose: Enforce, Validate, and Release NXS Topology Specs
# ==============================================================================

# Variables
SCHEMA_FILE := nxs_schema.toml
VERSION := $(shell grep 'version =' $(SCHEMA_FILE) | sed 's/.*"\(.*\)".*/\1/')
DIST_DIR := dist/v$(VERSION)
USER := $(shell basename -s .git `git config user.name`)
REPO := $(shell basename -s .git `git config --get remote.origin.url`)

.PHONY: all help validate release clean

help: ## Show this help message
	@echo "Nexovia Standard Automation"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

validate: ## Validate the software.toml structure
	@echo "🔍 Validating NXS Topology: $(SCHEMA_FILE)..."
	@# Basic check for mandatory NXS sections
	@grep -q "\[nxs\]" $(SCHEMA_FILE) || (echo "❌ Missing [nxs] section"; exit 1)
	@grep -q "\[topology\]" $(SCHEMA_FILE) || (echo "❌ Missing [topology] section"; exit 1)
	@grep -q "\[schema.node_keys\]" $(SCHEMA_FILE) || (echo "❌ Missing [schema.node_keys] section"; exit 1)
	@echo "✅ Validation Passed: Version $(VERSION)"

release: validate ## Package and 'release' the standard for global use
	@echo "🚀 Releasing NXS v$(VERSION)..."
	@mkdir -p $(DIST_DIR)
	@cp $(SCHEMA_FILE) $(DIST_DIR)/
	@echo "📦 Standard published to $(DIST_DIR)/$(SCHEMA_FILE)"
	@echo "🔗 Global Link: https://raw.githubusercontent.com/$(USER)/$(REPO)/main/$(DIST_DIR)/$(SCHEMA_FILE)"

tag: ## Create a git tag for this version
	@echo "🏷️ Tagging version v$(VERSION)..."
	@git tag -a v$(VERSION) -m "Nexovia Standard Release v$(VERSION)"
	@git push origin v$(VERSION)
	@echo "✅ Version v$(VERSION) tagged and pushed."

clean: ## Remove distribution artifacts
	@rm -rf dist/
	@echo "🧹 Cleaned distribution directory."
.PHONY: init update build clean help

# Configuration du sous-module
SUBMODULE_NAME := telegraf
SUBMODULE_URL := https://github.com/influxdata/telegraf.git
SUBMODULE_BRANCH ?= master
BINARY := bin/telegraf

# Couleurs pour une meilleure lisibilité
GREEN  := \\033[0;32m
YELLOW := \\033[0;33m
RED    := \\033[0;31m
NC     := \\033[0m # No Color

# Construction du sous-module et de l'application
build: update
	@if [ ! -f $(SUBMODULE_NAME)/Makefile ]; then \
		echo "${RED}Aucun Makefile trouvé dans le sous-module.${NC}"; \
		exit 1; \
	fi
	@echo "${YELLOW}Construction de $(SUBMODULE_NAME)...${NC}"
	@cd $(SUBMODULE_NAME) && make build
	@echo "${YELLOW}Construction de l'application...${NC}"
	@mkdir -p bin
	@cp $(SUBMODULE_NAME)/telegraf $(BINARY)
	@echo "${GREEN}Application construite : $(BINARY)${NC}"

# Aide
help:
	@echo "\n${YELLOW}Commandes disponibles:${NC}"
	@echo "  ${GREEN}init${NC}     - Initialise le dépôt et le sous-module"
	@echo "  ${GREEN}update${NC}  - Met à jour le sous-module"
	@echo "  ${GREEN}build${NC}   - Construit le sous-module et l'application"
	@echo "  ${GREEN}clean${NC}   - Nettoie les fichiers générés"
	@echo "  ${GREEN}help${NC}    - Affiche ce message d'aide"

# Initialisation du dépôt et du sous-module
init:
	@if [ ! -d .git ]; then \
		echo "${YELLOW}Initialisation du dépôt Git...${NC}"; \
		git init; \
	fi
	@if [ ! -d $(SUBMODULE_NAME)/.git ]; then \
		echo "${YELLOW}Ajout du sous-module $(SUBMODULE_NAME)...${NC}"; \
		git submodule add -b $(SUBMODULE_BRANCH) $(SUBMODULE_URL) $(SUBMODULE_NAME) || \
		echo "${RED}Erreur lors de l'ajout du sous-module. Vérifiez qu'il n'existe pas déjà.${NC}"; \
	else \
		echo "${GREEN}Le sous-module $(SUBMODULE_NAME) est déjà initialisé.${NC}"; \
	fi

# Mise à jour du sous-module
update:
	@if [ ! -d $(SUBMODULE_NAME)/.git ]; then \
		echo "${YELLOW}Le sous-module n'existe pas. Exécutez 'make init' d'abord.${NC}"; \
	else \
		echo "${YELLOW}Mise à jour du sous-module $(SUBMODULE_NAME)...${NC}"; \
		git submodule update --init --recursive --remote $(SUBMODULE_NAME); \
	fi

# Nettoyage
clean:
	@if [ -f $(SUBMODULE_NAME)/Makefile ]; then \
		echo "${YELLOW}Nettoyage de $(SUBMODULE_NAME)...${NC}"; \
		cd $(SUBMODULE_NAME) && $(MAKE) clean; \
	fi
	@echo "${YELLOW}Nettoyage des fichiers de l'application...${NC}"
	@rm -rf bin/

# Par défaut, affiche l'aide
.DEFAULT_GOAL := help
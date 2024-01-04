ADDON_NAME := $(shell grep '<addon id="' addon.xml |cut -d\" -f2)
VERSION := $(shell grep '  version=' addon.xml |cut -d\" -f2)
FILES = addon.xml LICENSE.txt README.md resources
REPO_NAME = repo-plugins
REPO_PLUGINS ?= ../$(REPO_NAME)
RELEASE_BRANCH ?= nexus

all: dist

dist:
	mkdir -p $(ADDON_NAME)
	cp -r $(FILES) $(ADDON_NAME)/
	zip -r $(ADDON_NAME)-$(VERSION).zip $(ADDON_NAME)/ \
		--exclude \*.pyc
	rm -r $(ADDON_NAME)

prepare_release:
	[ -d "$(REPO_PLUGINS)" ] || \
		git clone --depth 5 -b $(RELEASE_BRANCH) https://github.com/xbmc/$(REPO_NAME) "$(REPO_PLUGINS)"
	git -C $(REPO_PLUGINS) stash
	git -C $(REPO_PLUGINS) checkout $(RELEASE_BRANCH)
	rm -rf $(REPO_PLUGINS)/$(ADDON_NAME)
	mkdir $(REPO_PLUGINS)/$(ADDON_NAME)
	cp -r $(FILES) $(REPO_PLUGINS)/$(ADDON_NAME)/
# Remove files unwanted in repo edition
	$(RM) $(REPO_PLUGINS)/$(ADDON_NAME)/resources/language/Makefile
	$(RM) $(REPO_PLUGINS)/$(ADDON_NAME)/resources/fanart.svg

clean:
	rm *.zip

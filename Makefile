SHELL         := /bin/bash
PREFIX        :=
TO_DIR        := /usr/local

BIN_DIR       := $(PREFIX)$(TO_DIR)/bin
LIB_DIR       := $(PREFIX)$(TO_DIR)/lib/antiX
EXCLUDE_DIR   := $(PREFIX)$(TO_DIR)/share/excludes
LOCALE_DIR    := $(PREFIX)/usr/share/locale

EXCLUDE_FILES := $(wildcard excludes/*.list)
EXCLUDE_ORIG  := $(patsubst excludes/%.list,$(EXCLUDE_DIR)/%.orig,$(EXCLUDE_FILES))

DIRS          := $(EXCLUDE_DIR) $(LIB_DIR) $(BIN_DIR) $(LOCALE_DIR) pot-files
CP            := cp --preserve=mode -P
BIN_FILES     := $(shell find bin -xtype f -executable)
RBIN_FILES    := $(shell find bin -type f -executable)

LIB_FILES     := $(shell find lib -name "antiX-*.sh")

BIN_POTS      := $(patsubst bin/%,pot-files/%.pot,$(RBIN_FILES))
LIB_POT       := pot-files/antiX-bash-libs.pot

POT_FILES     := $(LIB_POT) $(BIN_POTS)

TX_DOMAIN     := antix-development

XGET_TEXT     := translate/xgettext-lib

.PHONY: help test install excludes pots

help:
	@echo "make help       show this help"
	@echo "make install    install scripts and libs"
	@echo "make pots       make .pot files for scripts and libs"
	@echo $(BIN_FILES)

install: $(EXCLUDE_ORIG) | $(DIRS)
	$(CP) lib/* $(LIB_DIR)/
	$(CP) excludes/*.list $(EXCLUDE_DIR)/
	$(CP) lib/* $(LIB_DIR)/
	$(CP) -r locale/* $(LOCALE_DIR)/
	$(CP) $(BIN_FILES) $(BIN_DIR)/

$(EXCLUDE_ORIG): $(EXCLUDE_DIR)/%.orig : excludes/*.list | $(EXCLUDE_DIR)
	cp -f $< $@
	chmod a-w $@

$(DIRS):
	mkdir -p $@

pots: $(POT_FILES)

$(LIB_POT): $(LIB_FILES)
	$(XGET_TEXT) --output=$@ $<
	for f in $^; do $(XGET_TEXT) -j --output=$@ $$f; done

$(BIN_POTS): pot-files/%.pot : bin/% | pot-files
	$(XGET_TEXT) --output=$@ $<

push-tx: $(LIB_POT) $(BIN_POTS)
	tx push -r antix-development.antix-bash-libs -s
	tx push -r antix-development.live-remaster -s
	tx push -r antix-development.persist-config -s
	tx push -r antix-development.persist-makefs -s
	tx push -r antix-development.persist-save -s

RESOURCES: $(POT_FILES)
	: > $@
	for x in $^; do basename $$x .pot | tr 'A-Z' 'a-z'>> $@; done

pull-po:
	for r in $$(cat RESOURCES); do tx pull -r $(TX_DOMAIN).$$r -a; done


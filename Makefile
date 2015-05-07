SHELL         := /bin/bash
PREFIX        :=
TO_DIR        := /usr/local

BIN_DIR       := $(PREFIX)$(TO_DIR)/bin
LIB_DIR       := $(PREFIX)$(TO_DIR)/lib/antiX
EXCLUDE_DIR   := $(PREFIX)$(TO_DIR)/share/excludes
EXCLUDE_FILES := $(wildcard excludes/*.list)
EXCLUDE_ORIG  := $(patsubst excludes/%.list,$(EXCLUDE_DIR)/%.orig,$(EXCLUDE_FILES))

DIRS          := $(EXCLUDE_DIR) $(LIB_DIR) $(BIN_DIR) pot
CP            := cp --preserve=mode -P
BIN_FILES     := $(shell find bin -xtype f -executable)
RBIN_FILES    := $(shell find bin -type f -executable)

LIB_FILES     := $(shell find lib -name "antiX-*.sh")

LIB_POTS      := $(patsubst lib/%.sh,pot/%.pot,$(LIB_FILES))
BIN_POTS      := $(patsubst bin/%,pot/%.pot,$(RBIN_FILES))
LIB_POT       := pot/antiX-bash-libs.pot

XGET_TEXT     := translate/xgettext-lib

.PHONY: help test install deb excludes pots

help:
	@echo "make help       show this help"
	@echo "make install    install scripts and libs"
	@echo "make clean      delete the deb/ subdirectory"
	@echo "make pots       make .pot files for scripts and libs"
	@echo $(BIN_FILES)

install: $(EXCLUDE_ORIG) | $(DIRS)
	$(CP) lib/* $(LIB_DIR)/
	$(CP) excludes/*.list $(EXCLUDE_DIR)/
	$(CP) lib/* $(LIB_DIR)/
	$(CP) $(BIN_FILES) $(BIN_DIR)/

$(EXCLUDE_ORIG): $(EXCLUDE_DIR)/%.orig : excludes/*.list | $(EXCLUDE_DIR)
	cp -f $< $@
	chmod a-w $@

$(DIRS):
	mkdir -p $@

pots: $(BIN_POTS) $(LIB_POT)

$(LIB_POT): $(LIB_FILES)
	$(XGET_TEXT) --output=$@ $<
	for f in $^; do $(XGET_TEXT) -j --output=$@ $$f; done

$(LIB_POTS): pot/%.pot : lib/%.sh | pot
	$(XGET_TEXT) --output=$@ $<

$(BIN_POTS): pot/%.pot : bin/% | pot
	$(XGET_TEXT) --output=$@ $<


deb:
	rm -rf deb
	mkdir -p deb
	make install PREFIX=deb

clean:
	rm -rf deb

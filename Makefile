SHELL         := /bin/bash
PREFIX        :=
TO_DIR        := /usr/local

BIN_DIR       := $(PREFIX)$(TO_DIR)/bin
LIB_DIR       := $(PREFIX)$(TO_DIR)/lib/antiX
EXCLUDE_DIR   := $(PREFIX)$(TO_DIR)/share/excludes
EXCLUDE_FILES := $(wildcard excludes/*.list)
EXCLUDE_ORIG  := $(patsubst excludes/%.list,$(EXCLUDE_DIR)/%.orig,$(EXCLUDE_FILES))

DIRS          := $(EXCLUDE_DIR) $(LIB_DIR) $(BIN_DIR)
CP            := cp --preserve=mode -P
BIN_FILES     := $(shell find bin -xtype f -executable)

.PHONY: help test install deb excludes

help:
	@echo "make help       show this help"
	@echo "make install    install scripts and libs"
	@echo "make clean      delete the deb/ subdirectory"
	@echo $(EXCLUDE_ORIG)

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

deb:
	rm -rf deb
	mkdir -p deb
	make install PREFIX=deb

clean:
	rm -rf deb

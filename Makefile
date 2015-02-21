SHELL       := /bin/bash
PREFIX      :=
TO_DIR      := /usr/local

BIN_DIR     := $(PREFIX)$(TO_DIR)/bin
LIB_DIR     := $(PREFIX)$(TO_DIR)/lib/antiX
EXCLUDE_DIR := $(PREFIX)$(TO_DIR)/share/excludes

CP          := cp --preserve=mode -P
BIN_FILES   := $(shell find bin -xtype f -executable)

.PHONY: help test install deb

help:
	@echo "make help       show this help"
	@echo "make install    install scripts and libs"
	@echo "make clean      delete the deb/ subdirectory"

install:
	mkdir -p $(LIB_DIR)
	$(CP) lib/* $(LIB_DIR)/
	mkdir -p $(EXCLUDE_DIR)
	$(CP) excludes/* $(EXCLUDE_DIR)/
	mkdir -p $(LIB_DIR)
	$(CP) lib/* $(LIB_DIR)/
	mkdir -p $(BIN_DIR)
	$(CP) $(BIN_FILES) $(BIN_DIR)/

deb:
	rm -rf deb
	mkdir -p deb
	make install PREFIX=deb

clean:
	rm -rf deb

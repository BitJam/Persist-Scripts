SHELL     := /bin/bash
PREFIX    :=
TO_DIR    := /usr/local

BIN_DIR   := $(PREFIX)$(TO_DIR)/bin
LIB_DIR   := $(PREFIX)$(TO_DIR)/lib/antiX
CP        := cp --preserve=mode
BIN_FILES := $(shell find bin -type f -executable)

.PHONY: help test install deb

help:
	@echo "make help       show this help"
	@echo "make install    install scripts and icons"
	@echo "make deb        install to deb/ subdirectory"
	@echo "make clean      delete the deb/ subdirectory"

install:
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

REVEAL := node node_modules/reveal-md/bin/reveal-md.js
SRC := slides-src
PDF := pdf
STATIC := slides

# Preserve `make print lec0` as well as `make COURSE=lec0 print static`.
COMMANDS := all watch print static help
COURSE ?= $(firstword $(filter-out $(COMMANDS),$(MAKECMDGOALS)))
FILES := $(if $(COURSE),$(SRC)/$(COURSE).md,$(wildcard $(SRC)/*.md))
NAMES := $(basename $(notdir $(FILES)))
rwildcard = $(foreach f,$(wildcard $(1)/*),$(if $(wildcard $(f)/.),$(call rwildcard,$(f)),$(f)))
ASSETS := $(call rwildcard,assets) $(call rwildcard,$(SRC)/images)
DEPS := $(ASSETS) Makefile scripts/export.mjs package-lock.json $(wildcard reveal*.json reveal*.json5)

.DEFAULT_GOAL := all
.PHONY: all watch print static help $(COURSE)
# PDF exports use the same server port; prevent concurrent exports colliding.
.NOTPARALLEL:
.DELETE_ON_ERROR:

all: print static

watch:
	$(if $(COURSE),,$(error Usage: make watch lec0))
	$(REVEAL) "$(SRC)/$(COURSE).md" -w

print: $(addprefix $(PDF)/,$(addsuffix .pdf,$(NAMES)))

$(PDF)/%.pdf: $(SRC)/%.md $(DEPS)
	node scripts/export.mjs print "$<" "$@"

static: $(addprefix $(STATIC)/,$(addsuffix /index.html,$(NAMES)))

$(STATIC)/%/index.html: $(SRC)/%.md $(DEPS)
	node scripts/export.mjs static "$<" "$(STATIC)/$*"

help:
	@echo "make              Export changed PDF and HTML"
	@echo "make watch lec0   Preview lec0"
	@echo "make print        Export all PDFs"
	@echo "make print lec0   Export lec0 PDF"
	@echo "make static       Export all HTML"
	@echo "make static lec0  Export lec0 HTML"
	@echo "make -B print lec0 Force export lec0 PDF"

ifneq ($(COURSE),)
$(COURSE): ;
endif

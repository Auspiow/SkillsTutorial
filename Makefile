REVEAL := npx reveal-md
SRC := SkillsTutorial/slides-src
PDF := SkillsTutorial/pdf
STATIC := SkillsTutorial/slides

COURSE := $(word 2,$(MAKECMDGOALS))
FILES := $(if $(COURSE),$(SRC)/$(COURSE).md,$(SRC)/*.md)

.DEFAULT_GOAL := all
.PHONY: all watch print static help $(COURSE)

all: print static

watch:
	@if "$(COURSE)"=="" (echo Usage: make watch lec0 & exit /b 1)
	$(REVEAL) "$(SRC)/$(COURSE).md" -w

print:
	@if not exist "$(PDF)" mkdir "$(PDF)"
	@for %%f in ($(FILES)) do @$(REVEAL) "$(SRC)/%%~nxf" --print "$(PDF)/%%~nf.pdf"

static:
	@for %%f in ($(FILES)) do @$(REVEAL) "$(SRC)/%%~nxf" --static "$(STATIC)/%%~nf"

help:
	@echo "make              Export all PDF and HTML"
	@echo "make watch lec0   Preview lec0"
	@echo "make print        Export all PDFs"
	@echo "make print lec0   Export lec0 PDF"
	@echo "make static       Export all HTML"
	@echo "make static lec0  Export lec0 HTML"

ifneq ($(COURSE),)
$(COURSE): ;
endif
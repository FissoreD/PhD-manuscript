TEXFILES := $(shell find . -type f -name '*.elpi')
PDFFILES := $(TEXFILES:.elpi=.tex)
GENERATOR := code2tex.py
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

img: $(PDFFILES)

%.tex: %.elpi
	(python $(GENERATOR) $<) && $(TEX_CMD) $@
# 	$(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)

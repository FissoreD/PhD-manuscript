TEXFILES := $(shell find . -type f -regex ".*\.\(elpi\|v\)")
PDFFILES := $(TEXFILES:.elpi=.tex)
PDFFILES := $(PDFFILES:.v=.tex)
GENERATOR := code2tex.py
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

img: $(PDFFILES)

%.tex: %.elpi
	(python3 $(GENERATOR) $<) && $(TEX_CMD) $@ && $(TEX_CMD) $@

%.tex: %.v
	(python3 $(GENERATOR) $<) && $(TEX_CMD) $@ && $(TEX_CMD) $@

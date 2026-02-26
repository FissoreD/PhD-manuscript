undefine TEX

OUT=img
GENERATOR = main.py

COQFILES := $(shell find ./elpi-formalization -type f -regex ".*\.v")
IGNFILES := $(COQFILES:.v=.ev)

TEXFILES := $(shell find . -type f -regex ".*\.tex")
PDFFILES := $(TEXFILES:.tex=.pdf)
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

main:
	$(MAKE) generator -j4 && $(MAKE) latex -j4

generator: $(IGNFILES)

latex: $(PDFFILES)

%.ev: %.v
	mkdir -p $(OUT) && python3 $(GENERATOR) $(OUT) $<

%.pdf: %.tex
	cd $(OUT) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)


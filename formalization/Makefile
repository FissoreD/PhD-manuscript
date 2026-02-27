undefine TEX

OUT=img
TH=theorem
GENERATOR = main.py

COQFILES := $(shell find ./elpi-formalization -type f -regex ".*\.v")
IGNFILES := $(COQFILES:.v=.ev)

TEXFILES := $(shell find $(OUT) -type f -regex ".*\.tex")
PDFFILES := $(TEXFILES:.tex=.pdf)
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape -halt-on-error

main:
	$(MAKE) generator -j && $(MAKE) latex -j

generator: $(IGNFILES)

latex: $(PDFFILES)

%.ev: %.v
	mkdir -p $(TH) $(OUT) && python3 $(GENERATOR) $(OUT) $< $(TH)

%.pdf: %.tex
	cd $(OUT) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)


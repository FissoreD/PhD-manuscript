undefine TEX

SRC=HO-unif-for-free/src
OUT=img
GENERATOR = main.py

ELPIFILES := $(shell find . -type f -regex ".*\.\(elpi\|v\|hs\)")
IGNFILES := $(ELPIFILES:.elpi=.ign)

TEXFILES := $(shell find . -type f -regex ".*\.tex")
PDFFILES := $(TEXFILES:.tex=.pdf)
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

test:
	cd $(SRC) && timeout 4 elpi main.elpi $(ENV) -exec "main" -- $(ONLY) $(TEX)

debug:
	cd $(SRC) && elpi main.elpi -D DEBUG -exec "main" -- $(ONLY) $(TEX)
trace:
	cd $(SRC) && elpi main.elpi -trace-on -trace-at run 1 10000 -no-tc -trace-only user -exec "main" -- $(ONLY)

generator: $(IGNFILES)

latex: $(PDFFILES)

%.ign: %.elpi
	mkdir -p $(OUT) && python3 $(GENERATOR) $(OUT) $<	

%.pdf: %.tex
	cd $(OUT) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)

main:
	$(MAKE) generator && $(MAKE) latex



.PHONY: paper

undefine TEX

SRC=HO-unif-for-free/src
OUT=img
GENERATOR = main.py

ELPIFILES := $(shell find . -type f -regex ".*\.\(elpi\|v\|hs\)")
IGNFILES := $(ELPIFILES:.elpi=.ign)

TEXFILES_img := $(shell find $(OUT) -type f -regex ".*\.tex")
PDFFILES_img := $(TEXFILES_img:.tex=.pdf)
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape -halt-on-error 

main:
	$(MAKE) links && $(MAKE) generator 
# 	&& $(MAKE) latex

test:
	cd $(SRC) && timeout 4 elpi main.elpi $(ENV) -exec "main" -- $(ONLY) $(TEX)

debug:
	cd $(SRC) && elpi main.elpi -D DEBUG -exec "main" -- $(ONLY) $(TEX)
trace:
	cd $(SRC) && elpi main.elpi -trace-on -trace-at run 1 10000 -no-tc -trace-only user -exec "main" -- $(ONLY)

generator: $(IGNFILES)

latex: $(PDFFILES_img)

%.ign: %.elpi
	mkdir -p $(OUT) && python3 $(GENERATOR) $(OUT) $<	

%.pdf: %.tex
	cd $(dir $<) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)

TEXFILES_links := $(shell find $(LOG_links) -type f -regex ".*\.tex")
PDFFILES_links := $(TEXFILES_links:.tex=.pdf)
OUT_links := links
LOG_links := log

links_pdf: $(PDFFILES_links)

links:
	mkdir -p $(OUT_links) && python3 parse_link.py $(OUT_links) logg

links_old:
	eval $$(opam env) && \
	make -C HO-unif-for-free/ test TEX=tex > $(LOG_links) && \
	mkdir -p $(OUT_links) && \
	python3 parse_link.py $(OUT_links) $(LOG_links)
# 	$(MAKE) links_pdf -j



.PHONY: paper links

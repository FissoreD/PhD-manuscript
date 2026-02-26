TEXFILES := $(shell find . -type f -name '*.tex')
PDFFILES := $(TEXFILES:.tex=.pdf)
TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

img: $(PDFFILES)

%.pdf: %.tex
	cd $(dir $<) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)

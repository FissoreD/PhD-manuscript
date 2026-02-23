FNAME=main

TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

all: img
	$(MAKE) -C code -j && \
	echo '{"security":{"enable_cwd_config": true}}' > ~/.latexminted_config && \
	$(MAKE) main

TEXFILES := $(shell find img -type f -name '*.tex')
PDFFILES := $(TEXFILES:.tex=.pdf)

img: $(PDFFILES)

%.pdf: %.tex
	cd $(dir $<) && $(TEX_CMD) $(notdir $<) && $(TEX_CMD) $(notdir $<)

main:
	${TEX_CMD} ${FNAME}.tex && \
	bibtex ${FNAME}.aux && \
	${TEX_CMD} ${FNAME}.tex && \
	${TEX_CMD} ${FNAME}.tex

update_submodule:
	git submodule update --remote

ci:
	(docker rm latex || true)  && \
	docker create --name latex dfissore/latex2025:latest && \
	docker cp ./ latex:/data/ && docker ps -a && \
	docker start -i latex && docker cp latex:/data/main.pdf . && \
	mkdir -p pdf && mv main.pdf pdf

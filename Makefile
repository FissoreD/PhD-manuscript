FNAME=main

TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape 

all:
	echo '{"security":{"enable_cwd_config": true}}' > ~/.latexminted_config && \
	$(MAKE) aux && \
	$(MAKE) full

aux:
	$(MAKE) -C code -j && \
	$(MAKE) -C img -j

bib:
	bibtex ${FNAME}

main:
	${TEX_CMD} ${FNAME}.tex

full:
	$(MAKE) main && $(MAKE) bib && $(MAKE) main && $(MAKE) main

update_submodule:
	git submodule update --remote

ci:
	(docker rm latex || true)  && \
	docker create --name latex dfissore/latex2025:latest && \
	docker cp ./ latex:/data/ && docker ps -a && \
	docker start -i latex && docker cp latex:/data/main.pdf . && \
	mkdir -p pdf && mv main.pdf pdf

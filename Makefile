MAKEFLAGS += --halt=now,fail=1
export MAKEFLAGS

FNAME=main

TEX_CMD = pdflatex -synctex=1 -interaction=nonstopmode --shell-escape -halt-on-error
SUBDIRS := img code formalization ho-for-free

all:
	echo '{"security":{"enable_cwd_config": true}}' > ~/.latexminted_config && \
	$(MAKE) aux -j && $(MAKE) full

# START AUX
aux: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ -j
# END AUX

bib:
	bibtex ${FNAME}

main:
	${TEX_CMD} ${FNAME}.tex

full:
	$(MAKE) main && $(MAKE) bib && $(MAKE) main && $(MAKE) main

update_submodule:
	git submodule update --remote

clean:
	git clean -dfx && \
	git submodule foreach --recursive git clean -dfx

ci:
	(docker rm latex || true)  && \
	$(MAKE) update_submodule && \
	docker create --name latex dfissore/latex2025-elpi:latest && \
	docker cp ./ latex:/data/ && docker ps -a && \
	docker start -i latex && docker cp latex:/data/main.pdf . && \
	mkdir -p pdf && mv main.pdf pdf

.PHONY: $(SUBDIRS)
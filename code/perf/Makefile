MAKEFLAGS += --no-print-directory

MAKEROCQ = Makerocq
PYFILE = build_tests.py
LOOP = False
NB = 10

compile:
	make build_maker
	make -f $(MAKEROCQ)

build_maker:
	rocq makefile -f _CoqProject -o $(MAKEROCQ)

py_test_coq:
	python3 $(PYFILE) $(NB) "coq" $(LOOP)

py_test_elpi:
	python3 $(PYFILE) $(NB) "elpi" $(LOOP)

py_test_elpi_prf:
	python3 $(PYFILE) $(NB) "elpi_share_prf" $(LOOP)

py_test_elpi_src:
	python3 $(PYFILE) $(NB) "elpi_share_search" $(LOOP)

all:
	make py_test_coq
	make py_test_elpi
	make py_test_elpi_prf
	make py_test_elpi_src
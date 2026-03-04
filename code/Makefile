TEXFILES := $(shell find . -type f -regex ".*\.\(elpi\|v\|hs\)")
GENERATOR := main.py

img: $(TEXFILES:%=run-%)

run-./%:
	python3 $(GENERATOR) $*

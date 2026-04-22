TEXFILES := $(shell find . -type f -regex ".*\.\(elpi\|v\|hs\|ml\)")
GENERATOR := main.py

img: $(TEXFILES:%=run-%)

run-./%:
	python3 $(GENERATOR) $*

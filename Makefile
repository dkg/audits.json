#!/usr/bin/make -f

# dependencies:

# apt install weasyprint xml2rfc ruby-kramdown-rfc2629

draft = audits.json
OUTPUT = $(draft).txt $(draft).html $(draft).xml $(draft).pdf

all: $(OUTPUT)

%.xml: $(draft).md $(wildcard *.ascii-art) $(wildcard *.json)
	kramdown-rfc < $< > $@.tmp
	mv $@.tmp $@

%.html: %.xml
	xml2rfc $< --html -o $@

%.txt: %.xml
	xml2rfc $< --text -o $@

%.pdf: %.xml
	xml2rfc $< --pdf -o $@

publish: $(draft).html
	mkdir -p public
	cp $(draft).html public/index.html

clean:
	-rm -rf $(OUTPUT) public

check-spell:
	codespell --ignore-words .ignore-words $(draft).md
check-schema:
	jv -assertformat -output detailed audits-schema.json audits.json

check: check-spell check-schema
.PHONY: clean all check publish check-spell check-schema

MD ?= $(CURDIR)/resume.md
PDF := $(MD:.md=.pdf)
HTML := $(MD:.md=.html)
CSS := $(CURDIR)/resume.css

.PHONY: resume watch clean

resume: $(PDF) $(HTML)

watch:
	\ls $(MD) $(CSS) | entr $(MAKE) resume

name := $(shell grep "^\#" $(MD) | head -1 | sed -e 's/^\#[[:space:]]*//' | xargs)

$(HTML): preamble.html $(MD) postamble.html
	\cat preamble.html | sed -e 's/___NAME___/$(name)/g' -e 's;__CSS__;$(CSS);g' > $@
	\python -m markdown -x smarty $(MD) >> $@
	\cat postamble.html >> $@

$(PDF): $(HTML) $(CSS)
	\weasyprint $< $@

clean:
	$(RM) $(HTML) $(PDF)

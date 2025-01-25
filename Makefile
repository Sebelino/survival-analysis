all: _extensions/coatless/webr htmls

htmls: q1.html q2.html q3.html q4.html

%.html: %.qmd
	quarto render $<

_extensions/coatless/webr:
	quarto add coatless/quarto-webr --no-prompt

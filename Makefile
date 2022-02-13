weave:
	cweave lcp.w && pdflatex lcp.tex

tangle:
	ctangle lcp.w

debug: tangle
	c99 -g lcp.c -lm

clean:
	rm lcp.log lcp.tex lcp.scn lcp.idx lcp.aux lcp.out a.out

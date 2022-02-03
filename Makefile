weave:
	cweave lcp.w && pdflatex lcp.tex

tangle:
	ctangle lcp.w

clean:
	rm lcp.log lcp.tex lcp.scn lcp.idx lcp.aux lcp.out
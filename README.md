# Literate Classical Physics

A [literate C program](http://www.literateprogramming.com/) written in `CWEB` that implements a classical 3D physics simulator and renderer in OpenGL.

## How to understand

Read [lcp.pdf](lcp.pdf) to understand the physics and the code.

## How to compile and run

Dependencies:
- pdflatex
- cwebx
- gcc

On Ubuntu Linux, this will install the above dependencies
```
sudo apt install texlive-latex-base texlive-latex-recommended texlive-latex-extra
 cwebx gcc
```

On MacOS, using homebrew, this will install equivalent dependencies:
```
brew install mactex
```

CWEBx is available in source form here: http://wwwmathlabo.univ-poitiers.fr/~maavl/CWEBx/

### How to 'weave' the [lcp.w](lcp.w) CWEB source code into a PDF

```
make
```

## Misc commands

```
tlmgr install pdftexcmds
```
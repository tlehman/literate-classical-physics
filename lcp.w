\documentclass[structure=hierarchic]{cweb}

\usepackage{amsfonts}
\usepackage{tikz}
\usepackage{xcolor}% http://ctan.org/pkg/xcolor
\usepackage{hyperref}% http://ctan.org/pkg/hyperref
\hypersetup{
  colorlinks=true,
  linkcolor=blue!50!red,
  urlcolor=blue!70!black,
  pdfborderstyle={/S/U/W 2}% border style will be underline of width 1pt
}

%\usepackage{multicol}
\usepackage[margin=1.0in]{geometry}

\begin{document}
\title{Literate Classical Physics}
\author{Tobi R. Lehman}
\maketitle

%\begin{multicols}{2}

@* Introduction.
This program simulates a 3D universe subject to the laws of Newtonian mechanics. The basic ontology\footnote{An ontology is a scheme defining what exists.} is a collection of rigid spheres, each with a position $(x,y,z)$, radius $r$, and a mass $m$. 

\begin{tikzpicture}
  \shade[ball color = gray!40, opacity = 0.4] (0,0) circle (2cm);
  \draw (0,0) circle (2cm);
  \draw (-2,0) arc (180:360:2 and 0.6);
  \draw[dashed] (2,0) arc (0:180:2 and 0.6);
  \fill[fill=black] (0,0) circle (1pt);
  \draw[dashed] (0,0) -- node[above]{$r_1$} (2,0);
  \draw (0,0) node[below]{$(x_1,y_1,z_1)$};
  \draw (0,2) node[below]{$m_1$};

  \shade[ball color = gray!40, opacity = 0.2] (5,0) circle (1cm);
  \draw (5,0) node{.};
  \draw (5,0) circle (1cm);
  \draw (4,0) arc (180:360:1 and 0.6);
  \draw[dashed] (6,0) arc (0:180:1 and 0.6);
  \fill[fill=black] (6,0) circle (1pt);
  \draw[dashed] (5,0) -- node[above]{$r_2$} (6,0);
  \draw (5,0) node[below]{$(x_2,y_2,z_2)$};
  \draw (5,1) node[below]{$m_2$};
\end{tikzpicture}

The bodies' positions and velocities are updated according to the Newtonian gravitational rule $\hat{F} = G\frac{m_1m_2}{r^2}$ at each time step $t$, and the scene is rendered.

This is the overall structure of the program {\tt lcp.c}

@c
@<Header files@>@/
@<Constants@>@/
@<Struct types@>@/
@<The main program@>

@ Including standard I/O to get output from the program.

@<Header files@>=
#include <stdio.h>

@ Physics has many constant values, like the speed of light $c$, the gravitational constant $G$. In this humble program, there is another constant, $dt$, the minimum number of seconds used to advance the time loop. For practical reasons, this is much larger than the Planck length.

@<Constants@>=
const float dt = 0.0001;

@ We need |C| structs that represent the essential values that define our simple ontology. A |body| has an |x|, |y|, and |z| coordinate, a radius |r|, and a mass |m|. It also has a |velocity|

@<Struct types@>=
struct vec3 {
    float x, y, z;
};
struct body {
    struct vec3 position;
    struct vec3 velocity;
    float mass;
    float radius;
};

@ Here is the general layout of the |main| function.


@<The main program@>=
int main() {
    @<Set up initial conditions of universe@>;
    @<The main time loop@>;
}

@ The initial conditions of the universe are the set of bodies, their positions, masses and velocities. The laws of physics and the inexorable march of time takes over after that. Let's start with a binary star system.

@<Set up initial conditions of universe@>=
struct body star1 = {{-1,0,0},{0,-1,0},1,1};
struct body star2 = {{1,0,0},{0,1,0},1,1};

@ The main time loop is where the simulated time flows. Each iteration of the loop adds |dt| seconds to the current time.

@<The main time loop@>=
for(int t = 0; t < 100; t += dt) {
}

@ Done

@* Rendering.
We want the state of the 3D universe to be displayed on a 2D screen.

%\end{multicols}


%\tableofcontents

\end{document}
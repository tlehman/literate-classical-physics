\documentclass[structure=hierarchic]{cweb}

\usepackage{amsfonts}
\usepackage{amsmath}
\usepackage{tikz}
\usepackage{tikz-3dplot}


%\usepackage{multicol}
\usepackage[margin=1.0in]{geometry}

\begin{document}
\title{Literate Classical Physics}
\author{Tobi R. Lehman}
\maketitle

%\begin{multicols}{2}

@* Introduction.
This program simulates a 3D universe subject to the laws of Newtonian mechanics. The basic ontology\footnote{An ontology is a scheme defining what exists.} is a collection of rigid bodies, shaped like spheres, each with a position $(x,y,z)$, a velocity $\vec{v}$, radius $r$, and a mass $m$. 

\begin{tikzpicture}
  \shade[ball color = gray!40, opacity = 0.4] (0,0) circle (2cm);
  \draw (0,0) circle (2cm);
  \draw (-2,0) arc (180:360:2 and 0.6);
  \draw[dashed] (2,0) arc (0:180:2 and 0.6);
  \fill[fill=black] (0,0) circle (1pt);
  \draw[dashed] (0,0) -- node[above]{$r_1$} (2,0);
  \draw (0,0) node[below]{$(x_1,y_1,z_1)$};
  \draw (0,2) node[below]{$m_1$};
  \draw [-stealth](0,0) -> (2,1) node[right]{$\vec{v_1}$};

  \shade[ball color = gray!40, opacity = 0.2] (5,0) circle (1cm);
  \draw (5,0) node{.};
  \draw (5,0) circle (1cm);
  \draw (4,0) arc (180:360:1 and 0.6);
  \draw[dashed] (6,0) arc (0:180:1 and 0.6);
  \fill[fill=black] (6,0) circle (1pt);
  \draw[dashed] (5,0) -- node[above]{$r_2$} (6,0);
  \draw (5,0) node[below]{$(x_2,y_2,z_2)$};
  \draw (5,1) node[below]{$m_2$};
  \draw [-stealth](5,0) -> (4.5,1.76) node[right]{$\vec{v_2}$};
\end{tikzpicture}

The collection of all bodies in the simulation is called the Universe. The state of the Universe is the collection of positions and velocities of all the bodies. The state is updated at each time step $t$. The state update rule is based on the law of Newtonian gravity:

$$\vec{F_{12}} = G\frac{m_1m_2}{r^2}\hat{r}$$

To understand how this law applies, remember that force is proportional to acceleration, and acceleration is the rate of change of velocity. In vector form: $\vec{F} = m\vec{a}$, and $\vec{a} = \frac{d}{dt}\vec{v}$. Now that we have connected the force law to the state of the Universe, we can guess how to update the state and compute the next moment. We take all pairs of bodies $(i, j)$ and calculate the forces between them $\vec{F_{ij}}$

@ Newtonian physics introduced the idea that the force on any body is the sum of all the forces acting on it. To calculate the total force on the $i$th body, in an $n$-body system, sum over all the $n-1$ other bodies' force on $i$.


\begin{tikzpicture}
  \shade[ball color = gray!40, opacity = 0.2] (5,0) circle (1cm);
  \draw (6.5,-0.5) node[below]{$i\text{th body}$};
  \draw (5,0) node{.};
  \draw (5,0) circle (1cm);
  \draw (4,0) arc (180:360:1 and 0.6);
  \draw[dashed] (6,0) arc (0:180:1 and 0.6);
  \fill[fill=black] (6,0) circle (1pt);
  \draw [-stealth](2.5,0.06) -> (5,0);
  \draw (2.5,0.06) node[left] {$\vec{F_{i1}}$}; 
  \draw [-stealth](3.5,1.0) -> (5,0);
  \draw (3.5,1.0) node[left] {$\vec{F_{i2}}$}; 
  \draw [-stealth](3.0,-1.3) -> (5,0);
  \draw (3.0,-1.3) node[left] {$\vec{F_{i3}}$}; 
  \draw [-stealth](5,0) -> (11, 0.24);
  \draw (11, 0.24) node[right] {$\sum_{j=1}^3{\vec{F}_{ij}}$};
\end{tikzpicture}

$\underbrace{\sum_j\vec{F_{ij}}}_\text{sum of all forces acting on the i-th body} = m_i\vec{a}_i$

@ From the above section, we can see how to calculate the force on each body at any given moment in time. This loop finds the instananeous snapshot of all forces in the simulation. These forces will then be applied to the bodies to update their velocities and positions.

@<Loop over all bodies, add up forces and apply the force to the body@>=
for(int i = 0; i < number_of_bodies; i++) {
  body *ith_body = &bodies[i];
  vec3 force_on_ith_body = {0,0,0};
  for(int j = 0; j < number_of_bodies; j++) {
    body *jth_body = &bodies[j];
    if(i != j) {
      vec3 force_from_j_on_i = {0,0,0};
      force_between(ith_body, jth_body, &force_from_j_on_i);
      vec3_add(&force_on_ith_body, &force_from_j_on_i);
    }
  }
  @<Apply the force to the body@>;
}


@ Now that |force_on_ith_body| has been calculated, we use Newton's equations: $\vec{F} = m\vec{a}$, and the fact from calculus that $\vec{a} = \frac{d}{dt}\vec{v}$ to update the velocity of the $i$th body. The change in acceleration of the $i$th body over the |dt| time step is equal to $\vec{F}/m$ where $m$ is the mass of the body.

@<Apply the force to the body@>=
float m = ith_body->mass;
ith_body->velocity.x += (force_on_ith_body.x / m) * dt;
ith_body->velocity.y += (force_on_ith_body.y / m) * dt;
ith_body->velocity.z += (force_on_ith_body.z / m) * dt;

ith_body->position.x += ith_body->velocity.x * dt;
ith_body->position.y += ith_body->velocity.y * dt;
ith_body->position.z += ith_body->velocity.z * dt;

@ When applying the force, we update the state. Here is where we define the C structs that store that state.

The |vec3| type is a triple of real numbers, represented by IEEE 754 floating pointer numbers. I am choosing to overload the notion of "point" and "vector", and use vectors to represent points. For Newtonian physics this works, in Relativity, there is a distinction between points and 4-vectors, but this program is decidedly non-relativistic.

A |body| has a |position|, a |velocity|, a radius |r|, and a mass |m|. 

@<Struct types@>=
typedef struct vec3 {
    float x, y, z;
} vec3;
typedef struct body {
    vec3 position;
    vec3 velocity;
    float mass;
    float radius;
} body;

@ This is the overall structure of the program {\tt lcp.c}

@c
@<Header files@>@/
@<Constants@>@/
@<Struct types@>@/
@<Rendering function@>@/
@<Distance function@>@/
@<Function definitions@>@/
@<The main program@>

@ The |distance| function is essential to calculating the force between two bodies.

@<Distance function@>=
float distance(body *a, body *b) {
  float dx = a->position.x - b->position.x;
  float dy = a->position.y - b->position.y;
  float dz = a->position.z - b->position.z;

  return sqrtf(dx*dx + dy*dy + dz*dz);
}

@ Here is the general layout of the |main| function.


@<The main program@>=
int main() {
    @<Set up initial conditions of universe@>;
    @<The main time loop@>;
}

@ The initial conditions of the universe are the set of bodies, their positions, masses and velocities. The laws of physics and the inexorable march of time takes over after that. Let's start with a binary star system. The |body[]| type is an array of |body|s, the two bodies in this example are two stars orbiting each other. We make use of the fact that two equal mass bodies will form a stable binary orbit of their speed is $Gm/4r$ and they are distance $r$ apart, each traveling in opposite directions:

@<Set up initial conditions of universe@>=
int number_of_bodies = 2;
float mass = 10.0;

float radius = 2;

float v = sqrtf((G * mass)/(4 * radius));

body bodies[] = {
  {{-1,0,0},{0,v,0},mass,1},
  {{1,0,0},{0,-v,0},mass,1}
};

@ The main time loop is where the simulated time flows. Each iteration of the loop adds |dt| seconds to the current time.

@<The main time loop@>=
for(float t = 1.0; t < 1000.0; t += dt) {
  @<Loop over all bodies, add up forces and apply the force to the body@>;
}

@ Physics has many constant values, like the speed of light $c$, the gravitational constant $G$. In this humble program, there is another constant, $dt$, the minimum number of seconds used to advance the time loop. For practical reasons, this is much larger than the Planck length.

@<Constants@>=
const float dt = 0.00001;
const int G = 1;



@ In a previous section we used a few functions we haven't defined yet, one calculates the graviational force between two bodies, the other does vector addition. In the typical C style, we pass pointers to our structs as a way to get return values.

@<Function definitions@>=
void force_between(body *a, body *b, vec3 *f) {
  float m_a = a->mass;
  float m_b = b->mass;
  float r = distance(a, b);
  float magnitude = (G * m_a * m_b)/(r*r);

  f->x = magnitude * (b->position.x - a->position.x)/r;
  f->y = magnitude * (b->position.y - a->position.y)/r; 
  f->z = magnitude * (b->position.z - a->position.z)/r;
}
void vec3_add(vec3 *output, vec3 *to_add) {
  output->x += to_add->x;
  output->y += to_add->y;
  output->z += to_add->z;
}

@ We need standard I/O and the math library (remember to compile with {\tt -lm})

@<Header files@>=
#include <stdio.h>
#include <math.h>

@* Rendering.
We want the state of the 3D universe to be displayed on a 2D screen. For this we will build a ray tracer. A ray tracer simulates rays of light that reflect off objects in the 3D scene and then hit the camera. 

\newcommand{\boundellipse}[3]% center, xdim, ydim
{(#1) ellipse (#2 and #3)}

\tdplotsetmaincoords{70}{110}
\begin{tikzpicture}[scale=3,tdplot_main_coords]
    \filldraw[
        draw=gray,%
        fill=gray!20,%
    ]          (0,1,0)
            -- (2,1,0)
            -- (2,1,2)
            -- (0,1,2)
            -- cycle;
    \draw[thick,->] (0,0,0) -- (1,0,0) node[anchor=north east]{$x$};
    \draw[thick,->] (0,0,0) -- (0,2,0) node[anchor=north west]{$y$};
    \draw[thick,->] (0,0,0) -- (0,0,2) node[anchor=south]{$z$};

  \shade[ball color = blue!40, opacity = 0.2]
        (1,4,1.5) circle (0.5cm);
  \draw (1,4,1.5) node{.};
  \draw (1,4,1.5) circle (0.5cm);

  \draw[black,dash pattern= on 3pt off 5pt] (1,0,1) -- (1,4,2.05);
  \draw[black,dash pattern= on 3pt off 5pt] (1,0,1) -- (1,4,0.95);
  \draw (1,0,0.95) node[anchor=north]{$O \text{ the observer}$};
  \draw (1,0,0.85) node[anchor=north]{$\text{ is at } (1,0,1)$};

  \draw (1,1.01,1.09) node{$P$};
  \draw[thick, blue] (1, 1, 1.125) [y={(0,0,1)}] circle (0.125);

  \draw[thick,->] (1,0,1) -- (1,3.5,1.6) node[anchor=north east]{$\ell$};


\end{tikzpicture}

Light travels along the shortest path through space. In Newtonian mechanics, space is Euclidean, so that means light travels in a straight line. The way to simulate light that hits the 2D screen is to pick a point that corrsponds to a pixel, then trace that light backwards to see what objects it bounced off of.

To trace a ray of light, we can take the point $O$, the observer, and the point $P$ that is mapped to the pixel. Let $\ell$ be the line defined by $O$ and $P$. If $\ell$ does not intersect any bodies, then color that pixel black. Otherwise, color the pixel based on the surface color and the distance from $O$ (farther away is assumed to be darker).

The line $\ell$ can be parameterized like this $\vec{\ell}(s) = \vec{O} + s\hat{\ell}$. The surface of the $i$th spherical body is described by the inequality $(\vec{x} - \vec{C})\cdot(\vec{x} - \vec{C}) < r^2$. We can substitute the line equation into the sphere and solve the resulting quadratic to find if it intersects or not.

@<Trace ray of light incident on pixel@>=
TODO

@ Before we can define the pixel space, we need to choose a pixel |width| and |height|.

@<Constants@>+=
const int pixel_width = 800;
const int pixel_height = 600;

@ Pick a pixel $(p_i, p_j)$, then calculate the line from the observer $O$ through $(p_i, 1, p_j)$, which is the 3D position of the pixel on the gray 2D screen.

@<Rendering function@>=
void render(body bodies[]) {
  for(int i = 0; i < pixel_width;i++) {
    for(int j = 0; j < pixel_height; j++) {
       @<Trace ray of light incident on pixel@>;
       @<Store color for pixel@>;
    }
  }
}

@ Now that we have calculated and stored all the pixel colors, we want to display them. For the initial version of the program, we will use the excellent stb libraries to write a BMP file as output.

@<Store color for pixel@>=
TODO

@ Next step: 

%\end{multicols}


%\tableofcontents

\end{document}

/*2:*/
#line 51 "lcp.w"

/*12:*/
#line 178 "lcp.w"

#include <stdio.h> 
#include <math.h> 

/*:12*/
#line 52 "lcp.w"

/*8:*/
#line 121 "lcp.w"

const float dt= 0.00001;
const int G= 1;

/*:8*/
#line 53 "lcp.w"

/*3:*/
#line 65 "lcp.w"

typedef struct vec3{
float x,y,z;
}vec3;
typedef struct body{
vec3 position;
vec3 velocity;
float mass;
float radius;
}body;

/*:3*/
#line 54 "lcp.w"

/*4:*/
#line 78 "lcp.w"

float distance(body*a,body*b){
float dx= a->position.x-b->position.x;
float dy= a->position.y-b->position.y;
float dz= a->position.z-b->position.z;

return sqrtf(dx*dx+dy*dy+dz*dz);
}

/*:4*/
#line 55 "lcp.w"

/*11:*/
#line 159 "lcp.w"

void force_between(body*a,body*b,vec3*f){
float m_a= a->mass;
float m_b= b->mass;
float r= distance(a,b);
float magnitude= (G*m_a*m_b)/(r*r);

f->x= magnitude*(b->position.x-a->position.x)/r;
f->y= magnitude*(b->position.y-a->position.y)/r;
f->z= magnitude*(b->position.z-a->position.z)/r;
}
void vec3_add(vec3*output,vec3*to_add){
output->x+= to_add->x;
output->y+= to_add->y;
output->z+= to_add->z;
}

/*:11*/
#line 56 "lcp.w"

/*5:*/
#line 90 "lcp.w"

int main(){
/*6:*/
#line 98 "lcp.w"

int n= 2;
float m= 10.0;

float r= 2;

float v= sqrtf((G*m)/(4*r));

body bodies[]= {
{{-1,0,0},{0,v,0},m,1},
{{1,0,0},{0,-v,0},m,1}
};

/*:6*/
#line 92 "lcp.w"
;
/*7:*/
#line 113 "lcp.w"

for(float t= 1.0;t<1000.0;t+= dt){
/*9:*/
#line 129 "lcp.w"

for(int i= 0;i<n;i++){
body*a= &bodies[i];
vec3 force_on_a= {0,0,0};
for(int j= 0;j<n;j++){
body*b= &bodies[j];
if(i!=j){
vec3 force_from_b_on_a= {0,0,0};
force_between(a,b,&force_from_b_on_a);
vec3_add(&force_on_a,&force_from_b_on_a);
}
}
/*10:*/
#line 146 "lcp.w"

float m= a->mass;
a->velocity.x+= (force_on_a.x/m)*dt;
a->velocity.y+= (force_on_a.y/m)*dt;
a->velocity.z+= (force_on_a.z/m)*dt;

a->position.x+= a->velocity.x*dt;
a->position.y+= a->velocity.y*dt;
a->position.z+= a->velocity.z*dt;


/*:10*/
#line 141 "lcp.w"
;
}

/*:9*/
#line 115 "lcp.w"
;
/*14:*/
#line 187 "lcp.w"

printf(
"(%f, %f, %f), (%f, %f, %f)\n",
bodies[0].position.x,bodies[0].position.y,bodies[0].position.x,
bodies[1].position.x,bodies[1].position.y,bodies[1].position.x
);

/*:14*/
#line 116 "lcp.w"
;
}

/*:7*/
#line 93 "lcp.w"
;
}

/*:5*/
#line 57 "lcp.w"


/*:2*/

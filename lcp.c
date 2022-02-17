/*6:*/
#line 123 "lcp.w"

/*13:*/
#line 203 "lcp.w"

#include <stdio.h> 
#include <math.h> 

/*:13*/
#line 124 "lcp.w"

/*11:*/
#line 176 "lcp.w"

const float dt= 0.00001;
const int G= 1;



/*:11*//*15:*/
#line 251 "lcp.w"

const int pixel_width= 800;
const int pixel_height= 600;

/*:15*/
#line 125 "lcp.w"

/*5:*/
#line 110 "lcp.w"

typedef struct vec3{
float x,y,z;
}vec3;
typedef struct body{
vec3 position;
vec3 velocity;
float mass;
float radius;
}body;

/*:5*/
#line 126 "lcp.w"

/*16:*/
#line 257 "lcp.w"

void render(body bodies[]){
for(int i= 0;i<pixel_width;i++){
for(int j= 0;j<pixel_height;j++){
/*14:*/
#line 246 "lcp.w"

TODO

/*:14*/
#line 261 "lcp.w"
;
/*17:*/
#line 269 "lcp.w"

TODO

/*:17*/
#line 262 "lcp.w"
;
}
}
}

/*:16*/
#line 127 "lcp.w"

/*7:*/
#line 134 "lcp.w"

float distance(body*a,body*b){
float dx= a->position.x-b->position.x;
float dy= a->position.y-b->position.y;
float dz= a->position.z-b->position.z;

return sqrtf(dx*dx+dy*dy+dz*dz);
}

/*:7*/
#line 128 "lcp.w"

/*12:*/
#line 184 "lcp.w"

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

/*:12*/
#line 129 "lcp.w"

/*8:*/
#line 146 "lcp.w"

int main(){
/*9:*/
#line 154 "lcp.w"

int number_of_bodies= 2;
float mass= 10.0;

float radius= 2;

float v= sqrtf((G*mass)/(4*radius));

body bodies[]= {
{{-1,0,0},{0,v,0},mass,1},
{{1,0,0},{0,-v,0},mass,1}
};

/*:9*/
#line 148 "lcp.w"
;
/*10:*/
#line 169 "lcp.w"

for(float t= 1.0;t<1000.0;t+= dt){
/*3:*/
#line 76 "lcp.w"

for(int i= 0;i<number_of_bodies;i++){
body*ith_body= &bodies[i];
vec3 force_on_ith_body= {0,0,0};
for(int j= 0;j<number_of_bodies;j++){
body*jth_body= &bodies[j];
if(i!=j){
vec3 force_from_j_on_i= {0,0,0};
force_between(ith_body,jth_body,&force_from_j_on_i);
vec3_add(&force_on_ith_body,&force_from_j_on_i);
}
}
/*4:*/
#line 94 "lcp.w"

float m= ith_body->mass;
ith_body->velocity.x+= (force_on_ith_body.x/m)*dt;
ith_body->velocity.y+= (force_on_ith_body.y/m)*dt;
ith_body->velocity.z+= (force_on_ith_body.z/m)*dt;

ith_body->position.x+= ith_body->velocity.x*dt;
ith_body->position.y+= ith_body->velocity.y*dt;
ith_body->position.z+= ith_body->velocity.z*dt;

/*:4*/
#line 88 "lcp.w"
;
}


/*:3*/
#line 171 "lcp.w"
;
}

/*:10*/
#line 149 "lcp.w"
;
}

/*:8*/
#line 130 "lcp.w"


/*:6*/

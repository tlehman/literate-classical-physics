/*1:*/
#line 52 "lcp.w"

/*2:*/
#line 60 "lcp.w"

#include <stdio.h> 

/*:2*/
#line 53 "lcp.w"

/*3:*/
#line 65 "lcp.w"

const float dt= 0.0001;

/*:3*/
#line 54 "lcp.w"

/*4:*/
#line 70 "lcp.w"

struct vec3{
float x,y,z;
};
struct body{
struct vec3 position;
struct vec3 velocity;
float mass;
float radius;
};

/*:4*/
#line 55 "lcp.w"

/*5:*/
#line 84 "lcp.w"

int main(){
/*6:*/
#line 92 "lcp.w"

struct body star1= {{-1,0,0},{0,-1,0},1,1};
struct body star2= {{1,0,0},{0,1,0},1,1};

/*:6*/
#line 86 "lcp.w"
;
/*7:*/
#line 98 "lcp.w"

for(int t= 0;t<100;t+= dt){
}

/*:7*/
#line 87 "lcp.w"
;
}

/*:5*/
#line 56 "lcp.w"


/*:1*/

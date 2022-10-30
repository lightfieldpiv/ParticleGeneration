#define _USE_MATH_DEFINES
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <vector>
#include <algorithm>
#include <iostream>
#include "mex.h"

using namespace std;

/* Input Arguments */
#define Orig	prhs[0]	// The origin point of ray 
#define DIR		prhs[1]	// The direction of ray
#define VertX	prhs[2]	// The center of sphere X
#define VertY	prhs[3]	// The center of sphere Y
#define VertZ	prhs[4]	// The center of sphere Z
#define Radi	prhs[5]	// The radius of sphere 
#define para  	prhs[6] // The parameters 

/* Output Arguments */
#define flag 	plhs[0] 	// x
#define tNear 	plhs[1] 	// point

// 
struct p4 {
	double v1;
	double v2;
	double v3;
    double v4;
};

struct p3 {
	double x;
	double y;
	double z;
};

struct p2 {
	double x;
	double y;
};

int num_sphere;
p3 orig;
p3 dir;

p3 Minus(p3 v1, p3 v2)
{
	p3 v;
	v.x = v1.x - v2.x;
	v.y = v1.y - v2.y;
	v.z = v1.z - v2.z;
	return v;
}

double dot(p3 v1, p3 v2)
{
	return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
}

p3 cross(p3 v1, p3 v2)
{
	p3 v;
	v.x = v1.y*v2.z - v1.z*v2.y;
	v.y = v1.z*v2.x - v1.x*v2.z;
	v.z = v1.x*v2.y - v1.y*v2.x; 
	return v;
}

bool raySphereIntersect(p3 center, double radi, double &t)
{
	double t0, t1; // solutions for t if the ray intersects
	double radius2 = radi*radi; 
	// geometric solution
	p3 L = Minus(center, orig);
	float tca = dot(L, dir); 
	if (tca < 0)
	{
		return 0; 
	}
		
	double d2 = dot(L, L) - tca * tca; 

	if (d2 > radius2) 
	{
		return 0; 
	}

	double thc = sqrt(radius2 - d2); 
	t0 = tca - thc; 
	t1 = tca + thc; 

	if (t0 > t1) 
	{
		swap(t0, t1);
	}

	if (t0 < 0)
	{ 
		t0 = t1; // if t0 is negative, let's use t1 instead 
		if (t0 < 0) 
		{
			return 0;
		} // both t0 and t1 are negative 
	} 

	t = t0; 

	return 1; 
	
}

void InterSectionMesh(double *vertx_pt, double *verty_pt, double *vertz_pt, double *radi_pt, double *flag_pt, double *tNear_pt)
{
	p3 center;
	for (int i = 0; i < num_sphere; i++)
	{
		center.x = vertx_pt[i]; center.y = verty_pt[i]; center.z = vertz_pt[i];
		double radi = radi_pt[i];
		double t = -1.0;
		flag_pt[i] = raySphereIntersect(center, radi, t);
		tNear_pt[i] = t;
	}
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	/* Check for proper number of arguments */
	if (nrhs != 7)
		mexErrMsgTxt("7 input arguments required.");
	else if (nlhs > 2)
		mexErrMsgTxt("Too many output arguments.");

	/* Assign pointers to the various parameters */
	double *orig_pt 	= mxGetPr(Orig);
	double *dir_pt	 	= mxGetPr(DIR);
	double *vertx_pt 	= mxGetPr(VertX);
	double *verty_pt 	= mxGetPr(VertY);
	double *vertz_pt 	= mxGetPr(VertZ);
	double *radi_pt 	= mxGetPr(Radi);
	double *para_pt 	= mxGetPr(para);

    // set the origin point
	orig.x = orig_pt[0];
	orig.y = orig_pt[1];
	orig.z = orig_pt[2];

	dir.x = dir_pt[0];
	dir.y = dir_pt[1];
	dir.z = dir_pt[2];

	num_sphere = para_pt[0];

	/* Create the output matrix */
	flag = mxCreateNumericMatrix(1, num_sphere, mxDOUBLE_CLASS, mxREAL);
	double *flag_pt = (double *)mxGetData(flag);

	tNear = mxCreateNumericMatrix(1, num_sphere, mxDOUBLE_CLASS, mxREAL);
	double *tNear_pt = (double *)mxGetData(tNear);

	InterSectionMesh(vertx_pt, verty_pt, vertz_pt, radi_pt, flag_pt, tNear_pt);

	// delete some variable...
}
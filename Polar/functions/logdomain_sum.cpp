#include <math.h>
#include <matrix.h>
#include <mex.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	/*
		function z=logdomain_sum(x,y)
		%
		if(x<y)
		    z = y+log(1+exp(x-y));
		else
		    z = x+log(1+exp(y-x));
		end
		end
	*/

	mexPrintf("new");

	int XM,XN, YM, YN;
	double *X, *Y, *Z;

	XM = mxGetM(prhs[0]); // number of rows
	XN = mxGetN(prhs[0]); // number of cols in input matrix

	YM = mxGetM(prhs[1]); // number of rows
	YN = mxGetN(prhs[1]); // number of cols in input matrix


	if (XM== 1 && XN == 1 && YM == 1 && YN == 1)
	{
		X = mxGetPr(prhs[0]);
		Y = mxGetPr(prhs[1]);

		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);  
		Z = mxGetPr(plhs[0]); 		

		double x = X[0];
		double y = Y[0];
		double z;
		if(x<y)
	    		z = y+log(1+exp(x-y));
		else
	    		z = x+log(1+exp(y-x));

		Z[0] = z;
		
	}
	else
	{
		mexPrintf("Incorrect Dimensions of input");
	}

	
}

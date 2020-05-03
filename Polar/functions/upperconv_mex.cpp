#include <math.h>
#include <matrix.h>
#include <mex.h>

double logdomain_sum(double x, double y);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
// 	mexPrintf("newupper");
	double *LLR1, *LLR2, *LLR;

	LLR1 = mxGetPr(prhs[0]);
	LLR2 = mxGetPr(prhs[1]);

	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);  
	LLR = mxGetPr(plhs[0]); 		

 	double llr1 = LLR1[0];
	double llr2 = LLR2[0];

 	double llr = logdomain_sum(llr1+llr2,0) - logdomain_sum(llr1,llr2);
	LLR[0] = llr;
		
	


}

double logdomain_sum(double x, double y){
	
	double z;	
	if(x<y)
		z = y+log(1+exp(x-y));
	else
		z = x+log(1+exp(y-x));
	
	return z;


}



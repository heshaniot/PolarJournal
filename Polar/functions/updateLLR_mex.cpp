#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <bitset> 

double logdomain_sum(double x, double y);
double lowerconv(double l1, double l2, double l3);
double upperconv(double llr1, double llr2);


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// Note: this function will return the SCLparams_LLR updated one (as a 1D array)
	
	double *L, *I, *PCparams_n, *SCLparams_LLR, *SCLparams_BITS;

	L = mxGetPr(prhs[0]);
	I = mxGetPr(prhs[1]);


	PCparams_n = mxGetPr(prhs[2]);
	SCLparams_LLR = mxGetPr(prhs[3]);
	SCLparams_BITS = mxGetPr(prhs[4]);
	int M_L = mxGetM(prhs[3]); // row count of llr
	int N_L = mxGetN(prhs[3]);
 	int M_B = mxGetM(prhs[4]); // row count of bits


	const int n = 8 ; //(int)PCparams_n[0]; // HERE IS AN ISSUE. n HAS TO BE A CONSTANT. IS IT SO ?
	int i = (int)I[0];
	int l = (int)L[0];


	int nextlevel;
	if (i==1)
    		nextlevel=n;
	else
	{
 
		std::string i_bin = std::bitset<n>(i-1).to_string(); //to binary
		int lastlevel = 1;
		for (lastlevel =1; lastlevel <= n; lastlevel++)
			if ( i_bin[lastlevel-1] == '1')
				break;

		//%%%%% Initialize with lowerconv() %%%%%%
		int st = 2^(lastlevel-1);
		int ed = 2^(lastlevel) -1;
 
		for (int indx = st; indx <= ed ; indx++)
		{   SCLparams_LLR[l-1 + M_L*(indx-1)] = lowerconv(SCLparams_BITS[2*l-1 - 1 + M_B*(indx-1)], SCLparams_LLR[l-1 + M_L*(ed+2*(indx-st)+1 - 1)],   SCLparams_LLR[l-1 + M_L*(ed+2*(indx-st)+2 - 1)]);
		}
		nextlevel = lastlevel-1;
		//    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	}

	for (int lev = nextlevel; lev >= 1; lev--)
	{
	    int st = 2^(lev-1);
	    int ed = 2^lev - 1;
	    for (int indx = st; indx <= ed; indx++) 
	    {
		SCLparams_LLR[(l-1) + M_L*(indx-1)] = upperconv(SCLparams_LLR[l-1 + M_L*(ed+2*(indx-st)+1 - 1)], SCLparams_LLR[l-1 + M_L*(ed+2*(indx-st)+2-1)]);
	    }
	} 

	plhs[0] = mxCreateDoubleMatrix(M_L*N_L,1, mxREAL); // Create the output matrix 
	double * out = mxGetPr(plhs[0]); // Get the pointer to the data of B  - just like getting pointer to the input (line 40)

	for (int i = 0; i < M_L*N_L;i++)
		out[i] = SCLparams_LLR[i];

}

// IF U DEFINE A FUNCTION BELOW LIKE THIS, DON'T FORGET TO DECLARE IT IN THE TOP. OTHERWISE U GET A COMPILE ERROR.
double lowerconv(double upperdecision, double upperllr, double lowerllr)
{
	double llr;	
	if (upperdecision==0)
	    llr = lowerllr + upperllr;
	else
	    llr = lowerllr - upperllr;
	return llr;

}


double upperconv(double llr1, double llr2)
{ 
 	double llr = logdomain_sum(llr1+llr2,0) - logdomain_sum(llr1,llr2);
}

double logdomain_sum(double x, double y){
	
	double z;	
	if(x<y)
		z = y+log(1+exp(x-y));
	else
		z = x+log(1+exp(y-x));
	
	return z;


}

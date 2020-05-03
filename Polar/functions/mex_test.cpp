#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <bitset> 
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int N1,N2, N;
    double *X, *Y, *Z;
   
    N1 = mxGetN(prhs[0]); // number of cols
	N2 = mxGetN(prhs[1]); // number of cols in input matrix

    if (N1==1 && N2==1){
       
        X = mxGetPr(prhs[0]);
		Y = mxGetPr(prhs[1]);
        
        plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);  
		Z = mxGetPr(plhs[0]); 
        
        Z[0]=X[0]+Y[0];

     mexPrintf("\n x+y= %f\n",Z[0]);

    
    
    
    }
    
    
    
    
  	/*
	int M, N;
	double *In1, *In2, *In3, *Out1, *Out2;
 	
	// So to get back the 1d to 2 again. first we need to know the dims
	M = mxGetM(prhs[0]); // number of rows
	N = mxGetN(prhs[0]); // number of cols in input matrix

	In1 = mxGetPr(prhs[0]); // get pointer to the array 
 	*/
// 	const int n = 8;
// 	int i = 10;
// 
// 	std::string i_bin = std::bitset<n>(i-1).to_string(); //to binary
// 	int lastlevel = 1;
// 	//mexPrintf("In bin: %s\n", i_bin);
// 	mexPrintf("looping over\n");
// 	for (lastlevel =1; lastlevel <= n; lastlevel++)
// 	{ 
// 		mexPrintf("%c", i_bin[lastlevel-1]);	
// 		if ( i_bin[lastlevel-1] == '1')
// 			mexPrintf(",");
// 	}


}
 




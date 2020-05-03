/* ========================================================================
** Title       : Definitions for MEX coding
** File        : mexheader.h
** ------------------------------------------------------------------------
**
** Description :
**
**   C header file with several useful definitions for MATLAB 
**   MEX programming
**
** ------------------------------------------------------------------------
** Revisions   :
**   Date       Version  Author  Description
**   11-dec-11  1.4      studer  cleanup for reproducible research
**   13-sep-04  1.0      apburg  adapted for soft-viterbi
**   12-nov-01  1.0      mimo    file created
** -------------------------------------------------------------------------
**   (C) 2006-2010 Communication Theory Group                      
**   ETH Zurich, 8092 Zurich, Switzerland                               
**   Author: Dr. Christoph Studer (e-mail: studer@rice.edu) 
** ====================================================================== */

#ifndef __MEXHEADER__
#define __MEXHEADER__

#include <mex.h>
#include <math.h>
#include <string.h>

#define MAX(a,b) ((a)>(b) ? (a) : (b))
#define NIL 0L
#define nil 0L

typedef mxArray * mxArrayPtr;
typedef const mxArray * mxArrayConstPtr;
typedef double * doublePtr;

#endif

/* ========================================================================
** Title       : Interface definition header file for matrixarith.c
** File        : matrixarith.h
** ------------------------------------------------------------------------
**
** Description :
**
**   Native C implementations of basic matrix arithmetic
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
** ========================================================================== */

#ifndef __MATRIXARITH__
#define __MATRIXARITH__

#include "mexheader.h"

void matrixMultiply(mxArrayConstPtr R, mxArrayConstPtr A, mxArrayConstPtr B);
void matrixSubtract(mxArrayConstPtr R, mxArrayConstPtr A, mxArrayConstPtr B);
double matrixFrobeniusNormSquared(mxArrayConstPtr A);

#endif

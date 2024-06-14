#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <windows.h>
#include <math.h>

#include "mex.h"

#if MX_API_VER < 0x07030000
typedef int mwIndex;
#endif 
#ifndef max
#define max(x,y) (((x)>(y))?(x):(y))
#endif
#ifndef min
#define min(x,y) (((x)<(y))?(x):(y))
#endif

HANDLE hFile = 0;
unsigned char *ptr = 0;

void mexFunction(int nlhs, mxArray *plhs[],
		int nrhs, const mxArray *prhs[] )
{
	const int size = 1024*10;
	const char *name = "MATLAB2MICRON";
	int result = 0;
    char cmd[1024*10];
    
    if (!hFile)
    {
        hFile = CreateFileMapping(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, size, name);
        if (!hFile)
            mexPrintf("Error: Could not create memory mapped file\n");
    }
    if (!ptr)
    {
        ptr = (unsigned char*)MapViewOfFile(hFile, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        memset(ptr, 0, 1024*10);
        if (!ptr)
            mexPrintf("Error: Could not open memory mapped file\n");
    }
	
    if (hFile && ptr)
    {
        if (nrhs == 1 && (nrhs == 0 || nrhs == 1)) // packet out
        {
            double *dataPacketOut = mxGetPr(prhs[0]);
            int N = mxGetN(prhs[0]);
            int M = mxGetM(prhs[0]);

            if (N*M != 16)
            {
                mexPrintf("Error: packetOut must be 16 singles!\n");
            }
            else if (!mxIsSingle(prhs[0]))
            {
                mexPrintf("Error: packetOut must be of type single!\n");
            }
            else
            {
                // Copy data packet out into shared memory
                int packetInSize = *((int*)ptr);
                memcpy(ptr+sizeof(int)+packetInSize, dataPacketOut, 16*sizeof(double));

                // Flush changes to shared memory
                FlushViewOfFile(ptr, size);

                // Yay!
                result = 1;
            }
        }
        else if (nrhs == 0 && (nlhs == 1 || nlhs == 2)) // packet in
        {
            int packetInSize = *((int*)ptr);
            if (packetInSize == 0)
                Sleep(10);
            packetInSize = *((int*)ptr);
            if (packetInSize == 0)
                mexPrintf("PacketInSize == 0, did you run the c++ Micron Matlab Interface?\n");

            int cols = ceil((double)packetInSize / 3) / sizeof(float);
            int dims[2] = {3, cols};
            plhs[0] = mxCreateNumericArray(2, dims, mxSINGLE_CLASS, mxREAL);
            double *dataPacketIn = mxGetPr(plhs[0]);
            //debug: mexPrintf("packetInSize: %d   rows: %d\n", packetInSize, rows);
            memcpy(dataPacketIn, ptr+sizeof(int), packetInSize);
            result = 1;
        }
        else
        {
            mexPrintf("Error, usage is: [packetIn, result] = matlab_labview_sync() or [result] = matlab_labview_sync(packetOut)\n");
        }
	}
	
	if (nrhs == 1 && nlhs == 1)
	{
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		double *data = mxGetPr(plhs[0]);
		*data = (double)result;
	}
    else if (nrhs == 0 && nlhs == 2)
	{
		plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
		double *data = mxGetPr(plhs[1]);
		*data = (double)result;
	}
}


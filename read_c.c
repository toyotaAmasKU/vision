/*  Author : Supakit Kriangkhajorn ,2016
    Follow me : skconan
    Ref: https://www.mathworks.com/help/simulink/sfg/example-of-a-basic-c-mex-s-function.html   */

#define S_FUNCTION_NAME read_c /* Defines and Includes */
#define S_FUNCTION_LEVEL 2
#include "simstruc.h"
#include<stdio.h>

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 0);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch reported by the Simulink engine*/
    }

    
    
    if (!ssSetNumOutputPorts(S,1)) return;
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);

    ssSetNumSampleTimes(S, 1);

    /* Take care when specifying exception free code - see sfuntmpl.doc */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    int n;
    real_T *y = ssGetOutputPortRealSignal(S,0);
    int_T width = ssGetOutputPortWidth(S,0);
    FILE *fptr;
    
    fptr = fopen("udpsend.txt","r"); 
    fseek(fptr, -sizeof(char)*3, SEEK_END);
    fscanf(fptr,"%d",&n);
    fclose(fptr);
    *y = n; 
}


static void mdlTerminate(SimStruct *S){}
#ifdef MATLAB_MEX_FILE /* Is this file being compiled as a MEX-file? */
#include "simulink.c" /* MEX-file interface mechanism */
#else
#include "cg_sfun.h" /* Code generation registration function */
#endif
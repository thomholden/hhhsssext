#include "mex.h"		// necessary
#include "windows.h"

/* Input Arguments */
#define	PRI	prhs[0]

void mexFunction(
	int nlhs, mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	bool silent = false;

	if (nlhs==0 && nrhs==0)
	{
		printf("\n");
		printf("Usage:   last = priority [ [s] [l,bn,n,an] ] (single char argument)\n\n");
		printf("         old priority is returned in 'last', new priority\n");
		printf("         can be low, below-normal, normal, or above-normal.\n");
		printf("         pre-pending 's' to the priority string will cause\n");
		printf("         silent behaviour. priorities higher than above-normal\n");
		printf("         are returned as 'h', but cannot be set due to the risk\n");
		printf("         of freezing the machine. sending 'h' as the new priority\n");
		printf("         will set to above-normal.\n");
		printf("\n");
		printf("Example: last = priority('sl');\n");
		printf("         <do some idle processing>\n");
		printf("         priority(['s' last]);\n\n");
		printf("         last = priority on its own will return the current priority\n");
		printf("\n");
		return;
	}

	if (nlhs>0)
	{
		HANDLE Proc = GetCurrentProcess();
		DWORD Pri = GetPriorityClass(Proc);
		if (!Pri) mexErrMsgTxt("Could not get priority");
		char buf[16];
		if (Pri==IDLE_PRIORITY_CLASS)			sprintf(buf,"l");
		else if (Pri==16384)					sprintf(buf,"bn"); // only exists on 2000+ i think
		else if (Pri==NORMAL_PRIORITY_CLASS)	sprintf(buf,"n");
		else if (Pri==32768)					sprintf(buf,"an"); // only exists on 2000+ i think
		else sprintf(buf,"h");
		plhs[0] = mxCreateString(buf);
	}

	if (nrhs>0)
	{
		if (mxGetM(PRI)!=1 || !mxIsChar(PRI) || mxGetN(PRI)>3 || mxGetN(PRI)<1)
		{
			printf("Usage: old = priority [ [s] [l,bn,n,an] ] (single char argument)\n");
			return;
		}

		int buflen = (mxGetN(prhs[0])) + 1;
		char* buf=(char*)mxCalloc(buflen, sizeof(char));
		int status = mxGetString(prhs[0], buf, buflen);
		if(status != 0) mexErrMsgTxt("Failed");

		if (strncmp(buf,"s",1)==0)
		{
			buf++;
			silent = true;
		}

		DWORD Pri;
		if (strcmp(buf,"l")==0) Pri=IDLE_PRIORITY_CLASS;
		else if (strcmp(buf,"bn")==0) Pri=16384;
		else if (strcmp(buf,"n")==0) Pri=NORMAL_PRIORITY_CLASS;
		else if (strcmp(buf,"an")==0) Pri=32768;
		else if (strcmp(buf,"h")==0) Pri=32768; // high not allowed
		else mexErrMsgTxt("Unrecognised priority level - should be l, bn, n or an");

		HANDLE Proc = GetCurrentProcess();
		if (!SetPriorityClass(Proc,Pri)) mexErrMsgTxt("Could not set priority");
		else { if (!silent) printf("Priority set OK.\n"); }
	}

	return;
}


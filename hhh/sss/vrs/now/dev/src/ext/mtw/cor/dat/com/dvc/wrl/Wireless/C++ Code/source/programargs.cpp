#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "util.h"
#include "programargs.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


ProgramArgs::ProgramArgs(int argc,
                         char* argv[])
{
    _ASSERTE(argc > 0);
    _ASSERTE(argv != null);
    m_argc = argc;
    m_argv = argv;
}

ProgramArgs::~ProgramArgs()
{

}

int ProgramArgs::count() {
    return m_argc;
}

const char* ProgramArgs::programName() {
    return m_argv[0];
}

bool ProgramArgs::findOption(const char* option) {
    for (int i=0; i<m_argc; ++i) {
        if (strcmp(option, m_argv[i]) == 0) {
            return true;
        }
    }
    return false;
}

// Return the parameter for a given option as a string
const char*
ProgramArgs::getParameter(const char* option,
                          const char* sdef) {
    for (int i=0; i<m_argc; ++i) {
        if (strcmp(option, m_argv[i]) == 0) {
            if (i < (m_argc-1)) {
                return m_argv[i+1];
            }
        }
    }
    return sdef;
}

// Return the parameter for a given option as an integer
int
ProgramArgs::getIntParameter(const char* option,
                             int idef) {
    const char* param = getParameter(option, null);
    return ((param != null) ? atoi(param) : idef);
}

// Return the parameter for a given option as a double
double
ProgramArgs::getDoubleParameter(const char* option,
                                double ddef) {
    const char* param = getParameter(option, null);
    return ((param != null) ? atof(param) : ddef);
}

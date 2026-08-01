/*
============================================================================================
   Some simple structs for representing small-scale linear algebra.

   Copyright (c) 02-26-2012,  Shawn W. Walker
============================================================================================
*/

static const double         PI = 3.14159265358979323846264338327950288419716939;
static const double     SQRT_2 = 1.4142135623730950488016887242097;
static const double INV_SQRT_2 = 0.7071067811865475244008443621048;

// define basic linear algebra structures

/***************************************************************************************/
/* scalars */
typedef struct
{
    double a;
} SCALAR;

/***************************************************************************************/
/* vectors */
typedef struct
{
    double v[1];
} VEC_1x1;
typedef struct
{
    double v[2];
} VEC_2x1;
typedef struct
{
    double v[3];
} VEC_3x1;

/***************************************************************************************/
/* matrices */
typedef struct
{
    double m[1][1];
} MAT_1x1;
typedef struct
{
    double m[2][1];
} MAT_2x1;
typedef struct
{
    double m[2][2];
} MAT_2x2;
typedef struct
{
    double m[3][1];
} MAT_3x1;
typedef struct
{
    double m[3][2];
} MAT_3x2;
typedef struct
{
    double m[3][3];
} MAT_3x3;

/***************************************************************************************/
/* 3rd order tensors (i.e. multi-matrix) */
typedef struct
{
    double m[1][1][1];
} MAT_1x1x1;
typedef struct
{
    double m[2][1][1];
} MAT_2x1x1;
typedef struct
{
    double m[2][2][2];
} MAT_2x2x2;
typedef struct
{
    double m[3][1][1];
} MAT_3x1x1;
typedef struct
{
    double m[3][2][2];
} MAT_3x2x2;
typedef struct
{
    double m[3][3][3];
} MAT_3x3x3;


// initialization routines

/***************************************************************************************/
/* set all entries to zero */
void Init_To_Zero (SCALAR& S)
{
    S.a = 0.0;
}
void Init_To_Zero (VEC_1x1& S)
{
    S.v[0] = 0.0;
}
void Init_To_Zero (VEC_2x1& S)
{
    S.v[0] = 0.0;
    S.v[1] = 0.0;
}
void Init_To_Zero (VEC_3x1& S)
{
    S.v[0] = 0.0;
    S.v[1] = 0.0;
    S.v[2] = 0.0;
}
void Init_To_Zero (MAT_1x1& S)
{
    S.m[0][0] = 0.0;
}
void Init_To_Zero (MAT_2x1& S)
{
    S.m[0][0] = 0.0;
    S.m[1][0] = 0.0;
}
void Init_To_Zero (MAT_2x2& S)
{
    S.m[0][0] = 0.0;
    S.m[0][1] = 0.0;
    S.m[1][0] = 0.0;
    S.m[1][1] = 0.0;
}
void Init_To_Zero (MAT_3x1& S)
{
    S.m[0][0] = 0.0;
    S.m[1][0] = 0.0;
    S.m[2][0] = 0.0;
}
void Init_To_Zero (MAT_3x2& S)
{
    S.m[0][0] = 0.0;
    S.m[0][1] = 0.0;
    S.m[1][0] = 0.0;
    S.m[1][1] = 0.0;
    S.m[2][0] = 0.0;
    S.m[2][1] = 0.0;
}
void Init_To_Zero (MAT_3x3& S)
{
    S.m[0][0] = 0.0;
    S.m[0][1] = 0.0;
    S.m[0][2] = 0.0;
    S.m[1][0] = 0.0;
    S.m[1][1] = 0.0;
    S.m[1][2] = 0.0;
    S.m[2][0] = 0.0;
    S.m[2][1] = 0.0;
    S.m[2][2] = 0.0;
}
void Init_To_Zero (MAT_1x1x1& S)
{
    S.m[0][0][0] = 0.0;
}
void Init_To_Zero (MAT_2x1x1& S)
{
    S.m[0][0][0] = 0.0;
    S.m[1][0][0] = 0.0;
}
void Init_To_Zero (MAT_2x2x2& S)
{
    S.m[0][0][0] = 0.0;
    S.m[0][0][1] = 0.0;
    S.m[0][1][0] = 0.0;
    S.m[0][1][1] = 0.0;
    S.m[1][0][0] = 0.0;
    S.m[1][0][1] = 0.0;
    S.m[1][1][0] = 0.0;
    S.m[1][1][1] = 0.0;
}
void Init_To_Zero (MAT_3x1x1& S)
{
    S.m[0][0][0] = 0.0;
    S.m[1][0][0] = 0.0;
    S.m[2][0][0] = 0.0;
}
void Init_To_Zero (MAT_3x2x2& S)
{
    S.m[0][0][0] = 0.0;
    S.m[0][0][1] = 0.0;
    S.m[0][1][0] = 0.0;
    S.m[0][1][1] = 0.0;
    S.m[1][0][0] = 0.0;
    S.m[1][0][1] = 0.0;
    S.m[1][1][0] = 0.0;
    S.m[1][1][1] = 0.0;
    S.m[2][0][0] = 0.0;
    S.m[2][0][1] = 0.0;
    S.m[2][1][0] = 0.0;
    S.m[2][1][1] = 0.0;
}
void Init_To_Zero (MAT_3x3x3& S)
{
    S.m[0][0][0] = 0.0;
    S.m[0][0][1] = 0.0;
    S.m[0][0][2] = 0.0;
    S.m[0][1][0] = 0.0;
    S.m[0][1][1] = 0.0;
    S.m[0][1][2] = 0.0;
    S.m[0][2][0] = 0.0;
    S.m[0][2][1] = 0.0;
    S.m[0][2][2] = 0.0;

    S.m[1][0][0] = 0.0;
    S.m[1][0][1] = 0.0;
    S.m[1][0][2] = 0.0;
    S.m[1][1][0] = 0.0;
    S.m[1][1][1] = 0.0;
    S.m[1][1][2] = 0.0;
    S.m[1][2][0] = 0.0;
    S.m[1][2][1] = 0.0;
    S.m[1][2][2] = 0.0;

    S.m[2][0][0] = 0.0;
    S.m[2][0][1] = 0.0;
    S.m[2][0][2] = 0.0;
    S.m[2][1][0] = 0.0;
    S.m[2][1][1] = 0.0;
    S.m[2][1][2] = 0.0;
    S.m[2][2][0] = 0.0;
    S.m[2][2][1] = 0.0;
    S.m[2][2][2] = 0.0;
}

/***/

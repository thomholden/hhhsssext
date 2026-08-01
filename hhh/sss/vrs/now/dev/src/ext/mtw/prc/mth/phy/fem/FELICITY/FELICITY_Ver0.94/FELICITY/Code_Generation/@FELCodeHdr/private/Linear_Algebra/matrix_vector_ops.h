/*
============================================================================================
   Some simple math routines for computing small-scale linear algebra.

   Copyright (c) 02-26-2012,  Shawn W. Walker
============================================================================================
*/

// simple absolute value!
inline double my_abs(const double& value)
{
    if (value < 0)
        return -value;
    else
        return value;
}

// define basic vector operations

/***************************************************************************************/
/* copy vector: B = A */
inline void Copy_Vec_To_Vec (const VEC_1x1& A, VEC_1x1& B)
{
    B.v[0] = A.v[0];
}
inline void Copy_Vec_To_Vec (const VEC_2x1& A, VEC_2x1& B)
{
    B.v[0] = A.v[0];
	B.v[1] = A.v[1];
}
inline void Copy_Vec_To_Vec (const VEC_3x1& A, VEC_3x1& B)
{
    B.v[0] = A.v[0];
	B.v[1] = A.v[1];
	B.v[2] = A.v[2];
}

inline void Copy_Vec_To_Array (const VEC_1x1& A, double* B)
{
    B[0] = A.v[0];
}
inline void Copy_Vec_To_Array (const VEC_2x1& A, double* B)
{
    B[0] = A.v[0];
	B[1] = A.v[1];
}
inline void Copy_Vec_To_Array (const VEC_3x1& A, double* B)
{
    B[0] = A.v[0];
	B[1] = A.v[1];
	B[2] = A.v[2];
}

inline void Copy_Array_To_Vec (const double* A, VEC_1x1& B)
{
    B.v[0] = A[0];
}
inline void Copy_Array_To_Vec (const double* A, VEC_2x1& B)
{
    B.v[0] = A[0];
	B.v[1] = A[1];
}
inline void Copy_Array_To_Vec (const double* A, VEC_3x1& B)
{
    B.v[0] = A[0];
	B.v[1] = A[1];
	B.v[2] = A[2];
}

/***************************************************************************************/
/* dot-product: a.b */
inline double Dot_Product (const VEC_2x1& A, const VEC_2x1& B)
{
    return A.v[0]*B.v[0] + A.v[1]*B.v[1];
}
inline double Dot_Product (const VEC_3x1& A, const VEC_3x1& B)
{
    return A.v[0]*B.v[0] + A.v[1]*B.v[1] + A.v[2]*B.v[2];
}

/***************************************************************************************/
/* Euclidean length of a vector |V| */
inline double l2_norm (const VEC_1x1& A)
{
    if (A.v[0] < 0)
        return -A.v[0];
    else
        return  A.v[0];
}
inline double l2_norm (const VEC_2x1& A)
{
    return sqrt(Dot_Product(A,A));
}
inline double l2_norm (const VEC_3x1& A)
{
    return sqrt(Dot_Product(A,A));
}

/***************************************************************************************/
/* cross-product: c = a x b */
void Cross_Product (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[1]*B.v[2] - A.v[2]*B.v[1];
    C.v[1] = A.v[2]*B.v[0] - A.v[0]*B.v[2];
    C.v[2] = A.v[0]*B.v[1] - A.v[1]*B.v[0];
}

/***************************************************************************************/
/* normalize vector */
double Normalize (const VEC_2x1& Vec_in, VEC_2x1& Vec_out)
{
    const double LENGTH = l2_norm(Vec_in);

    // normalize!
    Vec_out.v[0] = Vec_in.v[0] / LENGTH;
    Vec_out.v[1] = Vec_in.v[1] / LENGTH;

    return LENGTH;
}
double Normalize (const VEC_3x1& Vec_in, VEC_3x1& Vec_out)
{
    const double LENGTH = l2_norm(Vec_in);

    // normalize!
    Vec_out.v[0] = Vec_in.v[0] / LENGTH;
    Vec_out.v[1] = Vec_in.v[1] / LENGTH;
    Vec_out.v[2] = Vec_in.v[2] / LENGTH;

    return LENGTH;
}

/***************************************************************************************/
/* scale vector */
void Scalar_Mult_Vector (const VEC_1x1& Vec_in, const SCALAR& S, VEC_1x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
}
void Scalar_Mult_Vector (const VEC_2x1& Vec_in, const SCALAR& S, VEC_2x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
    Vec_out.v[1] = S.a * Vec_in.v[1];
}
void Scalar_Mult_Vector (const VEC_3x1& Vec_in, const SCALAR& S, VEC_3x1& Vec_out)
{
    Vec_out.v[0] = S.a * Vec_in.v[0];
    Vec_out.v[1] = S.a * Vec_in.v[1];
    Vec_out.v[2] = S.a * Vec_in.v[2];
}

/***************************************************************************************/
/* add vectors: C = A + B */
void Add_Vector (const VEC_1x1& A, const VEC_1x1& B, VEC_1x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
}
void Add_Vector (const VEC_2x1& A, const VEC_2x1& B, VEC_2x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
    C.v[1] = A.v[1] + B.v[1];
}
void Add_Vector (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[0] + B.v[0];
    C.v[1] = A.v[1] + B.v[1];
    C.v[2] = A.v[2] + B.v[2];
}

/***************************************************************************************/
/* subtract vectors: C = A - B */
void Subtract_Vector (const VEC_1x1& A, const VEC_1x1& B, VEC_1x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
}
void Subtract_Vector (const VEC_2x1& A, const VEC_2x1& B, VEC_2x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
    C.v[1] = A.v[1] - B.v[1];
}
void Subtract_Vector (const VEC_3x1& A, const VEC_3x1& B, VEC_3x1& C)
{
    C.v[0] = A.v[0] - B.v[0];
    C.v[1] = A.v[1] - B.v[1];
    C.v[2] = A.v[2] - B.v[2];
}

/***************************************************************************************/
/* add vectors: V_out = V_in + V_out */
void Add_Vector_Self (const VEC_1x1& V_in, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
}
void Add_Vector_Self (const VEC_2x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
    V_out.v[1] = V_in.v[1] + V_out.v[1];
}
void Add_Vector_Self (const VEC_3x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = V_in.v[0] + V_out.v[0];
    V_out.v[1] = V_in.v[1] + V_out.v[1];
    V_out.v[2] = V_in.v[2] + V_out.v[2];
}


// define basic matrix-vector operations

/***************************************************************************************/
/* matrix-vector product */
void Mat_Vec (const MAT_1x1& A, const VEC_1x1& V_in, VEC_1x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0];
}
void Mat_Vec (const MAT_2x2& A, const VEC_2x1& V_in, VEC_2x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1];
}
void Mat_Vec (const MAT_3x2& A, const VEC_2x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1];
    V_out.v[2] = A.m[2][0] * V_in.v[0] + A.m[2][1] * V_in.v[1];
}
void Mat_Vec (const MAT_3x3& A, const VEC_3x1& V_in, VEC_3x1& V_out)
{
    V_out.v[0] = A.m[0][0] * V_in.v[0] + A.m[0][1] * V_in.v[1] + A.m[0][2] * V_in.v[2];
    V_out.v[1] = A.m[1][0] * V_in.v[0] + A.m[1][1] * V_in.v[1] + A.m[1][2] * V_in.v[2];
    V_out.v[2] = A.m[2][0] * V_in.v[0] + A.m[2][1] * V_in.v[1] + A.m[2][2] * V_in.v[2];
}

void Vec_Transpose_Mat (const VEC_2x1& V_in, const MAT_2x1& A, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0];
}
void Vec_Transpose_Mat (const VEC_2x1& V_in, const MAT_2x2& A, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1];
}
void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x1& A, VEC_1x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
}
void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x2& A, VEC_2x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1] + V_in.v[2] * A.m[2][1];
}
void Vec_Transpose_Mat (const VEC_3x1& V_in, const MAT_3x3& A, VEC_3x1& V_out)
{
    V_out.v[0] = V_in.v[0] * A.m[0][0] + V_in.v[1] * A.m[1][0] + V_in.v[2] * A.m[2][0];
    V_out.v[1] = V_in.v[0] * A.m[0][1] + V_in.v[1] * A.m[1][1] + V_in.v[2] * A.m[2][1];
    V_out.v[2] = V_in.v[0] * A.m[0][2] + V_in.v[1] * A.m[1][2] + V_in.v[2] * A.m[2][2];
}

/***************************************************************************************/
/* matrix-matrix product: C = A*B */
void Mat_Mat (const MAT_2x2& A, const MAT_2x2& B, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1];
    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1];
}
void Mat_Mat (const MAT_3x3& A, const MAT_3x3& B, MAT_3x3& C)
{
    C.m[0][0] = A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[1][0] + A.m[0][2] * B.m[2][0];
    C.m[0][1] = A.m[0][0] * B.m[0][1] + A.m[0][1] * B.m[1][1] + A.m[0][2] * B.m[2][1];
    C.m[0][2] = A.m[0][0] * B.m[0][2] + A.m[0][1] * B.m[1][2] + A.m[0][2] * B.m[2][2];

    C.m[1][0] = A.m[1][0] * B.m[0][0] + A.m[1][1] * B.m[1][0] + A.m[1][2] * B.m[2][0];
    C.m[1][1] = A.m[1][0] * B.m[0][1] + A.m[1][1] * B.m[1][1] + A.m[1][2] * B.m[2][1];
    C.m[1][2] = A.m[1][0] * B.m[0][2] + A.m[1][1] * B.m[1][2] + A.m[1][2] * B.m[2][2];

    C.m[2][0] = A.m[2][0] * B.m[0][0] + A.m[2][1] * B.m[1][0] + A.m[2][2] * B.m[2][0];
    C.m[2][1] = A.m[2][0] * B.m[0][1] + A.m[2][1] * B.m[1][1] + A.m[2][2] * B.m[2][1];
    C.m[2][2] = A.m[2][0] * B.m[0][2] + A.m[2][1] * B.m[1][2] + A.m[2][2] * B.m[2][2];
}

/***************************************************************************************/
/* matrix-``inner'' product: C = A^t * A */
void Mat_Transpose_Mat_Self (const MAT_2x1& A, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0];
}
void Mat_Transpose_Mat_Self (const MAT_3x1& A, MAT_1x1& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0] + A.m[2][0]*A.m[2][0];
}
void Mat_Transpose_Mat_Self (const MAT_3x2& A, MAT_2x2& C)
{
    C.m[0][0] = A.m[0][0]*A.m[0][0] + A.m[1][0]*A.m[1][0] + A.m[2][0]*A.m[2][0];
    C.m[0][1] = A.m[0][0]*A.m[0][1] + A.m[1][0]*A.m[1][1] + A.m[2][0]*A.m[2][1];
    C.m[1][0] = C.m[0][1]; // symmetry
    C.m[1][1] = A.m[0][1]*A.m[0][1] + A.m[1][1]*A.m[1][1] + A.m[2][1]*A.m[2][1];
}

/***************************************************************************************/
/* contract two square matrices:  A:B = SUM_{ij} a_ij b_ij */
inline double Contract_Square_Matrices (const MAT_2x2& A, const MAT_2x2& B)
{
    return (A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1] +
            A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1]);
}
inline double Contract_Square_Matrices (const MAT_3x3& A, const MAT_3x3& B)
{
    return (A.m[0][0] * B.m[0][0] + A.m[0][1] * B.m[0][1] + A.m[0][2] * B.m[0][2] +
            A.m[1][0] * B.m[1][0] + A.m[1][1] * B.m[1][1] + A.m[1][2] * B.m[1][2] +
            A.m[2][0] * B.m[2][0] + A.m[2][1] * B.m[2][1] + A.m[2][2] * B.m[2][2]);
}


// define basic matrix operations

/***************************************************************************************/
/* det of matrix */
inline double Determinant (const MAT_1x1& A)
{
    return A.m[0][0];
}
inline double Determinant (const MAT_2x2& A)
{
    return (A.m[0][0]*A.m[1][1] - A.m[0][1]*A.m[1][0]);
}
inline double Determinant (const MAT_3x3& A)
{
    // DET: a00*a11*a22 - a00*a12*a21 - a01*a10*a22 + a01*a12*a20 + a02*a10*a21 - a02*a11*a20
    return (A.m[0][0] * A.m[1][1] * A.m[2][2] -
            A.m[0][0] * A.m[1][2] * A.m[2][1] -
            A.m[0][1] * A.m[1][0] * A.m[2][2] +
            A.m[0][1] * A.m[1][2] * A.m[2][0] +
            A.m[0][2] * A.m[1][0] * A.m[2][1] -
            A.m[0][2] * A.m[1][1] * A.m[2][0]);
}

/***************************************************************************************/
/* inverse of matrix */
void Matrix_Inverse (const MAT_1x1& A, const SCALAR& Det_A_Inv, MAT_1x1& A_Inv)
{
    A_Inv.m[0][0] = 1.0 / A.m[0][0];
}
void Matrix_Inverse (const MAT_2x2& A, const SCALAR& Det_A_Inv, MAT_2x2& A_Inv)
{
    A_Inv.m[0][0] =  A.m[1][1] * Det_A_Inv.a;
    A_Inv.m[0][1] = -A.m[0][1] * Det_A_Inv.a;
    A_Inv.m[1][0] = -A.m[1][0] * Det_A_Inv.a;
    A_Inv.m[1][1] =  A.m[0][0] * Det_A_Inv.a;
}
void Matrix_Inverse (const MAT_3x3& A, const SCALAR& Det_A_Inv, MAT_3x3& A_Inv)
{
    A_Inv.m[0][0] = (A.m[1][1]*A.m[2][2] - A.m[1][2]*A.m[2][1]) * Det_A_Inv.a;
    A_Inv.m[0][1] = (A.m[0][2]*A.m[2][1] - A.m[0][1]*A.m[2][2]) * Det_A_Inv.a;
    A_Inv.m[0][2] = (A.m[0][1]*A.m[1][2] - A.m[0][2]*A.m[1][1]) * Det_A_Inv.a;

    A_Inv.m[1][0] = (A.m[1][2]*A.m[2][0] - A.m[1][0]*A.m[2][2]) * Det_A_Inv.a;
    A_Inv.m[1][1] = (A.m[0][0]*A.m[2][2] - A.m[0][2]*A.m[2][0]) * Det_A_Inv.a;
    A_Inv.m[1][2] = (A.m[0][2]*A.m[1][0] - A.m[0][0]*A.m[1][2]) * Det_A_Inv.a;

    A_Inv.m[2][0] = (A.m[1][0]*A.m[2][1] - A.m[1][1]*A.m[2][0]) * Det_A_Inv.a;
    A_Inv.m[2][1] = (A.m[0][1]*A.m[2][0] - A.m[0][0]*A.m[2][1]) * Det_A_Inv.a;
    A_Inv.m[2][2] = (A.m[0][0]*A.m[1][1] - A.m[0][1]*A.m[1][0]) * Det_A_Inv.a;
}

/***/

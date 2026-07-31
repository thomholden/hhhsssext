/* Showcases including C files instead of feeding in a string to mexme */
/* Taken from http://warp.povusers.org/Mandelbrot/ */
/* Originally written by Juha Nieminen */

double MinRe = -2.0;
double MaxRe = 1.0;
double MinIm = -1.2;
double MaxIm = MinIm+(MaxRe-MinRe)*(double)ImageHeight/(double)ImageWidth;
double Re_factor = (MaxRe-MinRe)/(ImageWidth-1);
double Im_factor = (MaxIm-MinIm)/(ImageHeight-1);

unsigned MaxIterations = 30;

for(unsigned int y=0; y<ImageHeight; ++y)
{
    double c_im = MaxIm - y*Im_factor;
    for(unsigned int x=0; x<ImageWidth; ++x)
    {
        double c_re = MinRe + x*Re_factor;

        double Z_re = c_re, Z_im = c_im;
        bool isInside = true;
        unsigned int n;
        for(n=0; n<MaxIterations; ++n)
        {
            double Z_re2 = Z_re*Z_re, Z_im2 = Z_im*Z_im;
            if(Z_re2 + Z_im2 > 4)
            {
                isInside = false;
                break;
            }
            Z_im = 2*Z_re*Z_im + c_im;
            Z_re = Z_re2 - Z_im2 + c_re;
        }
        mset[y+ImageHeight*x] = n;
    }
}

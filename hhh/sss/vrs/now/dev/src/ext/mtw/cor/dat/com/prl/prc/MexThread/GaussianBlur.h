#ifndef _GaussianBlur_h_
#define _GaussianBlur_h_

#include <cmath>

// Simple slow Gaussian blurring algorithm
template <typename ImageIn, typename ImageOut>
void GaussianBlur( const ImageIn& imgIn, double sigma, ImageOut& imgOut )
{

    const int w = imgIn.size(0);
    const int h = imgIn.size(1);
    const int d = imgIn.size(2);
    imgOut.resize( w, h, d );

    int r = int(sigma * 3) + 1;
    double s2 = sigma * sigma * 2;

    for(int c=0; c<d; c++)
    for(int y=0; y<h; y++)
    for(int x=0; x<w; x++)
    {
        double s = 0;
        for (int v=-r; v<=r; v++)
        {
            int v1 = std::max(0, std::min(h - 1, y + v));
            for (int u=-r; u<=r; u++)
            {
                int u1 = std::max(0, std::min(w - 1, x + u));
                s += std::exp(-(u * u + v * v) / s2) * imgIn(u1,v1,c);
            }
        }
        imgOut(x,y,c) = s / s2 / 3.141592653589;
    }

} 




#endif // ! _GaussianBlur_h_

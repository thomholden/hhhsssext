using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;


using MathWorks.MATLAB.NET.Arrays;
using NETSquare;


namespace WindowsApplication1
{
    public partial class Form1 : Form
    {

        private NETSquare.NETSquareclass m_squareCreator;
        private MWNumericArray m_magicArray;

        #region constructor
        public Form1()
        {
            InitializeComponent();

            m_squareCreator = new NETSquareclass();
            combo_matrixSize.SelectedIndex = 0;

            updateAll();
        }
        #endregion

        #region private methods
        /// <summary>
        /// Plots numbers of the magic matrix into text box
        /// </summary>
        /// <param name="matrix">matrix</param>
        /// <param name="l">matrix size</param>
        private void formatMatrixText(double[,] matrix)
        {
            textBox1.Clear();
            int i, j, k, l = matrix.GetLength(1);
            for (i = 0; i < l; i++)
            {
                for (j = 0; j < l; j++)
                {
                    string tmpStr = matrix[i, j].ToString("N0");
                    for (k = 0; k < 4 - tmpStr.Length; k++)
                        textBox1.Text += " ";
                    textBox1.Text += tmpStr;
                }
                textBox1.Text += Environment.NewLine;
            }
        }

        /// <summary>
        /// Copies image data to .NET Bitmap
        /// </summary>
        /// <param name="image">image data in MATLAB format (BBB...BGGG...GRRR...R)</param>
        /// <param name="dims">image dimensions</param>
        private void plotMatrixFigure(byte[] image, int[] dims)
        {
            Bitmap tmpImage = new Bitmap(dims[0], dims[1]);

            // Specify a pixel format.
            PixelFormat pxf = PixelFormat.Format32bppRgb;

            // Lock the bitmap's bits.
            Rectangle rect = new Rectangle(0, 0, tmpImage.Width, tmpImage.Height);
            BitmapData tmpData = tmpImage.LockBits(rect, ImageLockMode.ReadWrite, pxf);

            {
                int numBytes = tmpImage.Width * tmpImage.Height * 4;

                unsafe // To speedup handling of large bitmaps
                {
                    int i = 0, j = 0;
                    //Get the address of the first line of the bitmap.
                    Int32* pT = (Int32*)tmpData.Scan0.ToPointer();
                    int stride = tmpData.Stride / 4; // 4 bytes / Int32 
                    fixed (byte* pR = &image[2 * tmpImage.Width * tmpImage.Height],
                    pG = &image[tmpImage.Width * tmpImage.Height],
                    pB = &image[0])
                    {
                        byte* _pR = pR, _pB = pB, _pG = pG;
                        for (j = 0; j < tmpImage.Height; j++)
                        {
                            Int32* _pT = pT + stride * j;
                            for (i = 0; i < stride; i++)
                            {
                                *_pT++ = (*_pB++ << 16 | *_pG++ << 8 | *_pR++);
                            }
                        }
                    }
                }

                // Unlock the bits.
                tmpImage.UnlockBits(tmpData);

                pictureBox1.Image = tmpImage;
                pictureBox1.Refresh();
            }
        }

        /// <summary>
        /// Refreshes matrix image: calls MATLAB generated function 'makebitmap'
        /// This is called when the GUI figure size is changed.
        /// </summary>
        private void refreshFigure()
        {
            MWNumericArray mwWidth, mwHeight, mw3DChecked;

            mwWidth = pictureBox1.Width;
            mwHeight = pictureBox1.Height;
            if (radioButton3D.Checked)
                mw3DChecked = (int)1;
            else
                mw3DChecked = 0;

            MWNumericArray mwOut;

            mwOut = (MWNumericArray)m_squareCreator.makebitmap(m_magicArray, mwWidth, mwHeight, mw3DChecked);

            byte[] nativeOut = (byte[])mwOut.ToVector(MWArrayComponent.Real); // Faster than ToArray

            int[] dims = { pictureBox1.Width, pictureBox1.Height, 3 };

            plotMatrixFigure(nativeOut, dims);
        }

        /// <summary>
        /// Creates a magic matrix using MATLAB generated function 'makesquare',
        /// and updates the text and image(s).
        /// This is called when the matrix size or visualization options are changed.
        /// </summary>
        private void updateAll()
        {
            MWNumericArray mwIn, mw3DChecked, mwFigureChecked;
            if (radioButton3D.Checked)
                mw3DChecked = (int)1;
            else
                mw3DChecked = (int)0;

            mwIn = int.Parse(combo_matrixSize.Text);
            m_magicArray = (MWNumericArray)m_squareCreator.makesquare(mwIn);

            double[,] nativeOut = (double[,])m_magicArray.ToArray(MWArrayComponent.Real);

            formatMatrixText(nativeOut);

            refreshFigure();

            if (checkBoxMATLABFigure.Checked)
                mwFigureChecked = (int)1;
            else
                mwFigureChecked = (int)-1;
            
            m_squareCreator.makefigure(m_magicArray, mw3DChecked, mwFigureChecked);
        }

        #endregion

        #region events

        /// <summary>
        /// Refresh picturebox
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void refreshPictureBox(object sender, EventArgs e)
        {
            refreshFigure();
        }

        /// <summary>
        /// Refresh all figures
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void refreshAll(object sender, EventArgs e)
        {
            updateAll();
        }

        #endregion

    }
}
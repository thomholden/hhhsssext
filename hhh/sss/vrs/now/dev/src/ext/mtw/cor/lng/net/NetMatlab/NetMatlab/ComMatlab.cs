using System;
using System.Runtime.InteropServices;

namespace ComMatlab
{

  public interface ComMatlabSignature
  {
    string SumStrings(string x, string y);
    int SumInts(int x, int y);
    double SumDoubles(double x, double y);
    double SumDoubleArray(double[,] x);
    int SumIntMatrix(int[,] x);
    int[] ReturnIntArray();
  }

  [ClassInterface(ClassInterfaceType.AutoDual)]
  public class ComMatlabClass : ComMatlabSignature
  {
    public string SumStrings(string x, string y)
    {
      return x+y;
    }
    
    public int SumInts(int x, int y)
    {
      return x+y;
    }
    
    public double SumDoubles(double x, double y)
    {
      return x+y;
    }
    
    public double SumDoubleArray(double[,] x)
    {
      double y=0;
      for (int i=0; i < x.Length; i++) { y+=x[0,i]; }
      return y;
    }
  
    public int SumIntMatrix(int[,] x)
    {
      int y = 0;
      for (int i = 0; i < x.GetLength(0); i++) 
      {
          for (int j = 0; j < x.GetLength(1); j++)
          {
              y += x[i, j];
          }
      }
      return y;
    }

    public int[] ReturnIntArray()
    {
      int[] y=new int[6]{1,2,3,4,5,6};
      return y;
    }

  }
}


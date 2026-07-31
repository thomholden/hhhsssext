/*
* MATLAB Compiler: 4.7 (R2007b)
* Date: Tue Apr  1 22:11:22 2008
* Arguments: "-B" "macro_default" "-W"
* "java:portOptDemoJava,portOptDemoJavaClass" "-d"
* "/home/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/
* PortOptDemo/compile/portOptDemoJava/src" "-T" "link:lib" "-v"
* "class{portOptDemoJavaClass:/home/sholden/Business/Jacobix/Dev/Pascal-Linux/AS
* SET/dev/queued/matlab/java/PortOptDemo/matlab_src/readStockDataFromFile.m,/hom
* e/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/PortO
* ptDemo/matlab_src/optimisePortfolio.m}" 
*/

package portOptDemoJava;

import com.mathworks.toolbox.javabuilder.*;

public class portOptDemoJavaMCRFactory
{
  /** Application key data */
  private static final byte[] sSessionKey = 
  {66, 66, 54, 70, 57, 65, 70, 50, 50, 56, 57, 54, 51, 51, 50, 67, 66, 53, 70,
   55, 70, 55, 50, 49, 50, 66, 66, 50, 53, 67, 48, 65, 53, 56, 51, 65, 50, 55,
   54, 49, 54, 65, 67, 69, 67, 68, 53, 69, 66, 70, 56, 67, 49, 70, 53, 70, 56,
   54, 68, 52, 70, 53, 55, 49, 56, 51, 67, 65, 70, 51, 52, 66, 55, 54, 53, 70,
   51, 51, 65, 52, 69, 65, 55, 51, 68, 52, 70, 69, 65, 67, 66, 50, 48, 66, 48,
   66, 65, 56, 56, 67, 51, 70, 70, 53, 57, 66, 69, 67, 70, 56, 70, 50, 70, 65,
   55, 68, 69, 55, 68, 48, 51, 51, 70, 49, 66, 55, 48, 53, 69, 55, 48, 57, 57,
   50, 50, 54, 69, 54, 65, 54, 65, 53, 48, 57, 68, 67, 51, 55, 66, 65, 55, 68,
   57, 52, 49, 51, 57, 48, 69, 57, 57, 69, 70, 54, 50, 51, 67, 69, 49, 66, 56,
   55, 55, 68, 53, 48, 52, 56, 52, 68, 51, 54, 67, 55, 48, 52, 56, 66, 53, 54,
   57, 70, 56, 50, 57, 50, 54, 66, 49, 48, 51, 66, 67, 70, 53, 68, 66, 69, 68,
   52, 57, 48, 53, 49, 70, 57, 57, 65, 56, 55, 66, 55, 48, 56, 66, 50, 66, 50,
   67, 67, 69, 50, 50, 70, 57, 51, 50, 68, 54, 70, 70, 51, 68, 57, 66, 51, 70,
   57, 49, 67, 65, 68, 69, 70, 50, 53};
  
  /** Public key data */
  private static final byte[] sPublicKey = 
  {51, 48, 56, 49, 57, 68, 51, 48, 48, 68, 48, 54, 48, 57, 50, 65, 56, 54, 52,
   56, 56, 54, 70, 55, 48, 68, 48, 49, 48, 49, 48, 49, 48, 53, 48, 48, 48, 51,
   56, 49, 56, 66, 48, 48, 51, 48, 56, 49, 56, 55, 48, 50, 56, 49, 56, 49, 48,
   48, 67, 52, 57, 67, 65, 67, 51, 52, 69, 68, 49, 51, 65, 53, 50, 48, 54, 53,
   56, 70, 54, 70, 56, 69, 48, 49, 51, 56, 67, 52, 51, 49, 53, 66, 52, 51, 49,
   53, 50, 55, 55, 69, 68, 51, 70, 55, 68, 65, 69, 53, 51, 48, 57, 57, 68, 66,
   48, 56, 69, 69, 53, 56, 57, 70, 56, 48, 52, 68, 52, 66, 57, 56, 49, 51, 50,
   54, 65, 53, 50, 67, 67, 69, 52, 51, 56, 50, 69, 57, 70, 50, 66, 52, 68, 48,
   56, 53, 69, 66, 57, 53, 48, 67, 55, 65, 66, 49, 50, 69, 68, 69, 50, 68, 52,
   49, 50, 57, 55, 56, 50, 48, 69, 54, 51, 55, 55, 65, 53, 70, 69, 66, 53, 54,
   56, 57, 68, 52, 69, 54, 48, 51, 50, 70, 54, 48, 67, 52, 51, 48, 55, 52, 65,
   48, 52, 67, 50, 54, 65, 66, 55, 50, 70, 53, 52, 66, 53, 49, 66, 66, 52, 54,
   48, 53, 55, 56, 55, 56, 53, 66, 49, 57, 57, 48, 49, 52, 51, 49, 52, 65, 54,
   53, 70, 48, 57, 48, 66, 54, 49, 70, 67, 50, 48, 49, 54, 57, 52, 53, 51, 66,
   53, 56, 70, 67, 56, 66, 65, 52, 51, 69, 54, 55, 55, 54, 69, 66, 55, 69, 67,
   68, 51, 49, 55, 56, 66, 53, 54, 65, 66, 48, 70, 65, 48, 54, 68, 68, 54, 52,
   57, 54, 55, 67, 66, 49, 52, 57, 69, 53, 48, 50, 48, 49, 49, 49};
  
  /** Component's MATLAB path */
  private static final String[] sMatlabPath = 
  {"portOptDemoJava/", "toolbox/compiler/deploy/",
   "home/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/PortOptDemo/matlab_src/",
   "$TOOLBOXMATLABDIR/general/", "$TOOLBOXMATLABDIR/ops/",
   "$TOOLBOXMATLABDIR/lang/", "$TOOLBOXMATLABDIR/elmat/",
   "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
   "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
   "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
   "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
   "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
   "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
   "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
   "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
   "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
   "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
   "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
   "$TOOLBOXMATLABDIR/demos/", "$TOOLBOXMATLABDIR/timeseries/",
   "$TOOLBOXMATLABDIR/hds/", "$TOOLBOXMATLABDIR/guide/",
   "$TOOLBOXMATLABDIR/plottools/", "toolbox/local/", "toolbox/shared/optimlib/",
   "toolbox/finance/finance/", "toolbox/optim/optim/"};
  
  /** Items to be added to component's class path */
  private static final String[] sClassPath = 
  {};
  
  /** Items to be added to component's lib path */
  private static final String[] sLibraryPath = 
  {};
  
  /** MCR instance-specific runtime options */
  private static final String[] sApplicationOptions = 
  {};
  
  /** MCR global runtime options */
  private static final String[] sRuntimeOptions = 
  {};
  
  /** Runtime warning states */
  private static final String[] sSetWarningState = 
  {"off:MATLAB:dispatcher:nameConflict"};
  
  /** Component's preference directory */
  private static final String sComponentPrefDir = "portOptDemoJava_99082B24889EA4F2ECF557F96EED79F0";
  
  /** Component name */
  private static final String sComponentName = "portOptDemoJava";
  
  /** Pointer to native component-data structure */
  private static final ComponentDataPtr sComponentData = new ComponentDataPtr(createComponentData(MWMCR.findComponentParentDirOnClassPath(sComponentName, "portOptDemoJava")));
  
  /** Pointer to default component options */
  private static final MWComponentOptions sDefaultComponentOptions = new MWComponentOptions(MWCtfExtractLocation.EXTRACT_TO_CACHE, new MWCtfClassLoaderSource(portOptDemoJavaMCRFactory.class));
  
  /** Creates a native component-data structure */
  static NativePtr createComponentData(String pathToComponent)
  {
    try {
      return MWMCR.getNativeMCR().mclCreateComponentData(sPublicKey,
                                                         sComponentName, "",
                                                         sSessionKey,
                                                         sMatlabPath,
                                                         sClassPath,
                                                         sLibraryPath,
                                                         sApplicationOptions,
                                                         sRuntimeOptions,
                                                         sComponentPrefDir,
                                                         pathToComponent,
                                                         sSetWarningState);
    }
    catch (MWException e) {
      return NativePtr.NULL;
    }
  }
  
  private portOptDemoJavaMCRFactory()
  {
    // Never called.
  }
  public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
  {
    if (null == componentOptions.getCtfSource()) {
      componentOptions = new MWComponentOptions(componentOptions);
      componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
    }
    return MWMCR.newInstance(sComponentData, componentOptions, portOptDemoJavaMCRFactory.class, sComponentName);
  }
  static MWMCR newInstance() throws MWException
  {
    return newInstance(sDefaultComponentOptions);
  }
}

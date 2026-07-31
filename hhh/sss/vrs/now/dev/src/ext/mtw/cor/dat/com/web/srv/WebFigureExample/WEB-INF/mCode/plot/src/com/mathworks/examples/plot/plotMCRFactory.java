/*
* MATLAB Compiler: 4.7 (R2007b)
* Date: Fri Sep 28 14:02:48 2007
* Arguments: "-B" "macro_default" "-W"
* "java:com.mathworks.examples.plot,Plotter" "-d"
* "C:\\Projects\\workspace\\WebFiguresExample\\m\\plot\\src" "-T" "link:lib"
* "-v"
* "class{Plotter:C:\\Projects\\workspace\\WebFiguresExample\\m\\getplot.m}" 
*/

package com.mathworks.examples.plot;

import com.mathworks.toolbox.javabuilder.*;

public class plotMCRFactory
{
  /** Application key data */
  private static final byte[] sSessionKey = 
  {56, 53, 68, 52, 55, 66, 57, 70, 48, 50, 65, 66, 50, 48, 54, 48, 70, 49, 57,
   54, 68, 48, 57, 56, 54, 51, 57, 66, 54, 66, 68, 56, 50, 55, 65, 53, 65, 50,
   66, 48, 51, 68, 54, 68, 70, 56, 51, 51, 67, 70, 48, 69, 51, 50, 65, 52, 65,
   69, 66, 67, 48, 49, 48, 49, 48, 52, 66, 65, 67, 50, 65, 70, 51, 66, 66, 70,
   67, 57, 54, 56, 69, 70, 66, 67, 53, 69, 67, 48, 55, 48, 57, 48, 68, 65, 69,
   54, 57, 48, 57, 55, 66, 69, 50, 66, 68, 51, 69, 54, 51, 69, 67, 70, 48, 53,
   54, 68, 57, 69, 50, 69, 52, 55, 56, 51, 65, 52, 50, 55, 50, 52, 65, 53, 54,
   56, 55, 51, 68, 52, 66, 54, 54, 52, 50, 70, 55, 70, 49, 52, 56, 57, 69, 68,
   49, 53, 69, 67, 51, 50, 65, 49, 56, 52, 48, 57, 56, 57, 48, 55, 65, 50, 57,
   50, 53, 70, 48, 68, 52, 51, 69, 70, 68, 70, 69, 68, 56, 53, 69, 55, 57, 53,
   66, 68, 70, 53, 69, 69, 66, 57, 50, 56, 55, 48, 49, 52, 68, 65, 52, 65, 56,
   56, 67, 57, 57, 55, 67, 68, 51, 50, 68, 55, 70, 65, 56, 69, 56, 48, 50, 67,
   68, 67, 56, 50, 52, 48, 55, 53, 66, 65, 68, 50, 50, 48, 51, 69, 65, 68, 49,
   65, 56, 70, 48, 70, 51, 65, 50, 65};
  
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
  {"plot/", "toolbox/compiler/deploy/", "$TOOLBOXMATLABDIR/general/",
   "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
   "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/elfun/",
   "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/matfun/",
   "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/polyfun/",
   "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/sparfun/",
   "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/graph2d/",
   "$TOOLBOXMATLABDIR/graph3d/", "$TOOLBOXMATLABDIR/specgraph/",
   "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/uitools/",
   "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/imagesci/",
   "$TOOLBOXMATLABDIR/iofun/", "$TOOLBOXMATLABDIR/audiovideo/",
   "$TOOLBOXMATLABDIR/timefun/", "$TOOLBOXMATLABDIR/datatypes/",
   "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/codetools/",
   "$TOOLBOXMATLABDIR/helptools/", "$TOOLBOXMATLABDIR/winfun/",
   "$TOOLBOXMATLABDIR/demos/", "$TOOLBOXMATLABDIR/timeseries/",
   "$TOOLBOXMATLABDIR/hds/", "$TOOLBOXMATLABDIR/guide/",
   "$TOOLBOXMATLABDIR/plottools/", "toolbox/local/",
   "toolbox/compiler/", "toolbox/javabuilder/javabuilder/"};
  
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
  private static final String sComponentPrefDir = "plot_4AD86AADE1B9064AA1CBCA6357F37527";
  
  /** Component name */
  private static final String sComponentName = "plot";
  
  /** Pointer to native component-data structure */
  private static final ComponentDataPtr sComponentData = new ComponentDataPtr(createComponentData(MWMCR.findComponentParentDirOnClassPath(sComponentName, "com.mathworks.examples.plot")));
  
  /** Pointer to default component options */
  private static final MWComponentOptions sDefaultComponentOptions = new MWComponentOptions(MWCtfExtractLocation.EXTRACT_TO_CACHE, new MWCtfClassLoaderSource(plotMCRFactory.class));
  
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
  
  private plotMCRFactory()
  {
    // Never called.
  }
  public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
  {
    if (null == componentOptions.getCtfSource()) {
      componentOptions = new MWComponentOptions(componentOptions);
      componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
    }
    return MWMCR.newInstance(sComponentData, componentOptions, plotMCRFactory.class, sComponentName);
  }
  static MWMCR newInstance() throws MWException
  {
    return newInstance(sDefaultComponentOptions);
  }
}

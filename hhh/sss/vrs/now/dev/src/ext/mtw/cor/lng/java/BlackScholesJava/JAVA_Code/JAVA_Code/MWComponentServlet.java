import javax.servlet.*;
import javax.servlet.http.*;
import com.mathworks.toolbox.javabuilder.*;
import java.io.File;
import java.lang.reflect.*;

/*
 * $Revision: $
 * $Date: $
 * $Author: $
 */

/*
 * CONFIDENTIAL AND CONTAINING PROPRIETARY TRADE SECRETS
 * Copyright (c) 1997-2006 The MathWorks, Inc. All Rights Reserved.
 * The source code contained in this listing contains proprietary and
 * confidential trade secrets of The MathWorks, Inc.  The use, modification,
 * or development of derivative work based on the code or ideas obtained
 * from the code is prohibited without the express written permission of The
 * MathWorks, Inc. The disclosure of this code to any party not authorized
 * by The MathWorks, Inc. is strictly forbidden.
 * CONFIDENTIAL AND CONTAINING PROPRIETARY TRADE SECRETS
 */

/**
 * Utility base class for servlets utilitizing a JavaBuilder-generated component.
 * 
 * To create a servlet that owns/uses a component of class T, subclass 
 * MWComponentServlet<T> and provide protected doGet, doPost, etc. methods
 * as per the HttpServlet specification.  Inside these methods, the protected
 * member iComponentInstance can be used to invoke methods on the JavaBuilder
 * component.  iComponentInstance is automatically created prior to any call to
 * doGet, doPost, etc.
 */
public class MWComponentServlet<T extends Disposable> extends HttpServlet
{
    protected T iComponentInstance = null;
    private final Class<T> fClass;
    
    protected MWComponentServlet(Class<T> c) {
        fClass = c;
    }
    
    public void init(ServletConfig config) throws ServletException {
        ServletContext ctx = config.getServletContext();
        String pathToCtf = ctx.getRealPath("/");
        try {
            if (null != pathToCtf) {
                String webappRoot = pathToCtf.substring(0,pathToCtf.length());
                pathToCtf = webappRoot + "WEB-INF" + File.separatorChar + "lib";            
                try {
                    Constructor<T> factory = fClass.getConstructor( new Class[] {String.class} );
                    iComponentInstance = factory.newInstance( new Object[] {pathToCtf} ); 
                } catch (NoSuchMethodException e) {
                    /// @todo - report error?
                    iComponentInstance = fClass.newInstance();        
                } catch (InstantiationException e) {
                    /// @todo - report error?
                } catch (InvocationTargetException e) {
                }                                
            } else {
                /// @todo - report error?
                iComponentInstance = fClass.newInstance();        
            }
        } catch (InstantiationException e) {
            /// @todo - report error?
        } catch (IllegalAccessException e) {
            /// @todo - report error?
        }
    }
    
    public void destroy () {
        if (null != iComponentInstance) {
            iComponentInstance.dispose();
        }
    }
}

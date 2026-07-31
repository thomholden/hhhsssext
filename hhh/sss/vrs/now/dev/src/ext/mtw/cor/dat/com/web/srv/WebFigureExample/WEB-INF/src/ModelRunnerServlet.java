// imported classes from JRE
import java.io.IOException;

// imported classes from servlet-api.jar
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.RequestDispatcher;

// imported classes from javabuilder.jar
import com.mathworks.toolbox.javabuilder.webfigures.WebFigure;
import com.mathworks.toolbox.javabuilder.MWJavaObjectRef;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.web.MWHttpSessionBinder;

// imported classes from plot.jar
import com.mathworks.examples.plot.Plotter;

public class ModelRunnerServlet extends HttpServlet
{
    private Plotter matlabModel = null;

    public void init(ServletConfig config) throws ServletException
    {
        super.init(config);

     
        try {
            // create a new plotter object
            matlabModel = new Plotter();
        }
        catch (MWException mcrInitError) {
            mcrInitError.printStackTrace();
        }
    }

    public void destroy()
    {
        super.destroy();
        // free MCR-related resources
        matlabModel.dispose();
    }

    protected void doGet(final HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        ServletContext servletContext = session.getServletContext();

        // find the plotter object associated with this session
        WebFigure userPlot = (WebFigure)session.getAttribute("UserPlot");

        // if this is the first time doGet has been called for this session,
        //  create the plot and WebFigure object
        if (null == userPlot) {
            try {
                // generate the plot
                Object[] results = matlabModel.getplot(/* nargout = */ 1);

                try {
                    // unpack the WebFigure
                    MWJavaObjectRef ref = (MWJavaObjectRef)results[0];
                    userPlot = (WebFigure)ref.get();

                    // store the figure in the session context
                    session.setAttribute("UserPlot", userPlot);

                    // bind the figure's lifetime to the session
                    session.setAttribute("UserPlotBinder",
                                         new MWHttpSessionBinder(userPlot));
                }
                finally {
                    // free MCR-related resources held by the results
                    MWArray.disposeArray(results);
                }
            }
            catch (MWException getplotError) {
                getplotError.printStackTrace();
            }
        }

        // forward the request to the View layer (response.jsp)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/response.jsp");
        dispatcher.forward(request, response);
    }
}
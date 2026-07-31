import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.mathworks.BSOptionModel.BSOptionModelClass;
import com.mathworks.toolbox.javabuilder.*;

public class BlackScholes extends MWComponentServlet<BSOptionModelClass>
{
    Double months=null, butterfly=null, risk=null, spot=null, volatility=null, vizrange=null, strike=null;
    String option="No Value";
    MWNumericArray RetOptVal=null;
    MWCharArray filename = null;

    public BlackScholes()
    {
        super(BSOptionModelClass.class);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        extractDatafromForm(request,response);
        callJavaBuilderComponent();
        DisplyDataOnOutputForm(request,response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        doGet(request, response);
    }

    private void callJavaBuilderComponent()
    {
        Object[] y = null;
        try
        {
            y = iComponentInstance.optionvalue(1,spot,strike,risk,months,volatility,option,vizrange);
            RetOptVal = (MWNumericArray)y[0];
            y = iComponentInstance.webvizroutine(1,spot,strike,risk,months,volatility,vizrange,option,butterfly);
            filename = (MWCharArray)y[0];  // The filename returned here is not really used in this code. This can be used
                                           // for any troubleshooting purpose to make syre that the image file is being written
                                           // in the correct location
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    private void DisplyDataOnOutputForm(HttpServletRequest request, HttpServletResponse response)
    {
        try
        {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
                    "Transitional//EN\">\n" +
                    "<HTML>");
            out.println("<head><title>Blackscholes Example using MATLAB Builder for JAVA</title></head>");

            out.println("<BODY BGCOLOR=\"#FDF5E6\">");
            out.println("<P><ALIGN=\"CENTER\"><IMG SRC=\"/BlackScholes/images/matlab.ico\" WIDTH=\"99\" HEIGHT=\"123\" ALIGN=\"BOTTOM\" BORDER=\"0\">");
            out.println("<H1 ALIGN=\"CENTER\">" + "Black Scholes Option Calculation" + "</H1>");

            out.println("<TABLE BORDER=\"1\" WIDTH=\"100%\">");

            out.println("<TR><Th>Spot Price</Th>" +
                            "<Th>Strike Price</Th>" +
                            "<Th>Risk Free Rate</Th>" +
                            "<Th>Months to Expiry</Th>" +
                            "<Th>Volatility</Th>" +
                            "<Th>Visualization Range</Th>" +
                            "<Th>Butterfly Range</Th>" +
                        "</TR>");

            out.println("<TR><TD align=\"center\">"+spot+"</TD>" +
                            "<TD align=\"center\">"+strike+"</TD>"+
                            "<TD align=\"center\">"+risk+"</TD>"+
                            "<TD align=\"center\">"+months+"</TD>"+
                            "<TD align=\"center\">"+volatility+"</TD>"+
                            "<TD align=\"center\">"+vizrange+"</TD>"+
                            "<TD align=\"center\">"+butterfly+"</TD>"+
                        "</TR>");

            out.println("</TABLE>");
            out.println("<H1 ALIGN=\"CENTER\">" + "The calculated " + option + " option Value: $" + RetOptVal.toString() + "</H1>");
            out.println("<br />");
            out.println("<div ALIGN=\"CENTER\">");
            out.println("<img src=\"/BlackScholes/images/vizoption.jpg\" alt=\"/BlackScholes/images/vizoption.jpg\" />");
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        }
        catch(java.io.IOException ex)
        {
            ex.printStackTrace();
        }
    }

    private void extractDatafromForm(HttpServletRequest request, HttpServletResponse response)
    {
        Enumeration paramNames = request.getParameterNames();

        while(paramNames.hasMoreElements())
        {
            String paramName = (String)paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            paramName = paramName.toLowerCase();

            if(paramName.equals("themonths"))
            {
                months = new Double(paramValue);
            }
            else if(paramName.equals("thebutterfly"))
            {
                butterfly = new Double(paramValue);
            }
            else if(paramName.equals("therisk"))
            {
                risk = new Double(paramValue);
            }
            else if(paramName.equals("spot"))
            {
                spot = new Double(paramValue);
            }
            else if(paramName.equals("thevolatility"))
            {
                volatility = new Double(paramValue);
            }
            else if(paramName.equals("thevizrange"))
            {
                vizrange = new Double(paramValue);
            }
            else if(paramName.equals("strike"))
            {
                strike = new Double(paramValue);
            }
            else if(paramName.equals("optionchosen"))
            {
                option = paramValue;
                option = option.toLowerCase();
            }
        }
    }
}


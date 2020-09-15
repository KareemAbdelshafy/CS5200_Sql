package sentbot.servlet;

import sentbot.dal.*;
import sentbot.model.*;
import sentbot.model.Source.Sector;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/indexfundcreate")
public class IndexFundCreate extends HttpServlet {
	
	protected IndexFundDao indexFundDao;
	
	@Override
	public void init() throws ServletException {
		indexFundDao = IndexFundDao.getInstance();
	}
	
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// Map for storing messages.
        Map<String, String> messages = new HashMap<String, String>();
        req.setAttribute("messages", messages);
        //Just render the JSP.   
        req.getRequestDispatcher("/CreateIndexFund.jsp").forward(req, resp);
	}
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    		throws ServletException, IOException {
        // Map for storing messages.
        Map<String, String> messages = new HashMap<String, String>();
        req.setAttribute("messages", messages);

        // Retrieve and validate SourceKey.
        String sourceKey = req.getParameter("sourcekey");
        if (sourceKey == null || sourceKey.trim().isEmpty()) {
            messages.put("success", "Invalid Source Key");
        } else {
        	// Create the Comment.
        	int sKey = Integer.parseInt(req.getParameter("sourcekey"));
        	ImpactedInvestment.Sector sector = ImpactedInvestment.Sector.valueOf(req.getParameter("sector"));
        	String name = req.getParameter("name");
        	String tick = req.getParameter("ticker");

	        try {
	        	//( String Ticker, Sector Sector, String IndexFundName, int SourceKey)

	        	IndexFund comment = new IndexFund(tick, sector, name, sKey );
	        	comment = indexFundDao.create(comment);
	        	messages.put("success", "Successfully created " + sKey);
	        } catch (SQLException e) {
				e.printStackTrace();
				throw new IOException(e);
	        }
        }
        
        req.getRequestDispatcher("/CreateIndexFund.jsp").forward(req, resp);
    }
}

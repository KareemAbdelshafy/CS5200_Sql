package sentbot.servlet;

import sentbot.dal.*;
import sentbot.model.*;
import sentbot.model.Source.Sector;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sentbot.dal.CommentDao;

@WebServlet("/findindexfund")
public class FindIndexFund extends HttpServlet {
	
	/**
	 * 
	 */
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
        List<IndexFund> comment = new ArrayList<IndexFund>();
        
        // Retrieve and validate name.
        // sentiment is retrieved from the URL query string.
        String sectorS = req.getParameter("sector");
        ImpactedInvestment.Sector sector ;
        try {

        	sector = ImpactedInvestment.Sector.valueOf(sectorS);
        	
        	// Retrieve comment, and store as a message.
        	try {

            	comment = indexFundDao.getIndexFundFromSector(sector);

            } catch (SQLException e) {
    			e.printStackTrace();
    			throw new IOException(e);
            }
        	messages.put("success", "Displaying results for " + sectorS);
        	// Save the previous search term, so it can be used as the default
        	// in the input box when rendering FindComment.jsp.
        	messages.put("previousSentiment", sectorS);
        	

        } catch (IllegalArgumentException e) {
            messages.put("success", "No records found, Please enter a valid sector (energy, materials,"
            		+ " industrials, consumerdiscretionary, consumerstaples, healthcare, "
            		+ "financials, informationtechnology, teclecommunicationservices, utilities, realestate).");   	
        }
        req.setAttribute("comment", comment);
        
        req.getRequestDispatcher("/FindIndexFund.jsp").forward(req, resp);
		/*  */
	}
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    		throws ServletException, IOException {
		
        Map<String, String> messages = new HashMap<String, String>();
        req.setAttribute("messages", messages);
        List<IndexFund> comment = new ArrayList<IndexFund>();
        
        // Retrieve and validate name.
        // sentiment is retrieved from the URL query string.
        String sectorS = req.getParameter("sector");
        ImpactedInvestment.Sector sector ;
        try {

        	sector = ImpactedInvestment.Sector.valueOf(sectorS);
        	
        	// Retrieve comment, and store as a message.
        	try {

            	comment = indexFundDao.getIndexFundFromSector(sector);

            } catch (SQLException e) {
    			e.printStackTrace();
    			throw new IOException(e);
            }
        	messages.put("success", "Displaying results for " + sectorS);
        	// Save the previous search term, so it can be used as the default
        	// in the input box when rendering FindComment.jsp.
        	messages.put("previousSentiment", sectorS);
        	

        } catch (IllegalArgumentException e) {
            messages.put("success", "No records found, Please enter a valid sector (energy, materials,"
            		+ " industrials, consumerdiscretionary, consumerstaples, healthcare, "
            		+ "financials, informationtechnology, teclecommunicationservices, utilities, realestate).");   	
        }
        req.setAttribute("comment", comment);
        
        req.getRequestDispatcher("/FindIndexFund.jsp").forward(req, resp);
		/*  */
	}
	
}


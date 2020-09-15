package sentbot.servlet;

import sentbot.dal.*;
import sentbot.model.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/indexfundupdate")
public class IndexFundUpdate extends HttpServlet {
	
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
    	/*
        // Retrieve comment and validate.
        String ticker = req.getParameter("ticker");
        String sectorS = req.getParameter("oldsector");

        if (ticker == null || ticker.trim().isEmpty() || sectorS ==null || sectorS.trim().isEmpty() ){
            messages.put("success", "Please enter a valid ticker.");
        } else {
        	try {
                ImpactedInvestment.Sector sector = ImpactedInvestment.Sector.valueOf(sectorS);
        		IndexFund comment = indexFundDao.getIndexFundFromTickerSector(ticker, sector);
        		if(comment == null) {
        			messages.put("success", "Index Fund does not exist.");
        		}
        	
        		 * } else {
        			String newSentiment = req.getParameter("sentiment");
        			if (newSentiment == null || newSentiment.trim().isEmpty()) {
        	            messages.put("success", "Please enter a valid Sentiment.");
        	        } else {
        	        	comment = commentDao.updateSentiment(comment, newSentiment);
        	        	messages.put("success", "Successfully updated " + comment);
        	        }
        		}
        		 * 
        		 
        		
        		req.setAttribute("comment", comment);
        	} catch (SQLException e) {
				e.printStackTrace();
				throw new IOException(e);
	        }
        }
      */
        req.getRequestDispatcher("/IndexFundUpdate.jsp").forward(req, resp);
       
	}
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    		throws ServletException, IOException {
        // Map for storing messages.
		// Map for storing messages.
        Map<String, String> messages = new HashMap<String, String>();
        req.setAttribute("messages", messages);

        // Retrieve comment and validate.
        String ticker = req.getParameter("ticker");
        String sectorS = req.getParameter("oldsector");
        ImpactedInvestment.Sector sector = ImpactedInvestment.Sector.valueOf(sectorS);
        if (ticker == null || ticker.trim().isEmpty()){
            messages.put("success", "Please enter a valid ticker.");
        } else {
        	try {
        		IndexFund comment = indexFundDao.getIndexFundFromTickerSector(ticker, sector);
        		if(comment == null) {
        			messages.put("success", "Index Fund does not exist.");
        		}
        		
        		 else {
        			String newSector = req.getParameter("newsector");
        			if (newSector == null || newSector.trim().isEmpty()) {
        	            messages.put("success", "Please enter a valid Sentiment.");
        	        } else {
        	            ImpactedInvestment.Sector newsector = ImpactedInvestment.Sector.valueOf(newSector);

        	        	comment = indexFundDao.updateSector(comment, newsector);
        	        	messages.put("success", "Successfully updated " + comment);
        	        }
        		}
        		/* 
        		 */
        		
        		req.setAttribute("comment", comment);
        	} catch (SQLException e) {
				e.printStackTrace();
				throw new IOException(e);
	        }
        }
        
        req.getRequestDispatcher("/IndexFundUpdate.jsp").forward(req, resp);
    }
}
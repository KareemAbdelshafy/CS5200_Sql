package sentbot.servlet;

import sentbot.dal.*;
import sentbot.model.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.annotation.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/indexfunddelete")
public class IndexFundDelete extends HttpServlet {
	
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
        // Provide a title and render the JSP.
        messages.put("title", "Delete Index Fund");        
        req.getRequestDispatcher("/IndexFundDelete.jsp").forward(req, resp);
	}
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    		throws ServletException, IOException {
        // Map for storing messages.
        Map<String, String> messages = new HashMap<String, String>();
        req.setAttribute("messages", messages);
        IndexFund comment;
        // Retrieve and validate sourceKey.
        String sourcekey = req.getParameter("sourcekey");
        if (sourcekey == null || sourcekey.trim().isEmpty()){
            messages.put("success", "Please enter a valid ticker.");
        } else {
        	try {
	        	comment = indexFundDao.delete(Integer.parseInt(sourcekey));

		        if (comment == null) {
		            messages.put("title", "Successfully deleted Index Fund ");
		            messages.put("disableSubmit", "true");
		        } else {
		        	messages.put("title", "Failed to delete Index Fund " );
		        	messages.put("disableSubmit", "false");
		        }
        		/* 
        		 */
        		
        		req.setAttribute("comment", comment);
        	} catch (SQLException e) {
				e.printStackTrace();
				throw new IOException(e);
	        }
        }
        
        req.getRequestDispatcher("/IndexFundDelete.jsp").forward(req, resp);
    }
}

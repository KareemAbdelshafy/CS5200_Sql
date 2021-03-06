<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create a Fund Index</title>
</head>
<body>
	<h1>Create Fund Index</h1>
	<form action="indexfundcreate" method="post">
		<p>
			<label for="sourcekey">Enter Source Key</label>
			<input id="sourcekey" name="sourcekey" value="">
		</p>
		<p>
		valid sectors (energy, materials
            		 industrials, consumerdiscretionary, consumerstaples, healthcare
            		financials, informationtechnology, teclecommunicationservices, utilities, realestate)<br>
			<label for="sector">Enter Sector</label>
			<input id="sector" name="sector" value="">
		</p>
		<p>
			<label for="name">Enter Fund Index name</label>
			<input id="name" name="name" value="">
		</p>
		<p>
			<label for="ticker">Enter Affected Ticker</label>
			<input id="ticker" name="ticker" value="">
		<p>
			<input type="submit">
		</p>
	</form>
	<br/><br/>
	<p>
		<span id="successMessage"><b>${messages.success}</b></span>
	</p>
</body>
</html>
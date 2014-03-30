<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>
<% String username = (String) session.getAttribute("username"); %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<script>
$(document).ready(function () {
  $('#helpLink').click(function (e) {
    window.open('help.html', '', 'width=500,height=600');
  });
});
</script>
<html>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>EDIT IMAGES</TITLE>
</HEAD>
<body bgcolor="#eeeeee" text="#765500">
<center>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import= "java.util.* "%>
<%@ page import= "java.lang.System.* "%>
<%@	page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
	if(request.getParameter("bSubmit") != null)
	{
		File f = new File(request.getSession().getServletContext().getRealPath("/admininformation.txt"));

		BufferedReader bf = new BufferedReader(new FileReader(f));
		String sql_user = (bf.readLine()).trim();
		String sql_key = (bf.readLine()).trim();

		Connection conn = null;
	
	
	    String driverName = "oracle.jdbc.driver.OracleDriver";
	    String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	    try{
	        //load and register the driver
			Class drvClass = Class.forName(driverName); 
	    	DriverManager.registerDriver((Driver) drvClass.newInstance());
		}
	    catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");	
	    }	
		try{
	    	//establish the connection
	       	conn = DriverManager.getConnection(dbstring,sql_user,sql_key);
			conn.setAutoCommit(false);
	    }
		catch(Exception ex){	    
	        out.println("<hr>" + ex.getMessage() + "<hr>");
		}	
		
		
	
		//get the input from EditPicInfor.jsp	
		//if the input is empty, we initialize the attribute to NULL in DB
		String doctor_name = (request.getParameter("doctor")).trim();
		String patient_name = (request.getParameter("patient")).trim(); 
		String test_type = (request.getParameter("test_type")).trim(); 
		if(test_type.equals(""))
		{ test_type = "NULL";}
		else
		{ //test_type = "'"+test_type+"'";
		}		
		String prescribing_date = (request.getParameter("prescribing_date")).trim();
		if(prescribing_date.equals("i.e.01/01/2013"))
		{	prescribing_date = "01/01/2013";}
		else
		{   //prescribing_date = "'"+prescribing_date+"'";
		}		
		String test_date = (request.getParameter("test_date")).trim(); 
		if(test_date.equals("i.e.01/01/2013"))
		{  	test_date = "01/01/2013";}
		else
		{ //test_date = "'"+test_date+"'";
		}		
		String diagnosis = (request.getParameter("diagnosis")).trim(); 
		if(diagnosis.equals(""))
		{  diagnosis = "NULL";}
		else
		{ //diagnosis = "'"+diagnosis+"'";
		}
		String description = (request.getParameter("description")).trim();
		if(description.equals(""))
		{ description = "NULL";}
		else
		{ //description = "'"+description+"'";
		}
		
		Statement stmt = null;
		ResultSet rset = null;
		int check_match = 0;
		String sql = "select distinct patient_name from family_doctor where doctor_name = '"+doctor_name+"'";
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
                ResultSet.CONCUR_READ_ONLY);
		rset = stmt.executeQuery(sql);
		while(rset.next()){
			if(patient_name.equals(rset.getString(1))){
				check_match = 1;
				session.setAttribute("doctor", doctor_name);
				session.setAttribute("patient", patient_name);
				session.setAttribute("test_type", test_type);
				session.setAttribute("prescribing_date", prescribing_date);
				session.setAttribute("test_date", test_date);
				session.setAttribute("diagnosis", diagnosis);
				session.setAttribute("description", description);
		    	out.println("the doctor name is:    	  "+doctor_name+"<br>");
		    	out.println("the patient name is:      "+patient_name+"<br>");
		    	out.println("the test type is:     "+test_type+"<br>");
		    	
		    	if (prescribing_date.equals("SYSDATE"))
		    		{out.println("the prescribing date is:      today<br>");}
		    	else
		    		{out.println("the prescribing date is:      "+prescribing_date+"<br>");}
		    		
		    	if (test_date.equals("SYSDATE"))
		    		{out.println("the test date is:      today<br>");}
		    	else
		    		{out.println("the test date is:      "+test_date+"<br>");}
		    		
				out.println("the diagnosis is:     "+diagnosis+"<br>");
		    	out.println("the description is:     "+description+"<br>");		
				%>
				<form method="post" action="UploadResult.jsp">
				<INPUT TYPE="HIDDEN" NAME="username" value=<%= username %>>
				click on CONTINUE to confirm, BACK to Upload Page...<br>
				<input name="bSubmit" value="CONTINUE" type="submit">
				<a style="color:#A9A9A9;" href="upload_form.jsp">BACK</a>
				</form>
				<%
			}
		}
		if(check_match == 0){
			out.println("<center><h1>Sorry, the doctor name does not match with the patient name, please go back and check again.</h1></center>");
		}
	}
%>
</center>
</body>
</html>
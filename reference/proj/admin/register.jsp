<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>
<html>
<head>
<title>Register</title>
</head>
<body>
<center>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<% 	//get all the information from the register.html
	String username = (request.getParameter("USERNAME")).trim();
	String password = (request.getParameter("PASSWORD")).trim();
	String firstname = (request.getParameter("FIRSTNAME")).trim();
	String lastname = (request.getParameter("LASTNAME")).trim();
	String address = (request.getParameter("ADDRESS")).trim();
	String email = (request.getParameter("EMAIL")).trim();
	String phonenumber = (request.getParameter("PHONENUMBER")).trim();
	String class_code = (request.getParameter("class")).trim();
	//make connection by the user name and key in a txt file
	File f = new File(request.getSession().getServletContext().getRealPath("/admininformation.txt"));

	BufferedReader bf = new BufferedReader(new FileReader(f));
	String sql_user = (bf.readLine()).trim();
	String sql_key = (bf.readLine()).trim();
	String sql_host = (bf.readLine()).trim();
	String sql_port = (bf.readLine()).trim();
	Connection conn = null;
	String driverName = "oracle.jdbc.driver.OracleDriver";
        String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	try{
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
	//insert the registation information into the table
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rset = null;
	ResultSet rset2 = null;
	Boolean check2 = true;
	Boolean check = true;
	String check_table = "SELECT * FROM persons WHERE USER_NAME='"+username+"'";
	String check_table2 = "SELECT * FROM persons WHERE EMAIL='"+email+"'";
	String add_person = "insert into persons " + "values('"+username+"','"+firstname+"','"+lastname+"','"+address+"','"+email+"','"+phonenumber+"')";
	String add_users = "insert into users " + "values('"+username+"','"+password+"','"+class_code+"',sysdate)";
	try{
        	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
                                        ResultSet.CONCUR_READ_ONLY);  
        	stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
                    ResultSet.CONCUR_READ_ONLY);
        	rset=stmt.executeQuery(check_table);
        	rset2=stmt2.executeQuery(check_table2);
        	if(rset.next()){
        		check = false;}
        	if(rset2.next()){
        		check2 = false;}
        	if (check){
        		if(check2){
        	  	stmt.executeQuery(add_users);	
				stmt.executeQuery(add_person);
				conn.commit();
        		}        
        	}
    	}
        catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	} 
    	if (check){
    		if(check2){
    		//session.setAttribute( "username", username );
    		out.println("Registation successed <br>"+"User Name  : "+username+"<br> Password  : "+
    			password+"<br> First name  : "+firstname+"<br> Last name  : "+lastname+"<br> Email  :"+
    			email+"<br> Phone Number  : "+phonenumber);
    		//success registation and jump to the main page
    		String loged_in = username;
        	//session.setAttribute( "loged_in", loged_in );
        	//session.setAttribute( "username", username );
    		%>
    		<br>
    		<a href="../index.jsp">Click to Main Page</a>
    		<%
    		}
    		else{
    			out.println("<br>Email address taken, please chose another.<br>");
       		 %>
       		 <a href="./register_form.jsp">register</a>
       		 <%
    		}
    	}
    	else {
    		 out.println("<br>Username taken, please chose another.<br>");
    		 %>
    		 <a href="./register_form.jsp">register</a>
    		 <%
    		
    	}	
    	%>
	
</center>
</body>

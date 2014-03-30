<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>
<% String username = (String) session.getAttribute("username"); %>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@page pageEncoding="GBK" contentType="text/html; charset=GBK" %>
<html>
<head>
<title>Upload Image</title>
</head>
<body>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<script type="text/javascript">
  $(document).ready(function () {
     $('#prescribing_date').datepicker(); 
     $('#test_date').datepicker();   
     $('#upload').toggleClass('active');
     $('#helpLink').click(function (e) {
    	window.open('help.html', '', 'width=500,height=600');
  });
  });
</script>
<form method="post" action="UploadProcess.jsp">
<% 


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
	
		Statement stmt = null;
		Statement stmt1 = null;
		ResultSet rset = null;
		ResultSet rset1 = null;
		ArrayList<String> dr_name = new ArrayList<String>();
		ArrayList<String> p_name = new ArrayList<String>();
		String sql = "select user_name from users where class = 'd' order by user_name";
		String sql1 = "select user_name from users where class = 'p' order by user_name";
		try {
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
					ResultSet.CONCUR_READ_ONLY);
			rset = stmt.executeQuery(sql);
			
		}
		catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
    	int i = 0;
    	
		while (rset.next()&&rset!=null) {
			dr_name.add(rset.getString(1));
			i++;
		}
		
		try {
			stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
					ResultSet.CONCUR_READ_ONLY);
			rset1 = stmt1.executeQuery(sql1);
			
		}
		catch(Exception ex){
            out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
		int n = 0;
		while (rset1.next()&&rset!=null) {
			p_name.add(rset1.getString(1));
		}
		rset.close();
		rset1.close();
		stmt.close();
		stmt1.close();
		conn.close();
	%>

	

<INPUT TYPE="HIDDEN" NAME="username" value=<%= username %>>
<table align="center" width="50%" height="25%">
<tbody>
<tr>
<th>Doctor Name:</th>
<td>
<select  name="doctor">
<%	for(int j=0;j<dr_name.size();j++){	
	out.println("<option value= '"+dr_name.get(j)+"'>"+dr_name.get(j)+"</option>");
	}
%>
</select></td>
</tr>
<tr>
<th>Patient Name:</th>
<td>
<select name="patient">
<%	for(int j=0;j<p_name.size();j++){		
out.println("<option value= '"+p_name.get(j)+"'>"+p_name.get(j)+"</option>");
	}
%>
</select></td>
</tr>
<tr>
<th>Test Type:   </th>
<td><input type="text" name="test_type" size="35" value=""></td>
</tr>
<tr>
<th>Prescribing Date:</th>
<td><input type="text" id="prescribing_date" name="prescribing_date" value="i.e.01/01/2013" onFocus="if (value=='i.e.01/01/2013'){value = ''}" onBlur="if(value==''){value='i.e.01/01/2013'}"></td>
</tr>
<tr>
<th>Test Date:</th>
<td><input type="text" id="test_date" name="test_date" value="i.e.01/01/2013" onFocus="if (value=='i.e.01/01/2013'){value = ''}" onBlur="if(value==''){value='i.e.01/01/2013'}"></td>
</tr>
<tr>
<th>Diagnosis:   </th>
<td><input type="text" name="diagnosis" size="35" value=""></td>
</tr>
<tr>
<th>Description:</th>
<td><input type="text" name="description" size="35" value=""></td>
</tr>
<tr align="center">
<td colspan="2">
<input name="bSubmit" value="Upload" type="submit">
      
<input name="Reset" value="Reset" type="reset">
</td>
</tr>
</tbody>
</table>

<center>
	<strong><h1>Upload Images</h1></strong>
 <table border="0" cellpadding="7" cellspacing="0" width="640">
	<tbody><tr><td colspan="2" align="center"><font color="red" face="arial" size="+1"><b><u>JUpload - File Upload Applet</u></b></font></td></tr>
	<tr height="20"></tr>
	<tr><td colspan="2" bgcolor="#3f7c98"><center><font color="#ffffff">FileUpload Applet</font></center></td></tr>
	<tr><td colspan="2" align="center">
	
	<applet code="applet-basic_files/wjhk.JUploadApplet" name="JUpload" archive="applet-basic_files/wjhk.jar" mayscript="" height="300" width="640">
    	<param name="CODE" value="wjhk.jupload2.JUploadApplet">
    	<param name="ARCHIVE" value="../wjhk.jupload.jar">
    	<param name="type" value="application/x-java-applet;version=1.4">
    	<param name="scriptable" value="false">    
    	<param name="postURL" value="http://<%=sql_host%>:<%=sql_port%>/proj/upload/parseRequest.jsp?URLParam=URL+Parameter+Value">
    	<param name="nbFilesPerRequest" value="2">    
	Java 1.4 or higher plugin required.
	</applet>
	</td>
	</tr>
	</tbody>
	</table>

</center>
 </form>
	
</body>

</html>

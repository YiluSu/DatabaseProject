<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");

	Connection connection = null;
	
	try {
	    String m_url = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
       	    String m_driverName = "oracle.jdbc.driver.OracleDriver";

	    String filePath = application.getRealPath("/") + "admininformation.txt";
	    BufferedReader bf = new BufferedReader(new FileReader(filePath));
	    String m_userName = bf.readLine().trim();
	    String m_password = bf.readLine().trim();

	    Class.forName("oracle.jdbc.OracleDriver");
							      
	    connection = DriverManager.getConnection(m_url, m_userName, m_password);
        } catch (SQLException e) {
	    out.println("error connecting");
        } finally {
	  
        }

%>
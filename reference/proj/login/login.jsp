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

		String query = "SELECT * FROM users WHERE user_name = ? AND password = ?";
		PreparedStatement stmt = connection.prepareStatement(query);
		stmt.setQueryTimeout(30);
		stmt.setString(1, username);
		stmt.setString(2, password);

		ResultSet rset = stmt.executeQuery();

		Boolean success = false;
		if (rset.next()) {
		      session.setAttribute("username", username);
		      session.setAttribute("class", rset.getString("class"));
		      response.sendRedirect("../homepage/index.jsp"); // homepage after logging in
		} else {
		      response.sendRedirect("login_failed.html"); 
		}
	} catch (SQLException e) {
		out.println(e.getMessage());
	} finally {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException e) {
			out.println(e);
		}
	}
%>
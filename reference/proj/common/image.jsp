<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
Connection conn;
	try
	{
		String m_url = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		String m_driverName = "oracle.jdbc.driver.OracleDriver";

		String filePath = application.getRealPath("/") + "admininformation.txt";
		BufferedReader bf = new BufferedReader(new FileReader(filePath));
		String m_userName = bf.readLine().trim();
		String m_password = bf.readLine().trim();

		Class drvClass = Class.forName(m_driverName);
		DriverManager.registerDriver((Driver)
		drvClass.newInstance());
				      
		conn = DriverManager.getConnection(m_url, m_userName, m_password);
        }
	catch (SQLException e)
	{
		out.print("Error displaying data: ");
		out.println(e.getMessage());
		return;
	}

String image_id = request.getParameter("image_id");
String record_id = request.getParameter("record_id");
String size = request.getParameter("size");
String query;


if (size == null) {
  size = "regular_size";
}

if (size.equals("thumbnail")) {
  query = "SELECT thumbnail FROM pacs_images WHERE image_id = ? AND record_id = ?";
} else if (size.equals("large_size")) {
  query = "SELECT full_size FROM pacs_images WHERE image_id = ? AND record_id = ?";
} else {
  query = "SELECT regular_size FROM pacs_images WHERE image_id = ? AND record_id = ?";

}

PreparedStatement stmt = conn.prepareStatement(query);
stmt.setString(1, image_id);
stmt.setString(2, record_id);

ResultSet rset = stmt.executeQuery();
rset.next();

Blob blob = rset.getBlob(1);

int length = (int) blob.length();
byte[] data = blob.getBytes(1, length);

response.setContentType("image/jpeg");
response.setContentLength(length);
response.getOutputStream().write(data);

conn.close();
%>

<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%

boolean success = true;

try {
String query = "UPDATE persons SET first_name = ?, last_name = ?, address = ?, email = ?, phone = ? WHERE user_name = ?";
PreparedStatement stmt = connection.prepareStatement(query);

stmt.setString(1, request.getParameter("first_name"));
stmt.setString(2, request.getParameter("last_name"));
stmt.setString(3, request.getParameter("address"));
stmt.setString(4, request.getParameter("email"));
stmt.setString(5, request.getParameter("phone"));
stmt.setString(6, request.getParameter("user_name"));

stmt.executeQuery();

String pword = request.getParameter("password");
if (!pword.equals("")) {

   query = "UPDATE users SET password = ? WHERE user_name = ?";
   stmt = connection.prepareStatement(query);
   
   stmt.setString(1, pword);
   stmt.setString(2, (String) session.getAttribute("username"));

   stmt.executeQuery();
}

} catch (SQLException e) {
  success = false;
} finally {
  connection.close();
}

if (success) {
  response.sendRedirect("../homepage/index.jsp");
} else {
  out.println("This email has already been used");
}

%>
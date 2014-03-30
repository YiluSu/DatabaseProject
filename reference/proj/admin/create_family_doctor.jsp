1;2c<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%

String doctor = request.getParameter("doctor");
String patient = request.getParameter("patient");

String query = "INSERT INTO family_doctor VALUES (?, ?)";
PreparedStatement stmt = connection.prepareStatement(query);
 
stmt.setString(1, doctor);
stmt.setString(2, patient);

try {
    stmt.executeQuery();
} catch (SQLException e) {
    // probably failed because there's already record so do nothing
}

connection.close();

response.sendRedirect("family_doctor_form.jsp");

%>

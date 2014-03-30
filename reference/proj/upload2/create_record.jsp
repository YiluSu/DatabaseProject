<%@ include file="../common/sql.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%

String query, record_id;
PreparedStatement stmt;
ResultSet rset;

query = "SELECT record_id_seq.nextval FROM dual";
stmt = connection.prepareStatement(query);
rset = stmt.executeQuery();
rset.next();
record_id = rset.getString(1);

SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
java.util.Date prescribing_date = format.parse(request.getParameter("prescribing_date"));
java.util.Date test_date = format.parse(request.getParameter("test_date"));

query = "INSERT INTO radiology_record VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
stmt = connection.prepareStatement(query);
stmt.setString(1, record_id);
stmt.setString(2, request.getParameter("patient_name"));
stmt.setString(3, request.getParameter("doctor_name"));
stmt.setString(4, request.getParameter("radiologist_name"));
stmt.setString(5, request.getParameter("test_type"));
stmt.setDate(6, new java.sql.Date(prescribing_date.getTime()));
stmt.setDate(7, new java.sql.Date(test_date.getTime()));
stmt.setString(8, request.getParameter("diagnosis"));
stmt.setString(9, request.getParameter("description"));

stmt.executeQuery();
connection.close();

session.setAttribute("record_id", record_id);
response.sendRedirect("radiology_record.jsp?record_id=" + record_id);

%>
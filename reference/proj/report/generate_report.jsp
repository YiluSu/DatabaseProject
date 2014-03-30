<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>
<script type="text/javascript">
  $(document).ready(function () {
    $('#reports').toggleClass('active');
    $('#helpLink').click(function () {
      window.open('results_help.html', '', 'width=500,height=600');
    });
  });
</script>

<h2>Parameters</h2>

<table class="simple-table">
<tr><th>Start date:</th><td><%= request.getParameter("start_date") %></td></tr>
<tr><th>End date:</th><td><%= request.getParameter("end_date") %></td></tr>
<tr><th>Diagnosis:</th><td><%= request.getParameter("diagnosis") %></td></tr>
</table>

<h2>Results</h2>

<%

String queryString = "select first_name, last_name, address, test_date from (select patient_name, max(test_date) as test_date from radiology_record where test_date > ? and test_date < ? and contains (diagnosis, ?) > 1 group by patient_name) r, persons p where r.patient_name = p.user_name";

PreparedStatement statement = connection.prepareStatement(queryString);

SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
java.util.Date start_date = format.parse(request.getParameter("start_date"));
java.util.Date end_date = format.parse(request.getParameter("end_date"));

statement.setDate(1, new java.sql.Date(start_date.getTime()));
statement.setDate(2, new java.sql.Date(end_date.getTime()));
statement.setString(3, request.getParameter("diagnosis"));

ResultSet rs = statement.executeQuery();
%>

<table class="table">
<tr><th>Last Name</th><th>First Name</th><th>Address</th><th>Test Date</th></tr>

<%
while (rs.next()) {
%>

<tr>
<td><%= rs.getString("last_name") %></td>
<td><%= rs.getString("first_name") %></td>
<td><%= rs.getString("address") %></td>
<td><%= rs.getDate("test_date") %></td>
</tr>

<%
} // while

connection.close();
%>

</body>
</html>


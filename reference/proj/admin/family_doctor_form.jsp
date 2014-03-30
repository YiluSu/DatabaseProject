<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
    $('#admin').toggleClass('active');
    $('#helpLink').click(function (e) {
      window.open('family_doctor_help.html', '', 'width=500,height=600');
    });
  });
</script>

<div class="container"> 

<form class="form-signin" action="create_family_doctor.jsp" method="post">
<h2>Create Family Doctor</h2>

<table>
<tr>
  <th>Doctor</th>
  <td><select name="doctor">
<%

String query = "SELECT user_name FROM users WHERE class = ?";
PreparedStatement stmt = connection.prepareStatement(query);

stmt.setString(1, "d");
ResultSet rset = stmt.executeQuery();

while (rset.next()) {
  String user_name = rset.getString("user_name");
%>
  <option value="<%= user_name %>"><%= user_name %></option>
<%
}
%>
  </select></td>
</tr>
<tr>
  <th>Patient</th>
  <td><select name="patient">
<%

stmt.setString(1, "p");
rset = stmt.executeQuery();

while (rset.next()) {
  String user_name = rset.getString("user_name");
%>
  <option value="<%= user_name %>"><%= user_name %></option>
<%
}
%>
  </select></td>
</tr>
<tr><th></th><td><button type="submit" class="btn btn-primary">Create</button></td></tr>
</table>
</form>

<form class="form-signin" action="delete_family_doctor.jsp">
<h2>Delete Family Doctor</h2>

<table class="table">
<tr><th></th><th>Doctor</th><th>Patient</th></tr>
<%

query = "SELECT * FROM family_doctor";
stmt = connection.prepareStatement(query);
rset = stmt.executeQuery();

while (rset.next()) {
  String doctor = rset.getString("doctor_name");
  String patient = rset.getString("patient_name");
%>
<tr>
<td><input type="checkbox" name="doctor patient" value="<%= doctor %> <%= patient %>"></td>
<td><%= doctor %></td>
<td><%= patient %></td>
</tr>
<%
}
%>
</table>
<button type="submit" class="btn btn-danger">Delete</button>
</form>

<%
connection.close();
%>

<div> <!-- container -->
</body>
</html>
<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
     $('#prescribing_date').datepicker(); 
     $('#test_date').datepicker();   
     $('#upload').toggleClass('active');
  });
</script>

<form class="form-signin" action="create_record.jsp" method="post">
<table>
<tr>
<th>Patient:</th>
<td><select name="patient_name"><%

String query = "SELECT users.user_name, first_name, last_name FROM users, persons WHERE users.class = 'p' AND users.user_name = persons.user_name";
PreparedStatement stmt = connection.prepareStatement(query);
ResultSet rset = stmt.executeQuery();

while (rset.next()) {
%>
<option value="<%= rset.getString(1) %>"><%= rset.getString(2) + " " + rset.getString(3) %></option>
<%
}

%></select>
</td>
</tr>
<tr>
<th>Doctor:</th>
<td><select name="doctor_name"><%

query = "SELECT users.user_name, first_name, last_name FROM users, persons WHERE users.class = 'd' AND users.user_name = persons.user_name";
stmt = connection.prepareStatement(query);
rset = stmt.executeQuery();

while (rset.next()) {
%>
<option value="<%= rset.getString(1) %>"><%= rset.getString(2) + " " + rset.getString(3) %></option>
<%
}
%></select>
</td>
</tr>
<tr>
<th>Radiologist:</th>
<td><select name="radiologist_name"><%

query = "SELECT users.user_name, first_name, last_name FROM users, persons WHERE users.class = 'r' AND users.user_name = persons.user_name";
stmt = connection.prepareStatement(query);
rset = stmt.executeQuery();

while (rset.next()) {
%>
<option	value="<%= rset.getString(1) %>"><%= rset.getString(2) + " " +	rset.getString(3) %></option>
<%
}
%></select>
</td>
</tr>
<tr><th>Test Type:</th><td><input type="text" maxlength="24" name="test_type"></td></tr>
<tr><th>Prescribing Date:</th><td><input type="text" name="prescribing_date" id="prescribing_date"></td></tr>
<tr><th>Test Date:</th><td><input type="text" name="test_date" id="test_date"></td></tr>
<tr><th>Diagnosis:</th><td><input type="text" name="diagnosis" maxlength="128"></td></tr>
<tr><th>Description:</th><td><input type="text" name="description" maxlength="128"></td></tr>

</table>
<input type="submit" value="Create Record">
</form>

</body>
</html>

<%

connection.close();

%>
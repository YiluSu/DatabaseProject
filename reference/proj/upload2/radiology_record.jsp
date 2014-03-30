<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>
<script type="text/javascript">
  $(document).ready(function () {
    $('#upload').toggleClass('active');
  });
</script>
<%

String record_id, query;
PreparedStatement stmt;
ResultSet rset;

record_id = (String) request.getParameter("record_id");

query = "SELECT * FROM radiology_record WHERE record_id = ?";
stmt = connection.prepareStatement(query);
stmt.setString(1, record_id);

rset = stmt.executeQuery();
if (rset.next()) {
%>

<div class="container">

<div class="form-signin">
<table>
<tr><th>Record ID: </td><td><%= rset.getString("record_id") %></tr>
<tr><th>Patient Name: </th><td><%= rset.getString("patient_name") %></tr>
<tr><th>Doctor Name: </th><td><%= rset.getString("doctor_name") %></tr>
<tr><th>Radiologist Name: </th><td><%= rset.getString("radiologist_name") %></tr>
<tr><th>Test Type: </th><td><%= rset.getString("test_type") %></tr>
<tr><th>Prescribing Date: </th><td><%= rset.getString("prescribing_date") %></tr>
<tr><th>Test Date: </th><td><%= rset.getString("test_date") %></tr>
<tr><th>Diagnosis: </th><td><%= rset.getString("diagnosis") %></tr>
<tr><th>Description: </th><td><%= rset.getString("description") %></tr>
</table>
<%
}
%>

<h2>Images</h2>

<%
query = "SELECT image_id FROM pacs_images WHERE record_id = ?";
stmt = connection.prepareStatement(query);
stmt.setString(1, record_id);

rset = stmt.executeQuery();
while (rset.next()) {
%>
  <img src="../common/image.jsp?image_id=<%= rset.getString(1) %>&size=thumbnail"> 
<%
}
%>
</div>


<form class="form-signin" action="store_image.jsp" method="post" enctype="multipart/form-data">
<h2>Add Image</h2>
<table>
<tr><th>file:</th><td><input type="file" name="file_path"></td></tr>
</table>
<input type="submit" value="Upload">
</form>

</div> <!-- container -->

</body>
</html>

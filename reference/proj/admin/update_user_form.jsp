<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/check.jsp" %>
<%

String m_class2 = (String) session.getAttribute("class");
if (!m_class2.equals("a")) {
  response.sendRedirect("../homepage/index.jsp");
}

String query, user_name;
PreparedStatement stmt;
ResultSet rset;

user_name = request.getParameter("user_name");

query = "SELECT count(*) FROM persons WHERE user_name = ?";
stmt = connection.prepareStatement(query);
stmt.setString(1, user_name);
rset = stmt.executeQuery();

rset.next(); // get the first record
if (rset.getString(1).equals("0")) {
  response.sendRedirect("user_not_found.html");
}

query = "SELECT * FROM persons WHERE user_name = ?";
stmt = connection.prepareStatement(query);
stmt.setString(1, user_name);
rset = stmt.executeQuery();
rset.next();

try {
%>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
    $('#admin').toggleClass('active');
    $('#helpLink').click(function () {
       window.open("update_user_help.html", '', 'width=500,height=600');
    });
  });
</script>

<center>
<div class="container">
<h3 class="form-signin-heading">Edit <%= user_name %>'s Profile</h3>

<form class="form-signin" method="post" action="update_user.jsp">
<table align="center" width="0%" height="25%">
<tbody>
<tr>
  <th>New Password:</th>
  <td><input name="password" maxlength="24" type="password"></td>
</tr>
<tr>
  <th>First Name:</th>
  <td><input name="first_name" type="text" maxlength="24" value="<%= rset.getString("first_name") %>"></td>
</tr>
<tr>
  <th>Last Name:</th>
  <td><input name="last_name" type="text" maxlength="24" value="<%= rset.getString("last_name") %>"></td>
</tr>
<tr>
  <th>Address:</th>
  <td><input name="address" type="text" maxlength="128" value="<%= rset.getString("address") %>"></td>
</tr>
<tr>
  <th>Email:</th>
  <td><input name="email" type="text" maxlength="128" value="<%= rset.getString("email") %>"></td>
</tr>
<tr>
  <th>Phone Number:</th>
  <td><input name="phone" maxlength="128" type="text" value="<%= rset.getString("phone") %>"></td>
</tr>
<tr align="center">
  <td colspan="3">
    <button name="rsubmit" class="btn btn-larg btn-primary" type="submit">Update Information</button>
  </td>
</tr>
</tbody>
</table>

<input type="hidden" name="user_name" value="<%= user_name %>">

</form>
<%
} catch (SQLException e) {
  // ignore exception
} finally {
  connection.close();
}
%>

</center>
</div> <!-- container -->

</body>
</html>

<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
    $('#helpLink').click(function () {
      window.open('profile_help.html', '', 'width=500,height=600');
    });
  });

  function validate() {
	if (document.forms[0].USERNAME.value=="" ) {
		alert("Please Enter the Name !");
		return false;
	} else if(document.forms[0].PASSWORD.value==""){
		alert("Please Enter the password !");
		return false;
	} else {
		return true;
        }
  }
</script>
<%

String query = "SELECT * FROM persons WHERE user_name = ?";
PreparedStatement stmt = connection.prepareStatement(query);
String user_name = (String) session.getAttribute("username");
stmt.setString(1, user_name);

ResultSet rset = stmt.executeQuery();
rset.next();

%>
<center>
<div class="container">
	<h3 class="form-signin-heading">Your Profile</h3>

	<form class="form-signin" onSubmit="return validate()" method="post" action="update_profile.jsp">
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
<button name="rsubmit" class="btn btn-larg btn-primary" type="submit">Update</button>
</td>
</tr>
</tbody>
</table>

</form>
<%
connection.close();
%>
</center>
</div>
<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>


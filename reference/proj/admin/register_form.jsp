<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>

<!--register page-->
<center>
<script>
$(document).ready(function () {
  $('#admin').toggleClass('active');
  $('#helpLink').click(function (e) {
    window.open('register_help.html', '', 'width=500,height=600');
  });
});

function validate() {
	if (document.forms[0].USERNAME.value=="" ) {
		alert("Please Enter the Name !");
		return false;
	}
	else if(document.forms[0].PASSWORD.value==""){
		alert("Please Enter the password !");
		return false;
	}
	else
		return true;
}
</script>
<div class="container">
	<h3 class="form-signin-heading">Create a New User</h3>

	<form class="form-signin" onSubmit="return validate()" method="post" action="register.jsp">
	<table align="center" width="0%" height="25%">
	<tbody>
	<tr>
		<th>User Name:</th>
		<td><input name="USERNAME" maxlength="24" type="text" ></td>
	</tr>
	<tr>
		<th>Password:</th>
		<td><input name="PASSWORD" maxlength="24" type="password"></td>
	</tr>
	<tr>
		<th>First Name:</th>
		<td><input name="FIRSTNAME" maxlength="24" type="text"></td>
	</tr>
	<tr>
		<th>Last Name:</th>
		<td><input name="LASTNAME" maxlength="24" type="text"></td>
	</tr>
	<tr>
		<th>Address:</th>
		<td><input name="ADDRESS" maxlength="128" type="text"></td>
	</tr>
	</tr>
	<tr>
		<th>Email:</th>
		<td><input name="EMAIL" maxlength="128" type="text"></td>
	</tr>
	<tr>
		<th>Phone Number:</th>
		<td><input name="PHONENUMBER" maxlength="128" type="text"></td>
	</tr>
	<TR>
		<TH>CLASS:</Th>
		<td>
		<select name="class">
			<option value ='d'>doctor</option>
			<option value ='p'>patient</option>
			<option value ='r'>radiologist</option>
			<option value ='a'>administrator</option> 
		</select>
		</td>
	</TR>

<tr align="center">
<td colspan="3">

<button name="rsubmit" class="btn btn-larg btn-primary" type="submit">Submit</button>


</td>
</tr>
</tbody>
</table>

</form>


</center>
</div>
<script src="../bootstrap/js/bootstrap.min.js"></script>
</body>
</html>


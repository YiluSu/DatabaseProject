<%@ include file="../common/check.jsp" %>
<%

String m_class2 = (String) session.getAttribute("class");
if (m_class2 == null) {
  m_class2 = "";
}

%>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
    $('#admin').toggleClass('active');
    $('#helpLink').click(function (e) {
      window.open('user_search_help.html', '', 'width=500,height=600');
    });
  });
</script>

<div class="container">

<form class="form-signin" action="update_user_form.jsp" method="post">
<h2>Find User</h2>
<table>
<tr><th>Username:</th><td><input type="text" name="user_name" maxlength="24"></td></tr>
<tr><th></th><td><button type="submit" class="btn btn-primary">Search</button></td></tr>
</table>
</form>
</div>

</body>
</html>
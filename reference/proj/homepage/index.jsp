<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
     $('#home').toggleClass('active');
     $('#helpLink').click(function (e) {
        window.open('help.html', '', 'width=500,height=600');
     });
  });
</script>

<div class="container">
    <h1>Radiological Information System</h1>
    <p>Use the links above to access the various functions.</p>
</div> <!-- /container -->

</body>
</html>

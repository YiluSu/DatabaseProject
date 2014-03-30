<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
    $(document).ready(function () {
      $('#start_date').datepicker(); // matches id="start_date"
      $('#end_date').datepicker();   // matches id="end_date"
      $('#reports').toggleClass('active');
      $('#helpLink').click(function (e) {
         window.open('form_help.html', '', 'width=500,height=600');
      });
    });
</script>

<form class="form-signin" action="generate_report.jsp" method="POST">
<table class="simple-table">
<tr><th>start date:</th><td><input type="text" id="start_date" name="start_date"></td></tr>
<tr><th>end date:</th><td><input type="text" id="end_date" name="end_date"></td></tr>
<tr><th>diagnosis:</th><td><input type="text" name="diagnosis"></td></tr>
<tr><th></th><td><button type="submit" class="btn btn-primary">Generate Report</button></td></tr>
</table>
</form>

</body>
</html>
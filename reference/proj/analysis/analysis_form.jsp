<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
  $(document).ready(function () {
    $('#start_date').datepicker(); // matches id="start_date"
    $('#end_date').datepicker();   // matches id="end_date"
    $('#analysis').toggleClass('active');
    $('#helpLink').click(function (e) {
        window.open('form_help.html', '', 'width=500,height=600');
     });
  });
</script>

<form class="form-signin" action="generate_analysis.jsp" method="POST">
<table>
<tr>
  <th>Start Date:</th>
  <td><input type="text" id="start_date" name="start_date"></td>
</tr>
<tr>
  <th>End Date:</th>
  <td><input type="text" id="end_date" name="end_date"></td>
</tr>
<tr>
  <th>Time period:</th>
  <td style='padding-bottom:10px;'>
     <input type="radio" name="time_period" value=""> All &nbsp; 
     <input type="radio" name="time_period" value="daily"> Daily &nbsp; 
     <input type="radio" name="time_period" value="monthly"> Monthly &nbsp; 
     <input type="radio" name="time_period" value="yearly"> Yearly &nbsp; 
  </td>
</tr>
<tr>
  <th>User class:</th>
  <td style='padding-bottom:10px;'>
     <input type="radio" name="user_class" value=""> All users &nbsp; 
     <input type="radio" name="user_class" value="doctor_name"> Doctor &nbsp; 
     <input type="radio" name="user_class" value="patient_name"> Patient &nbsp; 
     <input type="radio" name="user_class" value="radiologist_name"> Radiologist &nbsp; 
  </td>
</tr>
<tr>
  <th>Count:</th>
  <td style='padding-bottom:10px;'>
    <input type="radio" name="count" value="pacs_images"> Images &nbsp; 
    <input type="radio" name="count" value="radiology_record"> Radiology Records &nbsp; 
  </td>
</tr>
<tr>
  <th></th>
  <td><button type="submit" class="btn btn-primary">Analyze</button></td>
</tr>
</table>
</form>

</body>
</html>
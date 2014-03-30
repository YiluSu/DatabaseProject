<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%@ include file="../common/header.jsp" %>
<script type="text/javascript">
  $(document).ready(function () {
    $('#analysis').toggleClass('active');
    $('#helpLink').click(function () {
      window.open('results_help.html', '', 'width=500,height=600');
    });
  });
</script>

<h2>Parameters</h2>
<table>
<tr><th>start date:</th><td><%= request.getParameter("start_date") %></td></tr>
<tr><th>end date:</th><td><%= request.getParameter("end_date") %></td></tr>
<tr><th>time period:</th><td><%= request.getParameter("time_period") %></td></tr>
<tr><th>user class:</td><td><%= request.getParameter("user_class") %></td></tr>
<tr><th>count</td><td><%= request.getParameter("count") %></td></tr>
</table>

<%
int col_count = 2;  // initial 2 because we also need the date and count
ArrayList<String> columns = new ArrayList<String>();

if (!request.getParameter("user_class").equals("")) {
  columns.add(request.getParameter("user_class"));
  col_count++;  // adds a column for doctor_name, patient_name, or radiologist_name
}
columns.add("test_type");

String time_period = "";
if (request.getParameter("time_period").equals("daily")) {
   time_period = "TO_CHAR(test_date, 'dd-MM-yyyy')";
} else if (request.getParameter("time_period").equals("monthly")) {
   time_period = "TO_CHAR(test_date, 'MM-yyyy')";
} else if (request.getParameter("time_period").equals("yearly")) {
   time_period = "TO_CHAR(test_date, 'yyyy')";
} 

if (!time_period.equals("")) {
   columns.add(time_period);
   col_count++;  // adds a column for either day, month, or year
}

StringBuffer sb = new StringBuffer();
String delim = "";
for (String col : columns) {
    sb.append(delim).append(col);
    delim = ",";
}

String select = "SELECT count(*) as num, " + sb + " ";
String from = "FROM radiology_record ";
String where = "";
String group = "GROUP BY CUBE(" + sb + ") ";
String order = "ORDER BY " + sb;

if (request.getParameter("count").equals("pacs_images")) {
  from = "FROM radiology_record, pacs_images ";
  where = "WHERE radiology_record.record_id = pacs_images.record_id ";
}

String query = select + from + where + group + order;
PreparedStatement statement = connection.prepareStatement(query);
ResultSet rs = statement.executeQuery();

SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");

%>

<h2>Results</h2>
<table class="table">
<tr><th>Number</th>
<%

if (!time_period.equals("")) {
  columns.set(columns.size()-1, "Date");
}

for (String col : columns) {
%>
<th><%= col %></th>
<%
}
%>
</tr>
<%

while (rs.next()) {
   out.println("<tr>");
   for (int i = 1; i <= col_count; i++) {
      String value = rs.getString(i);
      if (value == null) {
         value = "";
      }
      out.println("<td>" + value + "</td>");
   }
   out.println("</tr>");
}

connection.close();
%>

</body>
</html>

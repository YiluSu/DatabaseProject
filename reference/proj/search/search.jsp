<%/*
 *  File name:  search.jsp
 *  Function:   allows the user to search through the database for all records they have permission to view as defined by their user class, thumbnails are displayed 
 *              for all records and it links to larger images if clicked on. 
 *  Author:     Joseph Burr, with help from code provided in the examples posted on the class website for searching and displaying images
 */
%>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>

<script type="text/javascript">
   $(document).ready(function () {
      $('#start_period').datepicker(); 
      $('#end_period').datepicker();   
      $('#search').toggleClass('active');
      $('#helpLink').click(function (e) {
        window.open('help.html', '', 'width=500,height=600');
      });
   });
</script>

      <h1>Search</h1>
        <form action="search.jsp" method="POST">
          Search: <input type="text" name="search" placeholder="Search..."><br>
          Start Period: <input type="text" id="start_period" name="start_period"><br>
          End Period: <input type="text" id="end_period" name="end_period"><br>
	  Rank by: <br>
	  <input type="radio" name="rank" value="old_to_new">Most Recent Last<br>
	  <input type="radio" name="rank" value="new_to_old">Most Recent First<br>
	  Default ranking is by frequency of keyword.<br>
          <input type="submit" value="Search" name="search">
        </form>

	<%

	String addSearchError = "";

/* Query substrings */
	String query_RANK_select = "SELECT (6*SCORE(1) + 6*SCORE(2) + 3*SCORE(3) + SCORE(4)) AS Rank, rr.record_id, p1.first_name, p1.last_name, p2.first_name, p2.last_name, p3.first_name, p3.last_name, rr.test_type, rr.prescribing_date, rr.test_date, rr.diagnosis, rr.description, pi.image_id FROM ";
	String query_select = "SELECT rr.record_id, p1.first_name, p1.last_name, p2.first_name, p2.last_name, p3.first_name, p3.last_name, rr.test_type, rr.prescribing_date, rr.test_date, rr.diagnosis, rr.description, pi.image_id FROM ";

	String user_perm = "";
	String patient_perm = "(SELECT * FROM radiology_record WHERE patient_name = ?) ";
	String doctor_perm = "(SELECT * FROM radiology_record WHERE doctor_name = ?) ";
	String radiol_perm = "(SELECT * FROM radiology_record WHERE radiologist_name = ?) ";
	String admin_perm = "radiology_record ";

	String query_joins = "rr JOIN pacs_images pi ON rr.record_id = pi.record_id JOIN users u1 ON rr.patient_name = u1.user_name JOIN users u2 ON rr.doctor_name = u2.user_name JOIN users u3 ON rr.radiologist_name = u3.user_name JOIN persons p1 ON u1.user_name = p1.user_name JOIN persons p2 ON u2.user_name = p2.user_name JOIN persons p3 ON u3.user_name = p3.user_name ";
	String query_contains = "WHERE ( CONTAINS ( p1.first_name, ?, 1 ) > 0 OR CONTAINS ( p1.last_name, ?, 2 ) > 0 OR CONTAINS ( rr.diagnosis, ?, 3 ) > 0 OR CONTAINS ( rr.description, ?, 4 ) > 0 ) ";
	String query_dates = "WHERE rr.test_date BETWEEN to_date(?,'YYYY-MM-DD') AND to_date(?,'YYYY-MM-DD') ";
	String query_AND_dates = "AND rr.test_date BETWEEN to_date(?,'YYYY-MM-DD') AND to_date(?,'YYYY-MM-DD') ";

	String query_DEF_order = "ORDER BY Rank DESC";
	String query_oldfirst = "ORDER BY rr.test_date ASC";
	String query_oldlast = "ORDER BY rr.test_date DESC";
	String query_orderby_id = "ORDER BY rr.record_id ASC";

/* user atttributes */
	String user_class = (String) session.getAttribute("class");
	String login_name = (String) session.getAttribute("username");

	String start_date = "";
	String end_date = "";
	String s_query = "";

	PreparedStatement doSearch;
	Statement stmt;
	ResultSet rset;
	Connection conn;

/* open connection to database */	
	try
	{
		String m_url = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		String m_driverName = "oracle.jdbc.driver.OracleDriver";

		String filePath = application.getRealPath("/") + "admininformation.txt";
		BufferedReader bf = new BufferedReader(new FileReader(filePath));
		String m_userName = bf.readLine().trim();
		String m_password = bf.readLine().trim();

		Class drvClass = Class.forName(m_driverName);
		DriverManager.registerDriver((Driver)
		drvClass.newInstance());
				      
		conn = DriverManager.getConnection(m_url, m_userName, m_password);
        }
	catch (SQLException e)
	{
		out.print("Error displaying data: ");
		out.println(e.getMessage());
		return;
	}
	

/* check if form has been submitted if it has do rest */
	
	if(request.getParameter("search") != null)
	{

/* User has entered asearch keyword and both dates*/

		if(!(request.getParameter("search").equals("")) && !(request.getParameter("start_period").equals("")) && !(request.getParameter("end_period").equals("")))
		{
/* convert dates to proper form for database */

			java.util.Date old_start_date = new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("start_period"));
			java.util.Date old_end_date = new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("end_period"));
	
			start_date = new SimpleDateFormat("yyyy-MM-dd").format(old_start_date);
			end_date = new SimpleDateFormat("yyyy-MM-dd").format(old_end_date);	

/* if user is admin construct query with all records allowable */

			if(user_class.equals("a"))
			{
				if(request.getParameter("rank") == null)
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_AND_dates + query_DEF_order;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_AND_dates + query_oldfirst;
				}				
				else
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_AND_dates + query_oldlast;
				}

				doSearch = conn.prepareStatement(s_query);
			
				doSearch.setString(1, request.getParameter("search"));
				doSearch.setString(2, request.getParameter("search"));
				doSearch.setString(3, request.getParameter("search"));
				doSearch.setString(4, request.getParameter("search"));
				doSearch.setString(5, start_date);
				doSearch.setString(6, end_date);

			}
			else
			{	
/* if user is not admin then select rows for records they have access to */

				if(user_class.equals("p"))
				{
					user_perm = patient_perm;
				}
				if(user_class.equals("d"))
				{
					user_perm = doctor_perm;
				}
				if(user_class.equals("r"))
				{
					user_perm = radiol_perm;
				}
				if(request.getParameter("rank") == null)
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_AND_dates + query_DEF_order;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_AND_dates + query_oldfirst;
				}				
				else
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_AND_dates + query_oldlast;
				}


		   		doSearch = conn.prepareStatement(s_query);
				
				doSearch.setString(1, login_name);
				doSearch.setString(2, request.getParameter("search"));
				doSearch.setString(3, request.getParameter("search"));
				doSearch.setString(4, request.getParameter("search"));
				doSearch.setString(5, request.getParameter("search"));
				doSearch.setString(6, start_date);
				doSearch.setString(7, end_date);

			}

/* execute query and print out rows */

			rset = doSearch.executeQuery();
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th rowspan=2>Rank</th>");
			out.println("<th rowspan=2>Record ID</th>");
			out.println("<th colspan=2>Patient Name</th>");
			out.println("<th colspan=2>Doctor Name</th>");
			out.println("<th colspan=2>Radiologist Name</th>");
			out.println("<th rowspan=2>Test Type</th>");
			out.println("<th rowspan=2>Prescribing Date</th>");
			out.println("<th rowspan=2>Test Date</th>");
			out.println("<th rowspan=2>Diagnosis</th>");
			out.println("<th rowspan=2>Description</th>");
			out.println("<th rowspan=2>Image ID</th>");
			out.println("<th rowspan=2>Thumbnail</th>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("</tr>");
			while(rset.next())
			{
			        out.println("<tr>");
   			        for (int i = 1; i <= 14; i++) {  
%>
					<td><%= rset.getString(i) %></td>
<%
				}
/* display image and link for regular sized image */
%>
				<td>

				<img src="../common/image.jsp?image_id=<%= rset.getInt(14) %>&record_id=<%= rset.getInt(2) %>&size=thumbnail" 
				     	     onclick="window.open('../search/GetRegPic.jsp?image_id=<%= rset.getInt(14) %>&record_id=<%= rset.getInt(2) %>', '', 'width=800,height=600');">
				</td>					     							 
				</tr>
<%
			}
			out.println("</table>");

		}
/* User has entered a search keyword but no dates */

		if(!(request.getParameter("search").equals("")) && (request.getParameter("start_period").equals("")) && (request.getParameter("end_period").equals("")))
		{

/* if user is admin construct query with all records allowable */

			if(user_class.equals("a"))
			{
				if(request.getParameter("rank") == null)
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_DEF_order;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_oldfirst;
				}				
				else
				{
					s_query = query_RANK_select + admin_perm + query_joins + query_contains + query_oldlast;
				}

				doSearch = conn.prepareStatement(s_query);
			
				doSearch.setString(1, request.getParameter("search"));
				doSearch.setString(2, request.getParameter("search"));
				doSearch.setString(3, request.getParameter("search"));
				doSearch.setString(4, request.getParameter("search"));

			}
			else
			{
/* if user is not admin then select rows for records they have access to */

				if(user_class.equals("p"))
				{
					user_perm = patient_perm;
				}
				if(user_class.equals("d"))
				{
					user_perm = doctor_perm;
				}
				if(user_class.equals("r"))
				{
					user_perm = radiol_perm;
				}

				if(request.getParameter("rank") == null)
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_DEF_order;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_oldfirst;
				}				
				else
				{
					s_query = query_RANK_select + user_perm + query_joins + query_contains + query_oldlast;
				}


		   		doSearch = conn.prepareStatement(s_query);
				
				doSearch.setString(1, login_name);
				doSearch.setString(2, request.getParameter("search"));
				doSearch.setString(3, request.getParameter("search"));
				doSearch.setString(4, request.getParameter("search"));
				doSearch.setString(5, request.getParameter("search"));

			}

/* execute query and print out rows */

			rset = doSearch.executeQuery();
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th rowspan=2>Rank</th>");
			out.println("<th rowspan=2>Record ID</th>");
			out.println("<th colspan=2>Patient Name</th>");
			out.println("<th colspan=2>Doctor Name</th>");
			out.println("<th colspan=2>Radiologist Name</th>");
			out.println("<th rowspan=2>Test Type</th>");
			out.println("<th rowspan=2>Prescribing Date</th>");
			out.println("<th rowspan=2>Test Date</th>");
			out.println("<th rowspan=2>Diagnosis</th>");
			out.println("<th rowspan=2>Description</th>");
			out.println("<th rowspan=2>Image ID</th>");
			out.println("<th rowspan=2>Thumbnail</th>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("</tr>");
			while(rset.next())
			{
			        out.println("<tr>");
   			        for (int i = 1; i <= 14; i++) {  
%>
					<td><%= rset.getString(i) %></td>
<%
				}
/* display image and link for regular sized image */
%>
				<td>

				<img src="../common/image.jsp?image_id=<%= rset.getInt(14) %>&record_id=<%= rset.getInt(2) %>&size=thumbnail" 
				     	     onclick="window.open('../search/GetRegPic.jsp?image_id=<%= rset.getInt(14) %>&record_id=<%= rset.getInt(2) %>', '', 'width=800,height=600');">
				</td>					     							 
				</tr>
<%
			}
			out.println("</table>");

		}

/* user has enter both dates by no search keyword */

		if((request.getParameter("search").equals("")) && !(request.getParameter("start_period").equals("")) && !(request.getParameter("end_period").equals("")))
		{

/* convert dates to proper form for database */

			java.util.Date old_start_date = new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("start_period"));
			java.util.Date old_end_date = new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("end_period"));
	
			start_date = new SimpleDateFormat("yyyy-MM-dd").format(old_start_date);
			end_date = new SimpleDateFormat("yyyy-MM-dd").format(old_end_date);	

/* if user is admin construct query with all records allowable */

			if(user_class.equals("a"))
			{
				if(request.getParameter("rank") == null)
				{
					s_query = query_select + admin_perm + query_joins + query_dates + query_orderby_id;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_select + admin_perm + query_joins + query_dates + query_oldfirst;
				}				
				else
				{
					s_query = query_select + admin_perm + query_joins + query_dates + query_oldlast;
				}

				doSearch = conn.prepareStatement(s_query);
			
				doSearch.setString(1, start_date);
				doSearch.setString(2, end_date);

			}
			else
			{
/* if user is not admin then select rows for records they have access to */

				if(user_class.equals("p"))
				{
					user_perm = patient_perm;
				}
				if(user_class.equals("d"))
				{
					user_perm = doctor_perm;
				}
				if(user_class.equals("r"))
				{
					user_perm = radiol_perm;
				}

				if(request.getParameter("rank") == null)
				{
					s_query = query_select + user_perm + query_joins + query_dates + query_orderby_id;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_select + user_perm + query_joins + query_dates + query_oldfirst;
				}				
				else
				{
					s_query = query_select + user_perm + query_joins + query_dates + query_oldlast;
				}


		   		doSearch = conn.prepareStatement(s_query);
				
				doSearch.setString(1, login_name);
				doSearch.setString(2, start_date);
				doSearch.setString(3, end_date);

			}

/* execute query and print out rows */

			rset = doSearch.executeQuery();
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th rowspan=2>Record ID</th>");
			out.println("<th colspan=2>Patient Name</th>");
			out.println("<th colspan=2>Doctor Name</th>");
			out.println("<th colspan=2>Radiologist Name</th>");
			out.println("<th rowspan=2>Test Type</th>");
			out.println("<th rowspan=2>Prescribing Date</th>");
			out.println("<th rowspan=2>Test Date</th>");
			out.println("<th rowspan=2>Diagnosis</th>");
			out.println("<th rowspan=2>Description</th>");
			out.println("<th rowspan=2>Image ID</th>");
			out.println("<th rowspan=2>Thumbnail</th>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("</tr>");
			while(rset.next())
			{
			        out.println("<tr>");
   			        for (int i = 1; i <= 13; i++) {  
%>
					<td><%= rset.getString(i) %></td>
<%
				}
/* display image and link for regular sized image */
%>
				<td>

				<img src="../common/image.jsp?image_id=<%= rset.getInt(13) %>&record_id=<%= rset.getInt(1) %>&size=thumbnail" 
				     	     onclick="window.open('../search/GetRegPic.jsp?image_id=<%= rset.getInt(13) %>&record_id=<%= rset.getInt(1) %>', '', 'width=800,height=600');">
				</td>					     							 
				</tr>
<%
			}
			out.println("</table>");

		}
/* user has enter no values - default search of all accessible records */

		if((request.getParameter("search").equals("")) && (request.getParameter("start_period").equals("")) && (request.getParameter("end_period").equals("")))
		{
/* if admin select all possible records */

			if(user_class.equals("a"))
			{
				if(request.getParameter("rank") == null)
				{
					s_query = query_select + admin_perm + query_joins + query_orderby_id;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_select + admin_perm + query_joins + query_oldfirst;
				}				
				else
				{
					s_query = query_select + admin_perm + query_joins + query_oldlast;
				}

				stmt = conn.createStatement();
				rset = stmt.executeQuery(s_query);
			}
			else
			{
/* if not admin restrict access to allowable records */

				if(user_class.equals("p"))
				{
					user_perm = patient_perm;
				}
				if(user_class.equals("d"))
				{
					user_perm = doctor_perm;
				}
				if(user_class.equals("r"))
				{
					user_perm = radiol_perm;
				}

				if(request.getParameter("rank") == null)
				{
					s_query = query_select + user_perm + query_joins + query_orderby_id;
				}
				else if(request.getParameter("rank").equals("old_to_new"))
				{
					s_query = query_select + user_perm + query_joins + query_oldfirst;
				}				
				else
				{
					s_query = query_select + user_perm + query_joins + query_oldlast;
				}

		   		doSearch = conn.prepareStatement(s_query);

				doSearch.setString(1, login_name);

				rset = doSearch.executeQuery();

			}

/* print out result table */			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th rowspan=2>Record ID</th>");
			out.println("<th colspan=2>Patient Name</th>");
			out.println("<th colspan=2>Doctor Name</th>");
			out.println("<th colspan=2>Radiologist Name</th>");
			out.println("<th rowspan=2>Test Type</th>");
			out.println("<th rowspan=2>Prescribing Date</th>");
			out.println("<th rowspan=2>Test Date</th>");
			out.println("<th rowspan=2>Diagnosis</th>");
			out.println("<th rowspan=2>Description</th>");
			out.println("<th rowspan=2>Image ID</th>");
			out.println("<th rowspan=2>Thumbnail</th>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("<th>First</th>");
			out.println("<th>Last</th>");
			out.println("</tr>");
			while(rset.next())
			{
			        out.println("<tr>");
   			        for (int i = 1; i <= 13; i++) {  
%>
					<td><%= rset.getString(i) %></td>
<%
				}
/* display image and link for regular sized image */
%>
				<td>

				<img src="../common/image.jsp?image_id=<%= rset.getInt(13) %>&record_id=<%= rset.getInt(1) %>&size=thumbnail" 
				     	     onclick="window.open('../search/GetRegPic.jsp?image_id=<%= rset.getInt(13) %>&record_id=<%= rset.getInt(1) %>', '', 'width=800,height=600');">
				</td>					     							 
				</tr>
<%
			}
			out.println("</table>");

		}
		else
		{

			addSearchError = "Insufficient search data. Please see help for more information.\n";
		}

	}

/* close connection to database */
	conn.close();

	%>

    </body>
</html>

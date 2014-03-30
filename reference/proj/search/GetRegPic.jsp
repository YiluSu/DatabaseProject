<html>
	<body>
<%
/* get required id for image display */

		String pic_id = request.getParameter("image_id");
		String rec_id = request.getParameter("record_id");
	
%>
	
		<a href="../common/image.jsp?image_id=<%= pic_id %>&record_id=<%= rec_id %>&size=large_size" target="_self">
		<img src="../common/image.jsp?image_id=<%= pic_id %>&record_id=<%= rec_id %>&size=regular_size"> </a>
	

	</body>
</html>

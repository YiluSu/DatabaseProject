<%@ include file="../common/check.jsp" %>
<%@ include file="../common/header.jsp" %>
<% String username = (String) session.getAttribute("username"); %>
<script>
$(document).ready(function () {
  $('#helpLink').click(function (e) {
    window.open('help.html', '', 'width=500,height=600');
  });
});
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>File Upload Success/Failure</TITLE>

</HEAD>
<body bgcolor="#eeeeee" text="#765500">
<center>
<%@ page import="java.sql.*" %>
<%@ page import="java.awt.Image" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.*" %>
<%@ page import= "java.util.* "%>
<%@ page import= "java.lang.System.* "%>
<%@	page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="javax.imageio.stream.ImageOutputStream;" %>
<%
	////enctype="multipart/form-data"		
	if(request.getParameter("bSubmit") != null)
	{	
	    
		File f = new File(request.getSession().getServletContext().getRealPath("/admininformation.txt"));

		BufferedReader bf = new BufferedReader(new FileReader(f));
		String sql_user = (bf.readLine()).trim();
		String sql_key = (bf.readLine()).trim();
		Connection conn = null;
	    String driverName = "oracle.jdbc.driver.OracleDriver";
	    String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";	
	    bf.close();
	    try{
	        //load and register the driver
			Class drvClass = Class.forName(driverName); 
	    	DriverManager.registerDriver((Driver) drvClass.newInstance());
		}
	    catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");	
	    }	
		try{
	    	//establish the connection
	       	conn = DriverManager.getConnection(dbstring,sql_user,sql_key);
			conn.setAutoCommit(false);
	    }
		catch(Exception ex){	    
	        out.println("<hr>" + ex.getMessage() + "<hr>");
		}	
		//set some parameters
		int record_id = 1;
		int image_id = 1;
		//get the input from ImgUpload
		String doctor_name = (String)session.getAttribute("doctor");
		String patient_name = (String)session.getAttribute("patient"); 
		String test_type = (String)session.getAttribute("test_type"); 
		String prescribing_date = (String)session.getAttribute("prescribing_date");
		String test_date = (String)session.getAttribute("test_date"); 
		String diagnosis = (String)session.getAttribute("diagnosis");
		String description = (String)session.getAttribute("description");
		
		//out.println("ERROR----LINE-----------"+doctor_name+"--------"+patient_name+"-----"+test_type+"---------"+prescribing_date+"-------"+test_date+"-----"+diagnosis+"-----"+description);
    	String path = (request.getSession().getServletContext().getRealPath("/image_temp")).trim();
		File folder = new File(path);
		File[] fList = folder.listFiles();

		
		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
				ResultSet.CONCUR_READ_ONLY);
		Statement stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
				ResultSet.CONCUR_READ_ONLY);
		Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, 
				ResultSet.CONCUR_READ_ONLY);
		InputStream fis = null;
		InputStream fis_th = null;
		InputStream fis_fu = null;
		InputStream fis_re = null;
	  
			int j = 0;
			PreparedStatement pstmt = null;
			PreparedStatement pstmt2 = null;
			ResultSet rset = null;
			ResultSet rset1 = null;
			ResultSet rset2 = null;
			rset = stmt.executeQuery("select record_id from radiology_record order by record_id");
		   	if (rset.next()) {
		   		rset.last();
	            record_id = rset.getInt(1)+1;
	            
		   	}
		   	
		   	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
			java.util.Date new_prescribing_date = format.parse(prescribing_date);
			java.util.Date new_test_date = format.parse(test_date);
		   	pstmt2 = conn.prepareStatement("insert into radiology_record (record_id,patient_name,doctor_name,radiologist_name,test_type,prescribing_date,test_date,diagnosis,description) values("+record_id+",'"+patient_name+"','"+doctor_name+"','"+username+"','"+test_type+"',?,?,'"+diagnosis+"','"+description+"')");
		   	pstmt2.setDate(1, new java.sql.Date(new_prescribing_date.getTime()));
		   	pstmt2.setDate(2, new java.sql.Date(new_test_date.getTime()));
		   	pstmt2.executeUpdate();
		   	conn.commit();
		   	pstmt2.close();
		   	out.println("<center><h1>Record Successful! </h1></center>");
			try { 						//get images' name from the folder image_temp
		   	for (j = 0; j < fList.length; j++) {
				File file = fList[j];				
				String filename = file.getName();
				fis = (InputStream) new FileInputStream(file);
				fis_fu = (InputStream) new FileInputStream(file);
				BufferedImage img = ImageIO.read(fis);
				//int n1 = img.getWidth() / 25;
				//int n2 = img.getHeight() / 10;
				int n = 10 ;
				int w = img.getWidth() / n;
				int h = img.getHeight() / n;
				int w_re = img.getWidth() / 5;
				int h_re = img.getHeight() / 5;
				BufferedImage thumbnailImg = new BufferedImage(w, h, img.getType());
				for (int y = 0; y < h; ++y) {
				  for (int x = 0; x < w; ++x) {
				     thumbnailImg.setRGB(x, y, img.getRGB(x*n, y*n));
				  }
				}
				ByteArrayOutputStream bs = new ByteArrayOutputStream();
				ByteArrayOutputStream bs2 = new ByteArrayOutputStream();
				ImageIO.write(thumbnailImg,"jpg",bs);
				fis_th = new ByteArrayInputStream(bs.toByteArray());
				BufferedImage regularImg = new BufferedImage(w_re,h_re,img.getType());
				for (int y = 0; y < h_re; ++y) {
					  for (int x = 0; x < w_re; ++x) {
						  regularImg.setRGB(x, y, img.getRGB(x*5, y*5));
					  }
					}
				ImageIO.write(regularImg,"jpg",bs2);
				fis_re = new ByteArrayInputStream(bs2.toByteArray());
				fis.close();
		
				
				rset2 = stmt2.executeQuery("select image_id from pacs_images order by image_id");
			   	if (rset2.next()) {
			   		rset2.last();
		            image_id = rset2.getInt(1)+1;
			   	}
				try{
			        pstmt = conn.prepareStatement("insert into pacs_images (record_id,image_id,thumbnail,regular_size,full_size) values ("+record_id+","+image_id+",?,?,?)");
			      	pstmt.setBinaryStream(1,fis_th,fis_th.available()); //convert image to binary
			        pstmt.setBinaryStream(2,fis_re,fis_re.available()); //convert image to binary
			        pstmt.setBinaryStream(3,fis_fu,fis_fu.available()); //convert image to binary
			        pstmt.executeUpdate();
					conn.commit();
					pstmt.close();
					fis_fu.close();
					fis_th.close();
					fis_re.close();
					
				}
			
				
			    catch(Exception ex){
			        out.println("<hr>" + ex.getMessage() + "<hr>");
				}
				
			}

		   	String images_count = "";
		   	if (j<2){
		   		images_count = j+" image ";
		   	}
		   	else{
		   		images_count = j+" images ";
		   	}
		
		   	out.println("<center><h1>Upload "+images_count+"Successful! </h1></center>");
		  
		   
			rset.close();
			rset2.close();
			stmt.close();
			stmt1.close();
			stmt2.close();
			conn.close();
			//out.println("<br>ERROR----LINE6---------------------------");
		}
		catch(Exception ex) {
			out.println("<hr>" + ex.getMessage() + "<hr>");
		}
		try {								////////////delete images from the folder image_temp
			int i = 0;
			File temp = null;
			for (i = 0; i < fList.length; i++) {
				temp = new File(path, fList[i].getName());
				
				temp.delete();
			}
		}
		catch(Exception ex) {
			 out.println("<hr>" + ex.getMessage() + "<hr>");
		}
		fList = folder.listFiles();
		
	}

%>

</center>
</body>
</html>

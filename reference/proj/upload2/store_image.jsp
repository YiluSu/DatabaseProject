<%@ include file="../common/sql.jsp" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.*" %>
<%@ page import="java.awt.Image" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="org.apache.commons.fileupload.DiskFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%

String record_id = (String) session.getAttribute("record_id");

DiskFileUpload fu = new DiskFileUpload();
List FileItems = fu.parseRequest(request);

Iterator iter = FileItems.iterator();
FileItem item = (FileItem) iter.next();
while (iter.hasNext() && item.isFormField()) {
  item = (FileItem) iter.next();
}

InputStream instream = item.getInputStream();
BufferedImage img = ImageIO.read(instream);
int n = 10;
int w = img.getWidth() / n;
int h = img.getHeight() / n;
BufferedImage thumbnailImg = new BufferedImage(w, h, img.getType());
for (int y = 0; y < h; ++y) {
  for (int x = 0; x < w; ++x) {
     thumbnailImg.setRGB(x, y, img.getRGB(x*n, y*n));
  }
}

Statement stmt = connection.createStatement();
ResultSet rs = stmt.executeQuery("SELECT image_id_seq.nextval FROM dual");
rs.next();
int image_id = rs.getInt(1);

if (record_id == null) {
   out.println("record_id = " + record_id);
} else {

String query = "INSERT INTO pacs_images VALUES (" + record_id + ", " + image_id + ", empty_blob(), empty_blob(), empty_blob())";
stmt.execute(query);

query = "SELECT * FROM pacs_images WHERE image_id = " + image_id + " FOR UPDATE";
rs = stmt.executeQuery(query);
rs.next();

BLOB thumbnailBlob = ((OracleResultSet)rs).getBLOB(3);
BLOB regularBlob = ((OracleResultSet)rs).getBLOB(4);
BLOB largeBlob = ((OracleResultSet)rs).getBLOB(5);

OutputStream outstream;

outstream = thumbnailBlob.getBinaryOutputStream();
ImageIO.write(thumbnailImg, "jpg", outstream);
outstream.close();

outstream = regularBlob.getBinaryOutputStream();
ImageIO.write(img, "jpg", outstream);
outstream.close();

outstream = largeBlob.getBinaryOutputStream();
ImageIO.write(img, "jpg", outstream);
outstream.close();

instream.close();
stmt.executeUpdate("commit");

connection.close();

response.sendRedirect("radiology_record.jsp?record_id=" + record_id);

}
%>

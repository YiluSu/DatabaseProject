<%@ include file="../common/check.jsp" %>
<%@ include file="../common/sql.jsp" %>
<%

  String[] doctor_patient = request.getParameterValues("doctor patient");
  if (doctor_patient != null) {
     for (int i = 0; i < doctor_patient.length; i++) {
       String[] parts = doctor_patient[i].split(" ");
       if (parts.length == 2) {
         String doctor = parts[0];
         String patient = parts[1];

         String query = "DELETE FROM family_doctor WHERE doctor_name = ? AND patient_name = ?";
         PreparedStatement stmt = connection.prepareStatement(query);
         stmt.setString(1, doctor);
         stmt.setString(2, patient);

         stmt.executeQuery();
       }
     }
  }

  response.sendRedirect("family_doctor_form.jsp");
%>
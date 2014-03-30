<%

  if (session.getAttribute("username") == null) {
    response.sendRedirect("/proj/login/login.html");
  }

%>
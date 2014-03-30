<%
  String m_class = (String) session.getAttribute("class");
  if (m_class == null) {
    m_class = "";
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>R.I.S.</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="stylesheet" href="../bootstrap/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="../jquery-ui/css/hot-sneaks/jquery-ui-1.10.2.custom.min.css" />
    <style>
        body {
            padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
        }
    </style>
    <link href="../bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/form.css" />
    <script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../jquery-ui/js/jquery-ui-1.10.2.custom.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstap-dropdown.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {

            $('.dropdown-toggle').dropdown();
            m_class = '<%= m_class %>';
            console.log("m_class = " + m_class);

        });

    </script>
</head>
<body>

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="brand" href="#">R.I.S.</a>
            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li id="home"><a href="../homepage/index.jsp">Home</a></li>
<%
   if (m_class.equals("a")) {
%>
                    <li id="admin" class="dropdown">
                       <a class="dropdown-toggle" data-toggle="dropdown" href="#">Admin<b class="caret"></b></a>
                       <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                           <li><a href="../admin/register_form.jsp">Add User</a></li>
                           <li><a href="../admin/user_search_form.jsp">Update User Information</a></li>
                           <li><a href="../admin/family_doctor_form.jsp">Add Doctor/Patient Relationship</a></li>
                       </ul>
                    </li>
                    <li id="reports"><a href="../report/report_form.jsp">Reports</a></li>
                    <li id="analysis"><a href="../analysis/analysis_form.jsp">Analysis</a></li>
<%
   }
   if (m_class.equals("r")) {
%>
                    <li id="upload"><a href="../upload/upload_form.jsp">Upload</a></li>
<%
   }
%>
                    <li id="search"><a href="../search/search.jsp">Search</a></li>
    		</ul>
                <ul class="nav pull-right">
		    <li><a id="helpLink" href="#">Help</a></li>
		    <li id="profile"><a href="../login/profile_form.jsp">Profile</a></li>
                    <li><a href="../login/logout.jsp">Logout</a></li>
                </ul>
            </div><!--/.nav-collapse -->
        </div>
    </div>
</div>

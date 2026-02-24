<html>
    <head>
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="admin_dash.css?v=10">
    </head>

    <body>

        <%@ page import="java.sql.*" %>
        <%
            if(session == null || session.getAttribute("role") == null 
            || !session.getAttribute("role").equals("admin")){
                response.sendRedirect("login.jsp");
                return;
            }

            String username = (String) session.getAttribute("username");
        %>

        <div id="logoutLayer">
            <a href="logout.jsp" class="logout-btn">Log Out</a>
        </div>

        <div id="page">
            <div id="container">

                <div id="header">
                    <h1>Welcome <%= username %></h1>
                    <h3>Manage Subjects</h3>
                </div>

                <div id="card">
                    <div class="subject-grid">
                        <a href="manage.jsp?subject=java" class="subject-btn">Java</a>
                        <a href="manage.jsp?subject=kotlin" class="subject-btn">Kotlin</a>
                        <a href="manage.jsp?subject=python" class="subject-btn">Python</a>
                        <a href="manage.jsp?subject=maths" class="subject-btn">Maths</a>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>
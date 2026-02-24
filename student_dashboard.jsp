<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="stud_dash.css?v=21">
</head>

    <body>

        <div class="logout-layer">
            <a href="logout.jsp" class="logout-btn">Log Out</a>
        </div>

        <div class="page">
            <div class="container">

                <%@ page import="java.sql.*" %>

                <%
                    if(session == null || session.getAttribute("role") == null 
                    || !session.getAttribute("role").equals("student")){
                        response.sendRedirect("login.jsp");
                        return;
                    }

                    String username = (String) session.getAttribute("username");
                %>

                <div class="header">
                    <h1>Welcome <%= username %></h1>
                    <h3>Available Subjects</h3>
                </div>

                <div class="card">
                    <div class="subject-grid">
                        <a href="quiz.jsp?subject=java" class="subject-btn">Java</a>
                        <a href="quiz.jsp?subject=kotlin" class="subject-btn">Kotlin</a>
                        <a href="quiz.jsp?subject=python" class="subject-btn">Python</a>
                        <a href="quiz.jsp?subject=maths" class="subject-btn">Maths</a>
                        <a href="profile.jsp" class="profile-btn">Profile</a>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>
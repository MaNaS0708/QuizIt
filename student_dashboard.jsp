<html>
    <body>

        <%@ page import="java.sql.*" %>

        <%

            if(session == null || session.getAttribute("role") == null 
            || !session.getAttribute("role").equals("student")){
                response.sendRedirect("login.jsp");
                return;
            }

            String username = (String) session.getAttribute("username");
        %>

        <h1>Welcome <%= username %></h1>

        <h2>Available Subjects:</h2>

        <table>
            <tr>
                <td><button onclick="window.location.href='quiz.jsp?subject=java'">Java</button></td>
                <td><button onclick="window.location.href='quiz.jsp?subject=kotlin'">Kotlin</button></td>
            </tr>
            <tr>
                <td><button onclick="window.location.href='quiz.jsp?subject=python'">Python</button></td>
                <td><button onclick="window.location.href='quiz.jsp?subject=maths'">Maths</button></td>
            </tr>
        </table>

        <button onclick="window.location.href='logout.jsp'">Log Out</button>

    </body>
</html>
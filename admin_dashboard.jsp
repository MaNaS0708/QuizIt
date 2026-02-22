<html>
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

        <h1>Welcome <%= username %></h1>

        <h2>Subjects:</h2>

        <table>
            <tr>
                <td><button onclick="window.location.href='java.jsp'">Manage Java</button></td>
                <td><button>Manage Kotlin</button></td>
            </tr>
            <tr>
                <td><button>Manage Python</button></td>
                <td><button>Manage Maths</button></td>
            </tr>
        </table>

        <button onclick="window.location.href='logout.jsp'">Log Out</button>

    </body>
</html>

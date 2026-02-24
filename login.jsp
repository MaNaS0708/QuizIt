<html>
    <head>
        <title>Login</title>
        <link rel="stylesheet" href="auth.css?v=1">
    </head>

    <body>

        <div id="page">
            <div id="container">

                <div id="card">
                    <h1>Login</h1>

                    <form method="post" action="login.jsp">

                        <div class="form-row">
                            <label>Username</label>
                            <input type="text" name="username" required>
                        </div>

                        <div class="form-row">
                            <label>Password</label>
                            <input type="password" name="password" required>
                        </div>

                        <div class="form-row center">
                            <input type="submit" value="Login" class="btn">
                        </div>

                        <div class="form-row center">
                            Don't have an account?
                            <a href="signup.jsp">Sign Up</a>
                        </div>

                    </form>
                </div>

            </div>
        </div>

        <%@ page import ="java.sql.*" %>
        <% 
            if(request.getMethod().equalsIgnoreCase("POST")){

                String username = request.getParameter("username");
                String password = request.getParameter("password");
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit", "root", "902440");

                if (username != null && password != null) {    
                    
                    try{
                    
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
                        ps.setString(1, username);
                        ps.setString(2, password);

                        ResultSet rs = ps.executeQuery();

                        if(rs.next()) {

                            session.setAttribute("userId", rs.getInt("user_id"));
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("role", rs.getString("role"));

                            if(rs.getString("role").equals("admin")) {
                                response.sendRedirect("admin_dashboard.jsp");
                            }
                            else {
                                response.sendRedirect("student_dashboard.jsp");
                            }
                        } 
                        else {
                            out.println("<div class='error-box'>Invalid username or password</div>");
                        }
                    }
                    catch(Exception e) {
                        out.println("<div class='error-box'>"+e.getMessage()+"</div>");
                    }
                }
            }
        %>

    </body>
</html>
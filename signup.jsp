<html>
    <head>
        <title>Sign Up</title>
        <link rel="stylesheet" href="auth.css?v=1">
    </head>

    <body>

        <div id="page">
            <div id="container">

                <div id="card">
                    <h1>Create Account</h1>

                    <form method="post" action="signup.jsp">

                        <div class="form-row">
                            <label>Username</label>
                            <input type="text" name="username" required>
                        </div>

                        <div class="form-row">
                            <label>Email</label>
                            <input type="email" name="email" required>
                        </div>

                        <div class="form-row">
                            <label>Password</label>
                            <input type="password" name="password" required>
                        </div>

                        <div class="form-row">
                            <label>Confirm Password</label>
                            <input type="password" name="confirm_password" required>
                        </div>

                        <div class="form-row">
                            <label>Role</label>
                            <select name="role">
                                <option value="student">Student</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>

                        <div class="form-row center">
                            <input type="submit" value="Sign Up" class="btn">
                        </div>

                        <div class="form-row center">
                            Already have an account?
                            <a href="login.jsp">Login</a>
                        </div>

                    </form>
                </div>

            </div>
        </div>

        <%@ page import ="java.sql.*" %>
        <%
            if(request.getMethod().equalsIgnoreCase("POST")) {

                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirm_password");
                String role = request.getParameter("role");

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit", "root", "902440");

                try{

                    if(password != null && password.equals(confirmPassword)) {

                        PreparedStatement ps = con.prepareStatement("Select * from users where username=? or email=?");
                        ps.setString(1, username);
                        ps.setString(2, email);

                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            out.println("<div class='error-box'>Account Already Exists</div>");
                        }
                        else{

                            PreparedStatement ps2 = con.prepareStatement("Insert into users (username, email, password, role) values (?, ?, ?, ?)");
                            ps2.setString(1, username);
                            ps2.setString(2, email);
                            ps2.setString(3, password);
                            ps2.setString(4, role);

                            int i = ps2.executeUpdate();

                            if (i > 0) {

                                PreparedStatement ps3 = con.prepareStatement("SELECT * FROM users WHERE username=?");
                                ps3.setString(1, username);
                                ResultSet rs2 = ps3.executeQuery();

                                if(rs2.next()){

                                    session.setAttribute("userId", rs2.getInt("user_id"));
                                    session.setAttribute("username", rs2.getString("username"));
                                    session.setAttribute("role", rs2.getString("role"));

                                    if(role.equals("admin")){
                                        response.sendRedirect("admin_dashboard.jsp");
                                    } else {
                                        response.sendRedirect("student_dashboard.jsp");
                                    }
                                }
                            }
                            else {
                                out.println("<div class='error-box'>Error creating account</div>");
                            }
                        }

                    }
                    else {
                        out.println("<div class='error-box'>Passwords do not match</div>");
                    }
                }
                catch(Exception e) {
                    out.println("<div class='error-box'>"+e.getMessage()+"</div>");
                }
            }
        %>

    </body>
</html>
<html>
    <body>
        <form method="post" action="signup.jsp">

            <table>
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="username"/></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email"/></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password"/></td>
                </tr>
                <tr>
                    <td>Confirm Password:</td>
                    <td><input type="password" name="confirm_password"/></td>
                </tr>
                <tr>
                    <td>Role:</td>
                    <td>
                        <select name="role">
                            <option value="student">Student</option>
                            <option value="admin">Admin</option>
                        </select>
                    </td>
                <tr>
                    <td colspan="2"><input type="submit" value="Sign Up"/></td>
                </tr>
                <tr>
                    <td colspan="2"> Don't have an account? <a href="login.jsp">Login</a>
                </tr>
            </table>

        </form>
    </body>

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

                if (password != null && password.equals(confirmPassword)) {

                    PreparedStatement ps = con.prepareStatement("Select * from users where username=? or email=?");
                    ps.setString(1, username);
                    ps.setString(2, email);

                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        out.println("Account Already Exist. Login to Continue..");
                    }
                    else{

                        PreparedStatement ps2 = con.prepareStatement("Insert into users (username, email, password, role) values (?, ?, ?, ?)");
                        ps2.setString(1, username);
                        ps2.setString(2, email);
                        ps2.setString(3, password);
                        ps2.setString(4, role);

                        int i = ps2.executeUpdate();

                        if (i > 0) {

                            PreparedStatement ps3 = con.prepareStatement(
                            "SELECT * FROM users WHERE username=?");
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
                            out.println("Error creating account. Please try again.");
                        }

                    }

                }
                else {
                    out.println("Passwords do not match. Please try again.");
                }
            }
            catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        }
    %>

</html>
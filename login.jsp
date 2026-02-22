    <html>
        <body>
            <form method="post" action="login.jsp">
                <table>
                    <tr>
                        <td>Username:</td>
                        <td><input type="text" name="username"/></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="password"/></td>
                    </tr>
                    <tr>
                        <td><input type="submit" value="Login"/></td>
                    </tr>
                    <tr>
                        <td>Don't have an account? <a href="signup.jsp">Sign Up</a></td>
                    </tr>
                </table>
            </form>
        </body>

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
                            out.println("Invalid username or password");
                        }
                    }
                
                    catch(Exception e) {
                        out.println("Error: " + e.getMessage());
                    }
                }
            }

        %>

    </html>
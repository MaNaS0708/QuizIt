<html>
    <body>
        <%@page import = "java.sql.*"%>
        <%

            if(session == null || session.getAttribute("role")==null 
            || !session.getAttribute("role").equals("admin")){
                response.sendRedirect("login.jsp");
                return;
            }

            int subject_id = 1;

            String username = (String) session.getAttribute("username");
        
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit", "root", "902440");

        %>
        <h1>
            Welcome <%= username %>
        </h1>
        <h3> This is Manage JAVA</h3>

        <form method="post" action="java.jsp">

            <input type = "submit" value = "Add a Question" name = "add">
            <input type = "submit" value = "Edit a Question" name = "edit">
            <input type = "submit" value = "Delete a Question" name = "delete">

        </form>

        <%

            if(request.getMethod().equalsIgnoreCase("POST")){

                String add = request.getParameter("add");
                String edit = request.getParameter("edit");
                String delete = request.getParameter("delete");

                if (add != null){

                    %>

                    <form method="post" action = "java.jsp">

                        <table>

                            <tr>
                                <td>Enter Question:</td>
                                <td><input type = "text" name = "ques" required></td>
                            </tr>
                            <tr>
                                <td>Option - A</td>
                                <td><input type = "text" name = "opt_a" required></td>
                            </tr>
                            <tr>
                                <td>Option - B</td>
                                <td><input type = "text" name = "opt_b" required></td>
                            </tr>
                            <tr>
                                <td>Option - C</td>
                                <td><input type = "text" name = "opt_c" required></td>
                            </tr>
                            <tr>
                                <td>Option - D</td>
                                <td><input type = "text" name = "opt_d" required></td>
                            </tr>
                            <tr>
                                <td>Correct - Option</td>
                                <td><input type = "text" name = "corr_opt" required></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type = "submit" value = "Add" name = "add_btn">
                                </td>
                            </tr>

                        </table>

                    </form>

                <%

                }

                String ques = request.getParameter("ques");
                String opt_a = request.getParameter("opt_a");
                String opt_b = request.getParameter("opt_b");
                String opt_c = request.getParameter("opt_c");
                String opt_d = request.getParameter("opt_d");
                String corr_opt = request.getParameter("corr_opt");
                String add_btn = request.getParameter("add_btn");

                if (add_btn != null){
                    try{

                        PreparedStatement st = con.prepareStatement("INSERT INTO questions (subject_id, question, option_a, option_b, option_c, option_d, correct_option) VALUES (?,?,?,?,?,?,?)");

                        st.setInt(1, subject_id);
                        st.setString(2, ques);
                        st.setString(3, opt_a);
                        st.setString(4, opt_b);
                        st.setString(5, opt_c);
                        st.setString(6, opt_d);
                        st.setString(7, corr_opt);

                        int r = st.executeUpdate();

                        if (r > 0){

                            out.println("<h3>Inserted</h3>");
                            
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM QUESTIONS WHERE subject_id = ? AND question = ? AND correct_option = ?");
                            ps.setInt(1, subject_id);
                            ps.setString(2, ques);
                            ps.setString(3, corr_opt);

                            ResultSet q = ps.executeQuery();

                            if (q.next()) {

                                %>

                                <h3>Inserted Question:</h3>

                                <table border = 1>
                                    <tr>
                                        <td>
                                            Question ID:
                                        </td>
                                        <td>
                                            <%= q.getInt("question_id") %>
                                        </td>
                                        <td>
                                            Subject ID:
                                        </td>
                                        <td>
                                            <%= q.getInt("subject_id") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <%= q.getString("question") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            a. <%= q.getString("option_a") %>
                                        </td>
                                        <td>
                                            b. <%= q.getString("option_b") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            c. <%= q.getString("option_c") %>
                                        </td>
                                        <td>
                                            d. <%= q.getString("option_d") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            Correct Option: <%= q.getString("correct_option") %>
                                        </td>
                                    </tr>
                                </table>

                                <%

                            }

                        }
                        else{

                            out.println("<h3>Error</h3>>");

                        }

                    }
                    catch(Exception e){

                        out.println("<h4>" + e + "</h4>");

                    }
                }

                if (edit != null) {

                    %>
                    <form method="post" action="java.jsp">

                        <table>

                            <tr>
                                <td>
                                    Enter Question Id:
                                </td>
                                <td>
                                    <input type ="text" name = "edit_q_id" required>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type = "submit" value = "submit" name = "edit_ques">
                                </td>
                            </tr>

                        </table>

                    </form>

                    <%

                }

                String edit_q_id = request.getParameter("edit_q_id");
                String edit_ques = request.getParameter("edit_ques");

                if (edit_ques != null) {

                    PreparedStatement st = con.prepareStatement("SELECT * FROM QUESTION WHERE question_id = ? AND subject_id = ?");

                    st.setInt(1, edit_q_id);
                    st.setInt(2, subject_id);

                    

                }

            }
        
        %>

    </body>
</html>
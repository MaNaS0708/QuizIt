<html>
        <head>
            <title>Manage Math Questions</title>
            <link rel="stylesheet" href="sub.css">
        </head>
    <body>

        <div class="page">
            <div class="container">

                <%@page import = "java.sql.*"%>
                <%

                    if(session == null || session.getAttribute("role")==null 
                    || !session.getAttribute("role").equals("admin")){
                        response.sendRedirect("login.jsp");
                        return;
                    }

                    int subject_id = 3;

                    String username = (String) session.getAttribute("username");

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit", "root", "902440");

                %>

                <div class="header">
                    <h1>Welcome <%= username %></h1>
                    <h3>Manage MATHS</h3>
                </div>

                <div class="card">
                    <form method="post" action="maths.jsp" class="center-form">

                        <input type="submit" value="Add a Question" name="add">
                        <input type="submit" value="Edit a Question" name="edit">
                        <input type="submit" value="Delete a Question" name="delete">

                    </form>
                </div>

                <%

                if(request.getMethod().equalsIgnoreCase("POST")){

                    String add = request.getParameter("add");
                    String edit = request.getParameter("edit");
                    String delete = request.getParameter("delete");

                    if (add != null){
                %>

                <div class="card">
                    <form method="post" action="maths.jsp" class="center-form">

                        <table>

                            <tr>
                                <td>Enter Question:</td>
                                <td><input type="text" name="ques" required></td>
                            </tr>
                            <tr>
                                <td>Option - A</td>
                                <td><input type="text" name="opt_a" required></td>
                            </tr>
                            <tr>
                                <td>Option - B</td>
                                <td><input type="text" name="opt_b" required></td>
                            </tr>
                            <tr>
                                <td>Option - C</td>
                                <td><input type="text" name="opt_c" required></td>
                            </tr>
                            <tr>
                                <td>Option - D</td>
                                <td><input type="text" name="opt_d" required></td>
                            </tr>
                            <tr>
                                <td>Correct - Option</td>
                                <td><input type="text" name="corr_opt" required></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="submit" value="Add" name="add_btn">
                                </td>
                            </tr>

                        </table>

                    </form>
                </div>

                <%
                    }

                    String add_btn = request.getParameter("add_btn");

                    if (add_btn != null){

                        String ques = request.getParameter("ques");
                        String opt_a = request.getParameter("opt_a");
                        String opt_b = request.getParameter("opt_b");
                        String opt_c = request.getParameter("opt_c");
                        String opt_d = request.getParameter("opt_d");
                        String corr_opt = request.getParameter("corr_opt");

                        try{

                            PreparedStatement st = con.prepareStatement(
                            "INSERT INTO questions (subject_id, question, option_a, option_b, option_c, option_d, correct_option) VALUES (?,?,?,?,?,?,?)");

                            st.setInt(1, subject_id);
                            st.setString(2, ques);
                            st.setString(3, opt_a);
                            st.setString(4, opt_b);
                            st.setString(5, opt_c);
                            st.setString(6, opt_d);
                            st.setString(7, corr_opt);

                            int r = st.executeUpdate();

                            if (r > 0){
                                %>

                                <div class="card">
                                    <h3>Inserted Successfully</h3>
                                </div>

                                <%
                            }

                        }catch(Exception e){
                            out.println("<div class='card'><h4>"+e+"</h4></div>");
                        }
                    }

                    if (edit != null){
                        %>

                        <div class="card">
                            <form method="post" action="maths.jsp" class="center-form">

                                <table>
                                    <tr>
                                        <td>Enter Question Id:</td>
                                        <td><input type="text" name="edit_q_id" required></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="submit" value="Submit" name="edit_ques">
                                        </td>
                                    </tr>
                                </table>

                            </form>
                        </div>

                        <%
                    }

                    String edit_q_id = request.getParameter("edit_q_id");
                    String edit_ques = request.getParameter("edit_ques");

                    if (edit_ques != null){

                        PreparedStatement st = con.prepareStatement(
                        "SELECT * FROM questions WHERE question_id = ? AND subject_id = ?");

                        st.setInt(1, Integer.parseInt(edit_q_id));
                        st.setInt(2, subject_id);

                        ResultSet rs = st.executeQuery();

                        if (rs.next()){
                            %>

                            <div class="card">
                                <form method="post" action="maths.jsp" class="center-form">

                                <input type="hidden" name="edit_q_id" value="<%= edit_q_id %>">

                                    <table>
                                        <tr>
                                            <td>Question:</td>
                                            <td><input type="text" name="question" value='<%= rs.getString("question") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>Option A:</td>
                                            <td><input type="text" name="e_opt_a" value='<%= rs.getString("option_a") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>Option B:</td>
                                            <td><input type="text" name="e_opt_b" value='<%= rs.getString("option_b") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>Option C:</td>
                                            <td><input type="text" name="e_opt_c" value='<%= rs.getString("option_c") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>Option D:</td>
                                            <td><input type="text" name="e_opt_d" value='<%= rs.getString("option_d") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>Correct Option:</td>
                                            <td><input type="text" name="e_corr_opt" value='<%= rs.getString("correct_option") %>'></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="submit" name="update_btn" value="Confirm">
                                            </td>
                                        </tr>
                                    </table>

                                </form>
                            </div>

                            <%
                        }
                    }

                    String update_btn = request.getParameter("update_btn");

                    if(update_btn != null){

                        String id = request.getParameter("edit_q_id");
                        String question = request.getParameter("question");
                        String e_opt_a = request.getParameter("e_opt_a");
                        String e_opt_b = request.getParameter("e_opt_b");
                        String e_opt_c = request.getParameter("e_opt_c");
                        String e_opt_d = request.getParameter("e_opt_d");
                        String e_corr_opt = request.getParameter("e_corr_opt");

                        try{

                            PreparedStatement up = con.prepareStatement(
                            "UPDATE questions SET question=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_option=? WHERE question_id=? AND subject_id=?");

                            up.setString(1, question);
                            up.setString(2, e_opt_a);
                            up.setString(3, e_opt_b);
                            up.setString(4, e_opt_c);
                            up.setString(5, e_opt_d);
                            up.setString(6, e_corr_opt);
                            up.setInt(7, Integer.parseInt(id));
                            up.setInt(8, subject_id);

                            int rows = up.executeUpdate();

                            if(rows > 0){
                                out.println("<div class='card'><h3>Question Updated Successfully</h3></div>");
                            }

                        }catch(Exception e){
                            out.println("<div class='card'><h4>"+e+"</h4></div>");
                        }
                    }

                    if (delete != null){
                        %>

                            <div class="card">
                                <form method="post" action="maths.jsp" class="center-form">

                                    <table>
                                        <tr>
                                            <td>Enter Question Id to Delete:</td>
                                            <td><input type="text" name="del_q_id" required></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="submit" value="Delete Question" name="delete_btn">
                                            </td>
                                        </tr>
                                    </table>

                                </form>
                        </div>

                        <%
                    }

                    String delete_btn = request.getParameter("delete_btn");

                    if(delete_btn != null){

                        String del_q_id = request.getParameter("del_q_id");

                        try{

                            PreparedStatement del = con.prepareStatement(
                            "DELETE FROM questions WHERE question_id=? AND subject_id=?");

                            del.setInt(1, Integer.parseInt(del_q_id));
                            del.setInt(2, subject_id);

                            int rows = del.executeUpdate();

                            if(rows > 0){
                                out.println("<div class='card'><h3>Question Deleted Successfully</h3></div>");
                            }

                        }catch(Exception e){
                            out.println("<div class='card'><h4>"+e+"</h4></div>");
                        }
                    }

                }
                %>

            </div>
        </div>

    </body>
</html>
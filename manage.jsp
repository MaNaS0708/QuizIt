<html>
    <head>
        <title>Manage Questions</title>
        <link rel="stylesheet" href="sub.css?v=12">
    </head>

    <body>

        <div class="back-wrap">
            <a href="admin_dashboard.jsp" class="back-btn-new">Back to Dashboard</a>
        </div>

        <div class="page">
            <div class="container">

                <%@page import="java.sql.*"%>
                <%
                    if(session == null || session.getAttribute("role")==null 
                    || !session.getAttribute("role").equals("admin")){
                        response.sendRedirect("login.jsp");
                        return;
                    }

                    String subjectName = request.getParameter("subject");
                    if(subjectName == null){
                        response.sendRedirect("admin_dashboard.jsp");
                        return;
                    }

                    String username = (String) session.getAttribute("username");

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit","root","902440");

                    PreparedStatement subSt = con.prepareStatement(
                        "select subject_id, subject_name from subjects where lower(subject_name)=?"
                    );
                    subSt.setString(1, subjectName.toLowerCase());
                    ResultSet subRs = subSt.executeQuery();

                    int subject_id = 0;
                    String properName = "";

                    if(subRs.next()){
                        subject_id = subRs.getInt("subject_id");
                        properName = subRs.getString("subject_name");
                    } else {
                        response.sendRedirect("admin_dashboard.jsp");
                        return;
                    }
                %>

                <div class="header">
                    <h1>Welcome <%= username %></h1>
                    <h3>Manage <%= properName.toUpperCase() %> Questions</h3>
                </div>

                <div class="card">
                    <form method="post" action="manage.jsp?subject=<%=subjectName%>" class="center-form">
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

                    if(add != null){
                %>

                <div class="card">
                    <form method="post" action="manage.jsp?subject=<%=subjectName%>" class="center-form">
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

                    if(add_btn != null){

                        String ques = request.getParameter("ques");
                        String opt_a = request.getParameter("opt_a");
                        String opt_b = request.getParameter("opt_b");
                        String opt_c = request.getParameter("opt_c");
                        String opt_d = request.getParameter("opt_d");
                        String corr_opt = request.getParameter("corr_opt");

                        PreparedStatement st = con.prepareStatement(
                        "insert into questions(subject_id,question,option_a,option_b,option_c,option_d,correct_option) values(?,?,?,?,?,?,?)");

                        st.setInt(1, subject_id);
                        st.setString(2, ques);
                        st.setString(3, opt_a);
                        st.setString(4, opt_b);
                        st.setString(5, opt_c);
                        st.setString(6, opt_d);
                        st.setString(7, corr_opt);

                        int r = st.executeUpdate();

                        if(r>0){
                            out.println("<div class='card'><h3>Inserted Successfully</h3></div>");
                        }
                    }

                    if(edit != null){
                %>

                <div class="card">
                    <form method="post" action="manage.jsp?subject=<%=subjectName%>" class="center-form">
                        <table>
                            <tr>
                                <td>Enter Question Id:</td>
                                <td><input type="text" name="edit_q_id" required></td>
                            </tr>
                            <tr>
                                <td><input type="submit" value="Submit" name="edit_ques"></td>
                            </tr>
                        </table>
                    </form>
                </div>

                <%
                    }

                    String edit_q_id = request.getParameter("edit_q_id");
                    String edit_ques = request.getParameter("edit_ques");

                    if(edit_ques != null){

                        PreparedStatement st = con.prepareStatement(
                        "select * from questions where question_id=? and subject_id=?");

                        st.setInt(1,Integer.parseInt(edit_q_id));
                        st.setInt(2,subject_id);

                        ResultSet rs = st.executeQuery();

                        if(rs.next()){
                %>

                <div class="card">
                    <form method="post" action="manage.jsp?subject=<%=subjectName%>" class="center-form">

                        <input type="hidden" name="edit_q_id" value="<%=edit_q_id%>">

                        <table>
                            <tr>
                                <td>Question:</td>
                                <td><input type="text" name="question" value='<%=rs.getString("question")%>'></td>
                            </tr>
                            <tr>
                                <td>Option A:</td>
                                <td><input type="text" name="e_opt_a" value='<%=rs.getString("option_a")%>'></td>
                            </tr>
                            <tr>
                                <td>Option B:</td>
                                <td><input type="text" name="e_opt_b" value='<%=rs.getString("option_b")%>'></td>
                            </tr>
                            <tr>
                                <td>Option C:</td>
                                <td><input type="text" name="e_opt_c" value='<%=rs.getString("option_c")%>'></td>
                            </tr>
                            <tr>
                                <td>Option D:</td>
                                <td><input type="text" name="e_opt_d" value='<%=rs.getString("option_d")%>'></td>
                            </tr>
                            <tr>
                                <td>Correct Option:</td>
                                <td><input type="text" name="e_corr_opt" value='<%=rs.getString("correct_option")%>'></td>
                            </tr>
                            <tr>
                                <td><input type="submit" name="update_btn" value="Confirm"></td>
                            </tr>
                        </table>
                    </form>
                </div>

                <%
                        }
                    }

                    String update_btn = request.getParameter("update_btn");

                    if(update_btn != null){

                        PreparedStatement up = con.prepareStatement(
                        "update questions set question=?,option_a=?,option_b=?,option_c=?,option_d=?,correct_option=? where question_id=? and subject_id=?");

                        up.setString(1,request.getParameter("question"));
                        up.setString(2,request.getParameter("e_opt_a"));
                        up.setString(3,request.getParameter("e_opt_b"));
                        up.setString(4,request.getParameter("e_opt_c"));
                        up.setString(5,request.getParameter("e_opt_d"));
                        up.setString(6,request.getParameter("e_corr_opt"));
                        up.setInt(7,Integer.parseInt(request.getParameter("edit_q_id")));
                        up.setInt(8,subject_id);

                        int rows = up.executeUpdate();

                        if(rows>0){
                            out.println("<div class='card'><h3>Question Updated Successfully</h3></div>");
                        }
                    }

                    if(delete != null){
                %>

                <div class="card">
                    <form method="post" action="manage.jsp?subject=<%=subjectName%>" class="center-form">
                        <table>
                            <tr>
                                <td>Enter Question Id to Delete:</td>
                                <td><input type="text" name="del_q_id" required></td>
                            </tr>
                            <tr>
                                <td><input type="submit" value="Delete Question" name="delete_btn"></td>
                            </tr>
                        </table>
                    </form>
                </div>

                <%
                    }

                    String delete_btn = request.getParameter("delete_btn");

                    if(delete_btn != null){

                        PreparedStatement del = con.prepareStatement(
                        "delete from questions where question_id=? and subject_id=?");

                        del.setInt(1,Integer.parseInt(request.getParameter("del_q_id")));
                        del.setInt(2,subject_id);

                        int rows = del.executeUpdate();

                        if(rows>0){
                            out.println("<div class='card'><h3>Question Deleted Successfully</h3></div>");
                        }
                    }

                }
                %>

            </div>
        </div>

    </body>
</html>
<html>
    <head>
        <title>Quiz</title>
        <link rel="stylesheet" href="quiz.css?v=23">
    </head>
    <body>

        <div id="logoutLayer">
            <a href="logout.jsp" class="logout-btn">Log Out</a>
        </div>

        <%
            if(session == null || session.getAttribute("role") == null 
            || !session.getAttribute("role").equals("student")){
                response.sendRedirect("login.jsp");
                return;
            }

            String subjectName = request.getParameter("subject");
            if(subjectName == null){
                response.sendRedirect("student_dashboard.jsp");
                return;
            }
        %>

        <div id="page">
            <div id="container">

                <div id="header">
                    <h1><%= subjectName.toUpperCase() %> Quiz</h1>
                </div>

                <div id="card">

                    <form action="submit_quiz.jsp" method="post">

                        <%@ page import ="java.sql.*" %>
                        <%

                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit", "root", "902440");

                            PreparedStatement ps1 = con.prepareStatement("select subject_id from subjects where subject_name=?");
                            ps1.setString(1, subjectName.substring(0,1).toUpperCase() + subjectName.substring(1));
                            ResultSet rs1 = ps1.executeQuery();

                            int subjectId = 0;

                            if(rs1.next()){
                                subjectId = rs1.getInt("subject_id");
                            }
                            else {
                                response.sendRedirect("student_dashboard.jsp");
                                return;
                            }

                            PreparedStatement ps2 = con.prepareStatement("select * from questions where subject_id=? order by rand() limit 10");
                            ps2.setInt(1, subjectId);
                            ResultSet rs = ps2.executeQuery();
                        %>

                        <input type="hidden" name="subjectId" value="<%= subjectId %>">

                        <%
                            int qno = 1;
                            while(rs.next()){
                                String correct = rs.getString("correct_option");
                                int qid = rs.getInt("question_id");
                        %>

                        <div class="question-block">
                            <h3>Q<%= qno %>. <%= rs.getString("question") %></h3>

                            <label>
                                <input type="radio" name="q<%=qno%>" value="A">
                                <%= rs.getString("option_a") %>
                            </label><br>

                            <label>
                                <input type="radio" name="q<%=qno%>" value="B">
                                <%= rs.getString("option_b") %>
                            </label><br>

                            <label>
                                <input type="radio" name="q<%=qno%>" value="C">
                                <%= rs.getString("option_c") %>
                            </label><br>

                            <label>
                                <input type="radio" name="q<%=qno%>" value="D">
                                <%= rs.getString("option_d") %>
                            </label>

                            <input type="hidden" name="ans<%=qno%>" value="<%= correct %>">
                            <input type="hidden" name="qid<%=qno%>" value="<%= qid %>">
                        </div>

                        <%
                                qno++;
                            }
                        %>

                        <input type="hidden" name="totalQ" value="<%= qno-1 %>">

                        <div id="btnLayer">
                            <button type="submit" id="submitBtn">Submit Quiz</button>
                            <a href="student_dashboard.jsp" id="backBtn">Back</a>
                        </div>

                    </form>

                </div>
            </div>
        </div>

    </body>
</html>
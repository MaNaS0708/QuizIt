<html>
    <head>
        <title>Quiz Result</title>
        <link rel="stylesheet" href="quiz.css?v=4">
    </head>

    <body>

        <div id="logoutLayer">
            <a href="logout.jsp" class="logout-btn">Log Out</a>
        </div>

        <%@ page import ="java.sql.*" %>
        <%
            if(session == null || session.getAttribute("role") == null 
            || !session.getAttribute("role").equals("student")){
                response.sendRedirect("login.jsp");
                return;
            }

            int total = Integer.parseInt(request.getParameter("totalQ"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int userId = (int) session.getAttribute("userId");

            int score = 0;
            int wrong = 0;

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit","root","902440");

            PreparedStatement ps = con.prepareStatement("insert into user_marks(user_id,subject_id,score) values(?,?,?)");

            for(int i=1;i<=total;i++){
                String userAns = request.getParameter("q"+i);
                String correctAns = request.getParameter("ans"+i);

                if(userAns != null && userAns.equals(correctAns)){
                    score++;
                }else{
                    wrong++;
                }
            }

            ps.setInt(1,userId);
            ps.setInt(2,subjectId);
            ps.setInt(3,score);
            ps.executeUpdate();

            PreparedStatement psSub = con.prepareStatement("select subject_name from subjects where subject_id=?");
            psSub.setInt(1, subjectId);
            ResultSet rsSub = psSub.executeQuery();

            String subjectName="";
            if(rsSub.next()){
                subjectName = rsSub.getString("subject_name");
            }

            PreparedStatement psQ = con.prepareStatement("select * from questions where subject_id=? order by question_id desc limit ?");
            psQ.setInt(1, subjectId);
            psQ.setInt(2, total);
            ResultSet rs = psQ.executeQuery();
        %>

        <div id="page">
            <div id="container">

                <div id="header">
                    <h1><%= subjectName %> Result</h1>
                </div>

                <div id="card">

                    <div id="scoreBox">
                        Correct : <%= score %> <br>
                        Wrong : <%= wrong %> <br>
                        Score : <%= score %> / <%= total %>
                    </div>

                    <br><br>

                    <%
                        int qno=1;
                        while(rs.next()){

                            String correct = rs.getString("correct_option");
                            String userAns = request.getParameter("q"+qno);
                    %>

                    <div class="question-block">
                        <h3>Q<%=qno%>. <%= rs.getString("question") %></h3>

                        <div class="<%= correct.equals("A") ? "correctOpt" : ( "A".equals(userAns) ? "wrongOpt" : "" ) %>">
                            A) <%= rs.getString("option_a") %>
                        </div>

                        <div class="<%= correct.equals("B") ? "correctOpt" : ( "B".equals(userAns) ? "wrongOpt" : "" ) %>">
                            B) <%= rs.getString("option_b") %>
                        </div>

                        <div class="<%= correct.equals("C") ? "correctOpt" : ( "C".equals(userAns) ? "wrongOpt" : "" ) %>">
                            C) <%= rs.getString("option_c") %>
                        </div>

                        <div class="<%= correct.equals("D") ? "correctOpt" : ( "D".equals(userAns) ? "wrongOpt" : "" ) %>">
                            D) <%= rs.getString("option_d") %>
                        </div>
                    </div>

                    <%
                        qno++;
                        }
                    %>

                    <div id="btnLayer">
                        <a href="student_dashboard.jsp" id="backBtn">Back to Dashboard</a>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>
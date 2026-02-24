<html>
    <head>
        <title>Profile</title>
        <link rel="stylesheet" href="profile.css?v=23">
    </head>

    <body>

        <div id="logoutLayer">
            <a href="logout.jsp" class="logout-btn">Log Out</a>
        </div>

        <div class="back-wrap">
            <a href="student_dashboard.jsp" class="back-btn">Back</a>
        </div>

        <%@ page import="java.sql.*" %>
        <%
            if(session == null || session.getAttribute("role") == null 
            || !session.getAttribute("role").equals("student")){
                response.sendRedirect("login.jsp");
                return;
            }

            int userId = (int) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizit","root","902440");

            PreparedStatement ps = con.prepareStatement("SELECT s.subject_name, u.score, u.attempt_date FROM user_marks u JOIN subjects s ON u.subject_id=s.subject_id WHERE user_id=? ORDER BY attempt_date DESC LIMIT 3");
            ps.setInt(1,userId);
            ResultSet last3 = ps.executeQuery();

            PreparedStatement ps2 = con.prepareStatement( "SELECT DATE(attempt_date) as d FROM user_marks WHERE user_id=? GROUP BY DATE(attempt_date) ORDER BY d DESC");
            ps2.setInt(1,userId);
            ResultSet streakRs = ps2.executeQuery();

            int streak=0;
            java.time.LocalDate prev=null;

            while(streakRs.next()){
                java.time.LocalDate current = streakRs.getDate("d").toLocalDate();
                if(prev==null){
                    streak=1;
                    prev=current;
                }else{
                    if(prev.minusDays(1).equals(current)){
                        streak++;
                        prev=current;
                    }else{
                        break;
                    }
                }
            }
        %>

        <div id="page">
            <div id="container">

                <div id="header">
                    <h1><%= username %>'s Profile</h1>
                </div>

                <div id="card">

                    <div class="section">
                        <h2>Current Streak</h2>
                        <div class="big-number"><%= streak %> Days</div>
                    </div>

                    <div class="section">
                        <h2>Last 3 Quiz Attempts</h2>

                        <table class="marks-table">
                            <tr>
                                <th>Subject</th>
                                <th>Score</th>
                                <th>Date</th>
                            </tr>

                            <%
                                while(last3.next()){
                            %>
                            <tr>
                                <td><%= last3.getString("subject_name") %></td>
                                <td><%= last3.getInt("score") %> / 10</td>
                                <td><%= last3.getDate("attempt_date") %></td>
                            </tr>
                            <%
                                }
                            %>

                        </table>
                    </div>

                </div>

            </div>
        </div>

    </body>
</html>
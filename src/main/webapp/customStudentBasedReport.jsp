<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Individual Student Attendance Report</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Index.css">
</head>
<body style="margin:0px">
<%
    String staffId = (String) session.getAttribute("staff_id");
    if (staffId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<header style="background-color: #143D60; padding: 15px; display: flex; align-items: center; justify-content: center;">
    <div style="flex: 0 0 auto; margin-right: 20px;">
        <img src="images/logo.png" alt="logo" style="height: 150px;">
    </div>
    <div style="text-align: center; color: white;">
        <h1>NIRMALA COLLEGE FOR WOMEN</h1>
        <h3>AUTONOMOUS INSTITUTION AFFILIATED TO BHARATHIAR UNIVERSITY</h3>
        <h3>ACCREDITED WITH A++ GRADE BY NAAC IN THE 4TH CYCLE WITH CGPA 3.78</h3>
        <h3>RED FIELDS, COIMBATORE - 641 018, TAMIL NADU, INDIA</h3>
    </div>
</header>
<h1 style="text-align: center; font-size:40px; color:green">Individual Student Attendance Report</h1>

<div style="display:flex; justify-content:center">
    <form method="get">
        <label style="font-size:20px" for="department">Choose Department:</label>
        <select style="padding:10px" id="department" name="dept" required>
            <option value="CSE_I">CSE - I</option>
            <option value="CSE_II">CSE - II</option>
            <option value="CSE_III">CSE - III</option>
            <option value="IT_I">IT - I</option>
            <option value="IT_II">IT - II</option>
            <option value="IT_III">IT - III</option>
        </select>

        <label style="font-size:20px" for="rollNo">Roll Number:</label>
        <input style="padding:10px" type="text" id="rollNo" name="rollNo" placeholder="Roll Number">

        <label style="font-size:20px" for="fromDate">From Date:</label>
        <input style="padding:10px" type="date" id="fromDate" name="fromDate" required>

        <label style="font-size:20px" for="toDate">To Date:</label>
        <input style="padding:10px" type="date" id="toDate" name="toDate" required>

        <button type="submit" style="padding: 10px 20px; background-color: green; color:white; font-size: 20px;">
            Fetch Report
        </button>
    </form>
</div>

<%
    String dept = request.getParameter("dept");
    String rollNo = request.getParameter("rollNo");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    if (dept != null && fromDate != null && toDate != null) {
%>
<h2 style="text-align: center;">Attendance Report for <%= dept %> from <%= fromDate %> to <%= toDate %></h2>

<div class="table_container">
    <table border="1" style="width: 80%; margin: auto; border-collapse: collapse;">
        <tr style="background-color: #4CAF50; color: white;">
            <th>DATE</th>
            <th>NAME</th>
            <th>REGISTER NUMBER</th>
            <th>1ST HOUR</th>
            <th>2ND HOUR</th>
            <th>3RD HOUR</th>
            <th>4TH HOUR</th>
            <th>5TH HOUR</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
                Calendar startDate = Calendar.getInstance();
                Calendar endDate = Calendar.getInstance();
                startDate.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(fromDate));
                endDate.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(toDate));
                boolean dataExists = false;

                while (!startDate.after(endDate)) {
                    String dateStr = sdf.format(startDate.getTime());
                    String tableName = dept + "_" + dateStr;
                    
                    try {
                        Statement stmt = connect.createStatement();
                        String query = "SELECT '" + dateStr + "' AS ATTENDANCE_DATE, NAME, REGISTER_NO, HOUR_1, HOUR_2, HOUR_3, HOUR_4, HOUR_5 FROM " + tableName;
                        if (rollNo != null && !rollNo.trim().isEmpty()) {
                            query += " WHERE REGISTER_NO = '" + rollNo + "'";
                        }
                        ResultSet rs = stmt.executeQuery(query);
                        
                        while (rs.next()) {
                            dataExists = true;
        %>
        <tr>
            <td><%= rs.getString("ATTENDANCE_DATE") %></td>
            <td><%= rs.getString("NAME") %></td>
            <td><%= rs.getString("REGISTER_NO") %></td>
            <% for (int i = 1; i <= 5; i++) { %>
                <td><%= rs.getString("HOUR_" + i) %></td>
            <% } %>
        </tr>
        <%
                        }
                        rs.close();
                        stmt.close();
                    } catch (SQLException e) {
                        // Ignore missing tables
                    }
                    startDate.add(Calendar.DATE, 1);
                }

                if (!dataExists) {
                    out.println("<tr><td colspan='8' style='text-align:center; color:red;'>No records found for the selected criteria.</td></tr>");
                }
                connect.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='8' style='text-align:center; color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</div>
<% } %>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance Report</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Index.css">
     <script>
	     function customReport(){
	     	window.location.href = "customReport.jsp";
	     }
	     
	     function customstudentBasedReport(){
	     	window.location.href = "customStudentBasedReport.jsp";
	     }
     </script>
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
    <h1 style="text-align: center;font-size:40px;color:green">Attendance Report</h1>

	<div style="display:flex;justify-content:center">
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

        <label style="font-size:20px" for="date" >Choose Date:</label>
        <input style="padding:10px" type="date" id="date" name="date" required>

        <button type="submit" style="padding: 10px 20px; background-color: green;color:white; font-size: 20px;">Fetch Report</button>
    </form>
	</div>
  

    <% 
        String dept = request.getParameter("dept");
        String selectedDate = request.getParameter("date");
        if (dept != null && selectedDate != null) {
            String tableName = dept + "_" + selectedDate.replace("-", "_"); // Example: CSE_I_2025_01_30
    %>

    <h2 style="text-align: center;">Attendance Report for <%= dept %> on <%= selectedDate %></h2>
    <div class="table_container">
    <table border="1">
    <tr>
        <th>REGISTER NUMBER</th>
        <th>NAME</th> <!-- Added Name Column -->
        <th>1ST HOUR</th>
        <th>2ND HOUR</th>
        <th>3RD HOUR</th>
        <th>4TH HOUR</th>
        <th>5TH HOUR</th>
    </tr>

    <% 
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");
             PreparedStatement preparedStatement = connect.prepareStatement("SELECT REGISTER_NO, NAME, HOUR_1, HOUR_2, HOUR_3, HOUR_4, HOUR_5 FROM " + tableName);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) { 
    %>
    <tr>
        <td><%= rs.getString("REGISTER_NO") %></td>
        <td><%= rs.getString("NAME") %></td> <!-- Display Student Name -->
        <% for (int i = 1; i <= 5; i++) { %>
            <td><%= rs.getString("HOUR_" + i) %></td>
        <% } %>
    </tr>
    <% 
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>

    </div>
    <% } %>
    <button class="reportButton" onClick="customReport()" style="padding: 10px 20px; background-color:  #EB5B00;color:white; font-size: 20px; margin-top: 40px; margin-left: 20px">Date-Wise Summary</button> <br>
	<button class="reportButton" onClick="customstudentBasedReport()" style="padding: 10px 20px; background-color:  #EB5B00;color:white; font-size: 20px;  margin-top: 20px; margin-left: 20px">Individual Student Attendance Report</button>
</body>
</html>

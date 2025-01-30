<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance Report</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Index.css">
</head>
<body>
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
            <th>1ST HOUR</th>
            <th>2ND HOUR</th>
            <th>3RD HOUR</th>
            <th>4TH HOUR</th>
            <th>5TH HOUR</th>
        </tr>

        <% 
            try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");
                 PreparedStatement preparedStatement = connect.prepareStatement("SELECT * FROM " + tableName);
                 ResultSet rs = preparedStatement.executeQuery()) {

                while (rs.next()) { 
        %>
        <tr>
            <td><%= rs.getString("REGISTER_NO") %></td>
            <% for (int i = 1; i <= 5; i++) { %>
                <td><%= rs.getString("HOUR_" + i) %></td>
            <% } %>
        </tr>
        <% 
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
    </div>
    <% } %>
</body>
</html>

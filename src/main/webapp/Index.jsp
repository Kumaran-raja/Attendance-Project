<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Index.css">
    <script>
	    function fetchAttendance() {
	        var department = document.getElementById("departmentSelect").value;
	        var xhr = new XMLHttpRequest();
	        xhr.open("POST", "createTable.jsp", true);
	        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	        xhr.onreadystatechange = function () {
	            if (xhr.readyState === 4 && xhr.status === 200) {
	                window.location.href = "Index.jsp?dept=" + xhr.responseText; 
	            }
	        };
	        xhr.send("dept=" + department);
	    }

        function saveAttendance(registerNo, hourColumn, value, dept) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "saveAttendance.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    console.log("Attendance updated successfully!");
                }
            };
            xhr.send("registerNo=" + registerNo + "&hourColumn=" + hourColumn + "&value=" + value + "&dept=" + dept);
        }
        function openReport(){
        	window.location.href = "report.jsp";
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

     <div style="margin-top: 15px">
        <select id="departmentSelect" class="chooseDepartment" onchange="fetchAttendance()">
            <option selected disabled>Choose Department</option>
            <option value="CSE_I">CSE - I</option>
            <option value="CSE_II">CSE - II</option>
            <option value="CSE_III">CSE - III</option>
            <option value="IT_I">IT - I</option>
            <option value="IT_II">IT - II</option>
            <option value="IT_III">IT - III</option>
        </select>
    </div>

    <% String dept = request.getParameter("dept"); %>

    <div class="table_container">
        <table border="1">
            <tr>
                <th>REGISTER NUMBER</th>
                <th>NAME</th>
                <th>1ST HOUR</th>
                <th>2ND HOUR</th>
                <th>3RD HOUR</th>
                <th>4TH HOUR</th>
                <th>5TH HOUR</th>
            </tr>

            <% 
                if (dept != null && dept.matches("^[A-Za-z0-9_]+$")) { 
                	try {
                	    Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL JDBC Driver
                	   
                	    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");
                	    PreparedStatement preparedStatement = connect.prepareStatement("SELECT * FROM " + dept);
                	    ResultSet rs = preparedStatement.executeQuery();
                        while (rs.next()) {
                            String registerNo = rs.getString("REGISTER_NO");
                            String name = rs.getString("NAME"); // Fetching Name from DB
            %>
            <tr>
                <td><%= registerNo %></td>
                <td><%= name %></td> <!-- Displaying Name -->
                <% for (int i = 1; i <= 5; i++) { %>
                    <td>
                        <input style="border: none;" type="text" name="hour<%= i %>_<%= registerNo %>" 
                               value="<%= rs.getString("HOUR_" + i) %>" 
                               onchange="saveAttendance('<%= registerNo %>', 'HOUR_<%= i %>', this.value, '<%= dept %>')">
                    </td>
                <% } %>
            </tr>
            <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                    }
                }
            %>
        </table>
   
    </div>
    <h1 style="margin-left: 20px">NOTE : P - Present , A - Absent</h1>
    <button class="reportButton" onClick="openReport()" style="padding: 10px 20px; background-color: #EB5B00;color:white; font-size: 20px;margin-left: 20px">report</button>
		
</body>
</html>

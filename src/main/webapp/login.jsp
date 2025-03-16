<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        .container {
            width: 300px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        input {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 95%;
            padding: 10px;
            background-color: #143D60;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0f2c4a;
        }
        .error {
            color: red;
        }
    </style>
    
</head>
<body>
    <div class="container">
        <h2>Staff Login</h2>
        <form method="post">
            <input type="text" name="staff_id" placeholder="Staff ID" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <%
            String staffId = request.getParameter("staff_id");
            String password = request.getParameter("password");

            if (staffId != null && password != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");

                    String query = "SELECT * FROM staff WHERE staff_id = ? AND password = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, staffId);
                    stmt.setString(2, password);

                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("staff_id", staffId);
                        response.sendRedirect("Index.jsp");
                    } else {
                        out.println("<p class='error'>Incorrect credentials. Try again.</p>");
                    }

                    conn.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Database Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>

<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%
    String dept = request.getParameter("dept");
    if (dept != null && dept.matches("^[A-Za-z0-9_]+$")) {
        String currentDate = new SimpleDateFormat("yyyy_MM_dd").format(new Date());
        String newTableName = dept + "_" + currentDate;
        
        try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$")) {
            
            // Create new table if it doesn't exist (now includes ATTENDANCE_DATE)
            String createTableSQL = "CREATE TABLE IF NOT EXISTS " + newTableName + " ("
                    + "REGISTER_NO VARCHAR(50) PRIMARY KEY, "
                    + "ATTENDANCE_DATE DATE NOT NULL, "
                    + "HOUR_1 VARCHAR(10), HOUR_2 VARCHAR(10), HOUR_3 VARCHAR(10), "
                    + "HOUR_4 VARCHAR(10), HOUR_5 VARCHAR(10))";
            try (PreparedStatement createTableStmt = connect.prepareStatement(createTableSQL)) {
                createTableStmt.executeUpdate();
            }

            // Copy register numbers if not already present and set ATTENDANCE_DATE as today
            String insertSQL = "INSERT IGNORE INTO " + newTableName + 
                   " (REGISTER_NO, ATTENDANCE_DATE, HOUR_1, HOUR_2, HOUR_3, HOUR_4, HOUR_5) " + 
                   "SELECT REGISTER_NO, CURDATE(), '', '', '', '', '' FROM " + dept;

            try (PreparedStatement insertStmt = connect.prepareStatement(insertSQL)) {
                insertStmt.executeUpdate();
            }

            out.print(newTableName);  // Return new table name
        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }
    }
%>

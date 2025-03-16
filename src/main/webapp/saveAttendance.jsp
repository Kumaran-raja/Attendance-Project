<%@ page import="java.sql.*, java.time.LocalDate" %>
<%
String registerNo = request.getParameter("registerNo");
String hourColumn = request.getParameter("hourColumn");
String value = request.getParameter("value").toUpperCase();
String dept = request.getParameter("dept");

// Get the current date
String attendanceDate = LocalDate.now().toString(); // Format: YYYY-MM-DD

Class.forName("com.mysql.cj.jdbc.Driver");

if (registerNo != null && hourColumn != null && value != null && dept != null) {
    try {
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$");

        // Check if attendance record exists for the current date
        String checkQuery = "SELECT * FROM " + dept + " WHERE REGISTER_NO=? AND ATTENDANCE_DATE=?";
        PreparedStatement checkStmt = connect.prepareStatement(checkQuery);
        checkStmt.setString(1, registerNo);
        checkStmt.setString(2, attendanceDate);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Update existing record for today
            String updateQuery = "UPDATE " + dept + " SET " + hourColumn + "=? WHERE REGISTER_NO=? AND ATTENDANCE_DATE=?";
            PreparedStatement updateStmt = connect.prepareStatement(updateQuery);
            updateStmt.setString(1, value);
            updateStmt.setString(2, registerNo);
            updateStmt.setString(3, attendanceDate);
            updateStmt.executeUpdate();
        } else {
            // Insert new record if not exists for today
            String insertQuery = "INSERT INTO " + dept + " (REGISTER_NO, ATTENDANCE_DATE, " + hourColumn + ") VALUES (?, ?, ?)";
            PreparedStatement insertStmt = connect.prepareStatement(insertQuery);
            insertStmt.setString(1, registerNo);
            insertStmt.setString(2, attendanceDate);
            insertStmt.setString(3, value);
            insertStmt.executeUpdate();
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>

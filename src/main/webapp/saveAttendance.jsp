<%@ page import="java.sql.*" %>
<%
String registerNo = request.getParameter("registerNo");
String hourColumn = request.getParameter("hourColumn");
String value = request.getParameter("value").toUpperCase(); 
String dept = request.getParameter("dept");

if (registerNo != null && hourColumn != null && value != null && dept != null) {
    try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/ATTENDANCE", "root", "Kumaranraja@22_02$")) {
        
        // Check if the record exists
        String checkQuery = "SELECT * FROM " + dept + " WHERE REGISTER_NO=?";
        PreparedStatement checkStmt = connect.prepareStatement(checkQuery);
        checkStmt.setString(1, registerNo);
        ResultSet rs = checkStmt.executeQuery();
        
        if (rs.next()) {
            // Update existing record
            String updateQuery = "UPDATE " + dept + " SET " + hourColumn + "=? WHERE REGISTER_NO=?";
            PreparedStatement updateStmt = connect.prepareStatement(updateQuery);
            updateStmt.setString(1, value);
            updateStmt.setString(2, registerNo);
            updateStmt.executeUpdate();
        } else {
            // Insert new record if not exists
            String insertQuery = "INSERT INTO " + dept + " (REGISTER_NO, " + hourColumn + ") VALUES (?, ?)";
            PreparedStatement insertStmt = connect.prepareStatement(insertQuery);
            insertStmt.setString(1, registerNo);
            insertStmt.setString(2, value);
            insertStmt.executeUpdate();
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
}
%>

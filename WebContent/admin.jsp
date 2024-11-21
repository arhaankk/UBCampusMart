<%@ page import="java.io.*, java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Sales Report</title>
</head>
<body>

    <h2>Administrator Sales Report by Day</h2>
    <table border="1">
        <tr>
            <th>Order Date</th>
            <th>Total Order Amount</th>
        </tr>

    <%
        // SQL query to calculate the total sales for each day
        String sql = "SELECT CONVERT(date, orderDate) AS saleDate, SUM(totalAmount) AS totalSales " +
                     "FROM ordersummary " +  // Correct table name
                     "GROUP BY CONVERT(date, orderDate) " +
                     "ORDER BY saleDate DESC";  // Sort by date descending

        try {
            getConnection();  // Open the connection
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String saleDate = rs.getString("saleDate");
                double totalSales = rs.getDouble("totalSales");
                out.println("<tr><td>" + saleDate + "</td><td>" + totalSales + "</td></tr>");
            }
        } catch (SQLException e) {
            out.println("<tr><td colspan='2'>Error fetching data: " + e.getMessage() + "</td></tr>");
        } finally {
            closeConnection();  // Close the connection
        }
    %>
    </table>

</body>
</html>

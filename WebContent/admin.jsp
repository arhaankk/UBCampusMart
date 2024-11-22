<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ include file="jdbc.jsp" %>

<%
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("authenticatedUser");
    
    // If the user is not logged in, redirect before anything is rendered
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;  // Stop further execution to avoid sending response after redirect
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Sales Report</title>

    <!-- Font Awesome CDN for the back button icon -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        h2 {
            text-align: center;
            margin-top: 20px;
            font-size: 28px;
            color: #34495e;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        table th, table td {
            padding: 12px 15px;
            text-align: center;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #3498db;
            color: #fff;
            font-size: 18px;
        }

        table tr:nth-child(even) {
            background-color: #ecf0f1;
        }

        .footer {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            background-color: #2c3e50;
            color: #ecf0f1;
            font-size: 14px;
        }

        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            font-size: 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .back-btn i {
            margin-right: 8px; /* Space between icon and text */
        }

        .back-btn:hover {
            background-color: #2980b9;
        }

        @media screen and (max-width: 768px) {
            table {
                width: 100%;
                margin: 10px 0;
            }

            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

    <!-- Back Button at the top-left corner -->
    <button class="back-btn" onclick="window.location.href='index.jsp';">
        <i class="fas fa-arrow-left"></i>Back
    </button>

    <header>
        Administrator Sales Report
    </header>

    <h2>Sales Report by Day</h2>
    
    <table>
        <tr>
            <th>Order Date</th>
            <th>Total Order Amount</th>
        </tr>

        <%
            // SQL query to calculate the total sales for each day
            String sql = "SELECT CONVERT(date, orderDate) AS saleDate, SUM(totalAmount) AS totalSales " +
                         "FROM ordersummary " +  
                         "GROUP BY CONVERT(date, orderDate) " +
                         "ORDER BY saleDate DESC";  

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
                closeConnection();  
            }
        %>
    </table>

    <div class="footer">
        &copy; 2024 UBCampusMart. All rights reserved.
    </div>

</body>
</html>

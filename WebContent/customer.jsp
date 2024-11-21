<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<!-- Font Awesome CDN for the back button icon -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
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
        position: relative;
    }

    /* Back Button Styling */
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

    h2 {
        text-align: center;
        margin-top: 20px;
        color: #34495e;
    }

    table {
        width: 70%;
        margin: 20px auto;
        border-collapse: collapse;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        background-color: #fff;
    }

    table th, table td {
        padding: 12px 15px;
        text-align: left;
        border: 1px solid #ddd;
    }

    table th {
        background-color: #3498db;
        color: #fff;
    }

    table tr:nth-child(even) {
        background-color: #ecf0f1;
    }

    table tr:hover {
        background-color: #f1f1f1;
    }

    .error-message {
        color: red;
        text-align: center;
        margin-top: 20px;
    }

    .footer {
        text-align: center;
        margin-top: 30px;
        padding: 20px;
        background-color: #2c3e50;
        color: #ecf0f1;
        font-size: 14px;
    }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<header>
    <!-- Back Button to redirect to index.jsp -->
    <button class="back-btn" onclick="window.location.href='index.jsp';">
        <i class="fas fa-arrow-left"></i>Back
    </button>
    Customer Page
</header>

<%
    // Check if the user is logged in
    String userName = (String) session.getAttribute("authenticatedUser");

    // If the user is not logged in, display an error message and stop execution
    if (userName == null) {
        out.println("<p class='error-message'>You must be logged in to access this page.</p>");
        return;
    }

    // SQL query to retrieve customer information by username (assuming username is the customer id)
    String sql = "SELECT * FROM customer WHERE userid = ?"; // Query to retrieve all customer info

    try {
        getConnection();  // Open the connection
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userName);  // Use the username from session to retrieve customer data
        ResultSet rs = ps.executeQuery();

        // Check if a customer record is found and display it
        if (rs.next()) {
            out.println("<h2>Customer Information</h2>");
            out.println("<table>");
            out.println("<tr><th>ID</th><td>" + rs.getString("customerId") + "</td></tr>");
            out.println("<tr><th>First Name</th><td>" + rs.getString("firstName") + "</td></tr>");
            out.println("<tr><th>Last Name</th><td>" + rs.getString("lastName") + "</td></tr>");
            out.println("<tr><th>Email</th><td>" + rs.getString("email") + "</td></tr>");
            out.println("<tr><th>Phone</th><td>" + rs.getString("phonenum") + "</td></tr>");
            out.println("<tr><th>Address</th><td>" + rs.getString("address") + "</td></tr>");
            out.println("<tr><th>City</th><td>" + rs.getString("city") + "</td></tr>");
            out.println("<tr><th>State</th><td>" + rs.getString("state") + "</td></tr>");
            out.println("<tr><th>Postal Code</th><td>" + rs.getString("postalCode") + "</td></tr>");
            out.println("<tr><th>Country</th><td>" + rs.getString("country") + "</td></tr>");
            out.println("<tr><th>User ID</th><td>" + rs.getString("userid") + "</td></tr>");
            out.println("</table>");
        } else {
            out.println("<p class='error-message'>No customer found with the username: " + userName + "</p>");
        }

    } catch (SQLException e) {
        out.println("<p class='error-message'>Error fetching customer data: " + e.getMessage() + "</p>");
    } finally {
        closeConnection();  // Close the database connection
    }
%>

<div class="footer">
    &copy; 2024 UBCampusMart. All rights reserved.
</div>

</body>
</html>

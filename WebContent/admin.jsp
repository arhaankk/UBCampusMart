<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ include file="jdbc.jsp" %>

<%
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("authenticatedUser");

    // If the user is not logged in, redirect to the login page
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;  // Stop further execution to avoid sending response after redirect
    }

    // Database connection and query
    String isAdmin = null;
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs1 = null;

    try {
        // Ensure consistent variable name (conn) in the try-with-resources block
        conn = DriverManager.getConnection(url, uid, pw);
        String sql = "SELECT isAdmin FROM customer WHERE userid = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, loggedInUser);
        rs1 = stmt.executeQuery();
        // Check if user exists and fetch their role
        if (rs1.next()) {
            isAdmin = rs1.getString("isAdmin");
        }

        // If no role found or the user is not an admin, redirect
        if (isAdmin == null || isAdmin.equalsIgnoreCase("False")) {
            response.sendRedirect("index.jsp");
            return;  // Stop further execution if the user is not an admin
        }

    } catch (SQLException e) {
        e.printStackTrace();
        // Handle database errors
        out.println("<p>isAdmin: " + isAdmin + "</p>");
        // response.sendRedirect("error.jsp");
        return;
    } finally {
        // Close resources
        try {
            if (rs1 != null) rs1.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Sales Report</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-900">

    <!-- Back Button -->
    <button 
        class="absolute top-2 left-4 p-4 text-white text-3xl"
        onclick="window.location.href='index.jsp';">
        &#8592;  <!-- Unicode Left Arrow -->
    </button>

    <!-- Header -->
    <header class="bg-gray-900 text-white py-6 text-center text-xl font-bold">
        Administrator Hub
    </header>

    <!-- Main Content -->
    <main class="px-4">
        <h2 class="text-center text-2xl font-semibold text-gray-900 mt-6">
            Sales Report and Customer List
        </h2>

        <!-- Responsive Container for Side-by-Side Tables -->
        <div class="flex flex-wrap justify-center gap-8 my-8">
            <!-- Sales Report Table -->
            <div class="relative overflow-x-auto shadow-md sm:rounded-lg max-w-md bg-gray-800">
                <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                    <thead class="text-xs text-gray-700 uppercase bg-gray-100 dark:bg-gray-700 dark:text-gray-400">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-white">
                                Order Date
                            </th>
                            <th scope="col" class="px-6 py-3 text-white">
                                Total Order Amount
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String salesSql = "SELECT CONVERT(date, orderDate) AS saleDate, SUM(totalAmount) AS totalSales " +
                                              "FROM ordersummary " +  
                                              "GROUP BY CONVERT(date, orderDate) " +
                                              "ORDER BY saleDate DESC";  

                            try {
                                getConnection();  // Open the connection
                                PreparedStatement ps = con.prepareStatement(salesSql);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String saleDate = rs.getString("saleDate");
                                    double totalSales = rs.getDouble("totalSales");
                                    out.println(
                                        "<tr class='bg-gray-900 border-b dark:bg-gray-800 dark:border-gray-700'>" +
                                            "<td class='px-6 py-4 text-white'>" + saleDate + "</td>" +
                                            "<td class='px-6 py-4 text-white'>" + totalSales + "</td>" +
                                        "</tr>"
                                    );
                                }
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='2' class='px-6 py-4 text-red-600'>Error fetching data: " + e.getMessage() + "</td></tr>");
                            } finally {
                                closeConnection();  
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Customer List Table -->
            <div class="relative overflow-x-auto shadow-md sm:rounded-lg max-w-md">
                <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                    <thead class="text-xs text-gray-700 uppercase bg-gray-100 dark:bg-gray-700 dark:text-gray-400">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-white">
                                Customer Name
                            </th>
                            <th scope="col" class="px-6 py-3 text-white">
                                Email
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String customersSql = "SELECT firstName, lastName, email FROM customer ORDER BY firstName ASC";  

                            try {
                                getConnection();  // Open the connection
                                PreparedStatement ps = con.prepareStatement(customersSql);
                                ResultSet rs = ps.executeQuery();

                                while (rs.next()) {
                                    String firstName = rs.getString("firstName");
                                    String lastName = rs.getString("lastName");
                                    String email = rs.getString("email");
                                    out.println(
                                        "<tr class='bg-white border-b dark:bg-gray-800 dark:border-gray-700'>" +
                                            "<td class='px-6 py-4 text-white'>" + firstName + " "+lastName + "</td>" +
                                            "<td class='px-6 py-4 text-white'>" + email + "</td>" +
                                        "</tr>"
                                    );
                                }
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='2' class='px-6 py-4 text-red-600'>Error fetching data: " + e.getMessage() + "</td></tr>");
                            } finally {
                                closeConnection();  
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white text-center py-4">
        &copy; 2024 UBCampusMart. All rights reserved.
    </footer>

</body>
</html>

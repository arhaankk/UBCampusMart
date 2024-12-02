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
        Administrator Sales Report
    </header>

    <!-- Main Content -->
    <main class="px-4">
        <h2 class="text-center text-2xl font-semibold text-gray-900 mt-6">
            Sales Report by Day
        </h2>
        
        <div class="relative overflow-x-auto shadow-md sm:rounded-lg my-8 mx-auto max-w-4xl">
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
                                out.println(
                                    "<tr class='bg-white border-b dark:bg-gray-800 dark:border-gray-700'>" +
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
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white text-center py-4">
        &copy; 2024 UBCampusMart. All rights reserved.
    </footer>

</body>
</html>

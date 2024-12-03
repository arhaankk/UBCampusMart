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
    <%-- <button 
        class="absolute top-2 left-4 p-4 text-white text-3xl"
        onclick="window.location.href='index.jsp';">
        &#8592;  <!-- Unicode Left Arrow -->
    </button> --%>

    <!-- Header -->
    <nav class="bg-white border-gray-200 dark:bg-gray-900">
        <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
            <a href="http://localhost/shop/index.jsp" class="flex items-center space-x-3 rtl:space-x-reverse">
                <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">UBCampusMart</span>
            </a>
            <button data-collapse-toggle="navbar-default" type="button" class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600" aria-controls="navbar-default" aria-expanded="false">
                <span class="sr-only">Open main menu</span>
                <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
                </svg>
            </button>
            <div class="hidden w-full md:block md:w-auto" id="navbar-default">
                <ul class="font-medium flex flex-col p-4 md:p-0 mt-4 border border-gray-100 rounded-lg bg-gray-50 md:flex-row md:space-x-8 rtl:space-x-reverse md:mt-0 md:border-0 md:bg-white dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700">
                    <!-- Other menu items -->
                    <li>
                        <a href="addProduct.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Add Product</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Edit Product</a>
                    </li>
                    <li>
                        <a href="loaddata.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Restore DB</a>
                    </li>
                     <li class="ml-auto">
                    <% 
                        String username = (String) session.getAttribute("authenticatedUser");
                        if (username != null) {
                    %>
                        <a href="customer.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Welcome back, <%= username %></a>
                    <% } %>
                </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="px-4">
        <h2 class="text-center text-2xl font-semibold text-gray-900 mt-6">
            Administrator Hub
        </h2>

        <!-- Responsive Container for Side-by-Side Tables -->
        <div class="flex flex-wrap justify-center gap-8 my-8">
            <!-- Sales Report Table -->
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
                    // Declare JavaScript variables to hold sales data for the chart
                    StringBuilder chartLabels = new StringBuilder("const salesLabels = [");
                    StringBuilder chartData = new StringBuilder("const salesData = [");

                    String salesSql = "SELECT CONVERT(date, orderDate) AS saleDate, SUM(totalAmount) AS totalSales " +
                                      "FROM ordersummary " +  
                                      "GROUP BY CONVERT(date, orderDate) " +
                                      "ORDER BY saleDate DESC";  

                    try {
                        getConnection();  // Open the connection
                        PreparedStatement ps = con.prepareStatement(salesSql);
                        ResultSet rs = ps.executeQuery();

                        boolean first = true; // Flag for adding commas in JS arrays
                        while (rs.next()) {
                            String saleDate = rs.getString("saleDate");
                            double totalSales = rs.getDouble("totalSales");

                            // Output the table rows
                            out.println(
                                "<tr class='bg-gray-900 border-b dark:bg-gray-800 dark:border-gray-700'>" +
                                    "<td class='px-6 py-4 text-white'>" + saleDate + "</td>" +
                                    "<td class='px-6 py-4 text-white'>" + totalSales + "</td>" +
                                "</tr>"
                            );

                            // Append data to JavaScript arrays
                            if (!first) {
                                chartLabels.append(", ");
                                chartData.append(", ");
                            }
                            chartLabels.append("'").append(saleDate).append("'");
                            chartData.append(totalSales);

                            first = false; // Ensure subsequent items have commas
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='2' class='px-6 py-4 text-red-600'>Error fetching data: " + e.getMessage() + "</td></tr>");
                    } finally {
                        closeConnection();  
                    }

                    // Close JavaScript arrays
                    chartLabels.append("];");
                    chartData.append("];");

                    // Output JavaScript variables
                    out.println("<script>");
                    out.println(chartLabels.toString());
                    out.println(chartData.toString());
                    out.println("</script>");
                %>
            </tbody>
        </table>
    </div>

<!-- Sales Report Chart -->
<div class="flex flex-col items-center justify-center max-w-2xl bg-gray-800 p-6 shadow-lg rounded-lg">
    <h3 class="text-xl font-semibold text-white mb-4" style="margin-bottom: 1.5rem;">Sales Report Chart</h3>
    <canvas id="salesChart" class="w-full h-auto"></canvas>
</div>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Render the chart
    const ctx = document.getElementById('salesChart').getContext('2d');
    const salesChart = new Chart(ctx, {
        type: 'line', // Line chart (or 'bar' for a bar chart)
        data: {
            labels: salesLabels, // Use labels generated from the JSP data
            datasets: [{
                label: 'Total Sales (USD)',
                data: salesData, // Use data generated from the JSP data
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    labels: {
                        color: 'white' // Set legend text color to white
                    }
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Order Date',
                        color: 'white' // X-axis title color
                    },
                    ticks: {
                        color: 'white' // X-axis label color
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.2)' // X-axis grid lines in white
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Total Sales (USD)',
                        color: 'white' // Y-axis title color
                    },
                    ticks: {
                        color: 'white' // Y-axis label color
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.2)' // Y-axis grid lines in white
                    }
                }
            }
        }
    });
</script>




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

</body>
</html>

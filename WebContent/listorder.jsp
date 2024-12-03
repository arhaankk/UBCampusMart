<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart</title>
    <script src="https://cdn.tailwindcss.com"></script> <!-- Tailwind CDN -->
</head>
<body class="bg-gray-50 text-gray-800">

<nav class=" border-gray-200 dark:bg-gray-900">
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
                        <a href="listprod.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Products</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Order History</a>
                    </li>
                    <li>
                        <a href="showcart.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Shopping Cart</a>
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

<h1 class="text-3xl text-center text-gray-900 py-10 font-bold">Order List</h1>

<div class="container mx-auto p-6 bg-white shadow-lg rounded-lg">
<%
    // Retrieve the logged-in user's username from the session
    String loggedInUsername = (String) session.getAttribute("authenticatedUser");
    
    if (loggedInUsername == null) {
        out.println("<p class='text-center text-red-500'>You must be logged in to view your orders.</p>");
    } else {
        try {
            // Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        // Useful code for formatting currency values:
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        // Make connection
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            Statement s = con.createStatement();

            // Write query to retrieve all orders for the logged-in user based on username
            String query = "SELECT o.orderId, o.orderDate, o.totalAmount, c.customerId, c.firstName, c.lastName " +
                           "FROM ordersummary o " +
                           "JOIN customer c ON o.customerId = c.customerId " +
                           "WHERE c.userid = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, loggedInUsername);  // Set the logged-in username to filter orders
            ResultSet rs = ps.executeQuery();

            // For each order in the ResultSet
            while (rs.next()) {
                int orderId = rs.getInt("orderId");
                Timestamp orderDate = rs.getTimestamp("orderDate");
                double totalAmount = rs.getDouble("totalAmount");
                int customerId = rs.getInt("customerId");
                String customerName = rs.getString("firstName") + " " + rs.getString("lastName");

                // Order Summary Table
                out.println("<table class='w-full my-4 border-collapse table-auto'><tr><td class='font-bold p-2'>Order ID:</td><td class='p-2'>" + orderId + "</td></tr>");
                out.println("<tr><td class='font-bold p-2'>Order Date:</td><td class='p-2'>" + orderDate + "</td></tr>");
                out.println("<tr><td class='font-bold p-2'>Customer ID:</td><td class='p-2'>" + customerId + "</td></tr>");
                out.println("<tr><td class='font-bold p-2'>Customer Name:</td><td class='p-2'>" + customerName + "</td></tr>");
                out.println("<tr><td class='font-bold p-2'>Total Amount:</td><td class='p-2'>" + currFormat.format(totalAmount) + "</td></tr>");
                out.println("</table>");

                // Write a query to retrieve the products in the order
                String productQuery = "SELECT p.productId, p.productName, op.quantity, op.price " +
                                      "FROM orderproduct op " +
                                      "JOIN product p ON op.productId = p.productId " +
                                      "WHERE op.orderId = ?";
                PreparedStatement productStmt = con.prepareStatement(productQuery);
                productStmt.setInt(1, orderId);
                ResultSet productRs = productStmt.executeQuery();

                // Product Table
                out.println("<h4 class='text-xl font-semibold mt-8'>Ordered Products:</h4>");
                out.println("<table class='w-full table-auto mt-4'><thead><tr><th class='border p-2 bg-gray-900 text-white'>Product ID</th><th class='border p-2 bg-gray-900 text-white'>Product Name</th><th class='border p-2 bg-gray-900 text-white'>Quantity</th><th class='border p-2 bg-gray-900 text-white'>Price</th></tr></thead><tbody>");
                while (productRs.next()) {
                    int productId = productRs.getInt("productId");
                    String productName = productRs.getString("productName");
                    int quantity = productRs.getInt("quantity");
                    double price = productRs.getDouble("price");

                    out.println("<tr><td class='border p-2'>" + productId + "</td><td class='border p-2'>" + productName + "</td><td class='border p-2'>" + quantity + "</td><td class='border p-2'>" + currFormat.format(price) + "</td></tr>");
                }
                out.println("</tbody></table>");
            }
        } catch (SQLException e) {
            out.print("Error: " + e.getMessage());
        }
    }
%>

</div>

<a href="checkout.jsp" class="block mx-auto mt-10 w-64 text-center py-2 px-4 bg-green-600 text-white text-lg font-semibold rounded-md hover:bg-green-700">Proceed to Checkout</a>

</body>
</html>

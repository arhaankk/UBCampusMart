<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart Checkout</title>
    <script src="https://cdn.tailwindcss.com"></script> <!-- Tailwind CDN -->
</head>
<body class="bg-white text-gray-900 font-sans">
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
                        <a href="listprod.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-500 dark:hover:text-white md:dark:hover:bg-transparent">Products</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-500 dark:hover:text-white md:dark:hover:bg-transparent">Order List</a>
                    </li>
                    <li>
                        <a href="showcart.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-500 dark:hover:text-white md:dark:hover:bg-transparent">Shopping Cart</a>
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

    <div class="min-h-screen flex items-center justify-center py-8 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full bg-slate-900 p-8 rounded-lg shadow-lg">
        <h1 class="text-3xl font-semibold text-center text-white mb-6">Checkout</h1>
        
        <%
            String defaultAddress = "";
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                con = DriverManager.getConnection(url, uid, pw);

                // Retrieve the default address for the customer
                stmt = con.prepareStatement("SELECT address FROM customer WHERE userid = ?");
                stmt.setString(1, username);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    defaultAddress = rs.getString("address");
                }
            } catch (SQLException e) {
                out.println("<p class='text-red-600'>Error fetching address: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                } catch (SQLException e) {
                    out.println("<p class='text-red-600'>Error closing resources: " + e.getMessage() + "</p>");
                }
            }
        %>

        <!-- Default Address Display -->
        <div class="mb-6">
            <h2 class="text-lg font-semibold text-white">Default Shipping Address</h2>
            <p class="text-white mt-2"><%= defaultAddress %></p>
        </div>

        <!-- Shipping Address Form -->
<div class="p-4 bg-white rounded-lg shadow-md">
    <h2 class="text-2xl font-semibold mb-4">Shipping Information</h2>
    <form action="order.jsp" method="POST">
        <!-- Existing Shipping Address fields -->
        <div class="mb-4">
            <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
            <input type="text" id="address" name="address" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="Street Address">
        </div>
        
        <!-- New fields for City, State, Postal Code, and Country -->
        <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
                <label for="city" class="block text-sm font-medium text-gray-700">City</label>
                <input type="text" id="city" name="city" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="City">
            </div>
            <div>
                <label for="state" class="block text-sm font-medium text-gray-700">State</label>
                <input type="text" id="state" name="state" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="State">
            </div>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
                <label for="postalcode" class="block text-sm font-medium text-gray-700">Postal Code</label>
                <input type="text" id="postalcode" name="postalcode" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="Postal Code">
            </div>
            <div>
                <label for="country" class="block text-sm font-medium text-gray-700">Country</label>
                <input type="text" id="country" name="country" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="Country">
            </div>
        </div>

        <!-- Submit button -->
        <button type="submit" class="mt-4 bg-blue-500 text-white p-2 rounded-md w-full">Proceed to Order</button>
    </form>
</div>

    </div>
    </div>
</body>
</html>

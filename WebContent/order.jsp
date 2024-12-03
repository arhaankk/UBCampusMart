<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart Order Processing</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
  <!-- Navbar starts here -->
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
                        <a href="listprod.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Products</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Order List</a>
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
    <!-- Navbar ends here -->

<% 
    // Get customer id from the request
    String custId = request.getParameter("customerId");
    String loggedInCustomerId = (String) session.getAttribute("loggedInCustomerId");
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String errorMessage = "";
    boolean isValidCustomer = false;

    

    // Check if customer id is valid and exists in database
    if (custId != null && !custId.isEmpty()) {
        try {
            con = DriverManager.getConnection(url, uid, pw);

            // Check if the customer id exists in the database
            stmt = con.prepareStatement("SELECT customerId FROM customer WHERE customerId = ? AND userid = ?");
            stmt.setInt(1, Integer.parseInt(custId));
            stmt.setString(2, username);
            rs = stmt.executeQuery();
            if (rs.next()) {
                isValidCustomer = true;
            } else {
                errorMessage = "Invalid Customer ID";
            }
        } catch (SQLException e) {
            errorMessage = "Database connection error: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                errorMessage = "Error closing resources: " + e.getMessage();
            }
        }
    } else {
        errorMessage = "Please enter a valid Customer ID.";
    }

    // Handle empty cart condition
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
        out.println("<h3 class='text-center text-red-600'>Your shopping cart is empty. Please add items to your cart before checking out.</h3>");
    } else if (!isValidCustomer) {
        out.println("<h3 class='text-center text-red-600'>" + (errorMessage.isEmpty() ? "Customer not found!" : errorMessage) + "</h3>");
    } else {
        // Insert order into ordersummary table and get generated orderId
        try {
            // Start a transaction
            con.setAutoCommit(false);

            // Insert order summary into ordersummary table
            String insertOrderSQL = "INSERT INTO ordersummary (orderDate, customerId) VALUES (GETDATE(), ?)";
            stmt = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, Integer.parseInt(custId));
            stmt.executeUpdate();

            // Get the generated orderId
            rs = stmt.getGeneratedKeys();
            rs.next();
            int orderId = rs.getInt(1);

            // Insert each product into orderproduct table
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            double totalAmount = 0.0;

            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                String productId = (String) product.get(0);
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();

                // Insert product into orderproduct table
                String insertProductSQL = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
                stmt = con.prepareStatement(insertProductSQL);
                stmt.setInt(1, orderId);
                stmt.setInt(2, Integer.parseInt(productId));
                stmt.setInt(3, qty);
                stmt.setDouble(4, pr);
                stmt.executeUpdate();

                // Update total amount for the order
                totalAmount += pr * qty;
            }

            // Update totalAmount in the ordersummary table
            String updateTotalAmountSQL = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
            stmt = con.prepareStatement(updateTotalAmountSQL);
            stmt.setDouble(1, totalAmount);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

            // Commit the transaction
            con.commit();
            session.removeAttribute("productList");
            // Display the order summary
            out.println("<div class='max-w-xs mx-auto bg-white p-4 rounded-lg shadow-lg mt-8'>");
            out.println("<div class='text-center pb-4'>");
            out.println("<h3 class='text-lg font-semibold'>UBCampusMart</h3>");
            out.println("<p class='text-sm text-gray-500'>Order Summary</p>");
            out.println("<div class='py-4 text-xs text-gray-600'>");
            out.println("<p><strong>Order ID:</strong> #" + orderId + "</p>");
            out.println("<p><strong>Customer:</strong> "+username+"</p>");
            out.println("</div>");

            out.println("<table class='w-full text-xs border-t border-b border-gray-300 py-2'>");
            out.println("<thead><tr class='flex'><th class='flex-1'>Product</th><th class='w-16 text-right'>QTY</th><th class='w-16 text-right'>Total</th></tr></thead>");
            out.println("<tbody>");
            iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                String productName = (String) product.get(1);
                int qty = ((Integer) product.get(3)).intValue();
                String price = (String) product.get(2);
                out.println("<tr class='flex'><td class='flex-1 py-2'>" + productName + "</td><td class='text-right'>" + qty + "</td><td class='text-right'>$" + price + "</td></tr>");
            }
            out.println("</tbody>");
            out.println("</table>");
            out.println("<div class='text-center pt-4 text-xs'>");
            out.println("<p><strong>Total Amount:</strong> $" + totalAmount + "</p>");
            out.println("<p>Thank you for your order!</p>");
            out.println("<p>Your cart has been cleared 🛒</p>");
            out.println("</div>");
            out.println("</div>");
        } catch (SQLException e) {
            out.println("<h3 class='text-center text-red-600'>Database error: " + e.getMessage() + "</h3>");
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                out.println("<h3 class='text-center text-red-600'>Rollback failed: " + ex.getMessage() + "</h3>");
            }
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<h3 class='text-center text-red-600'>Error closing database resources: " + e.getMessage() + "</h3>");
            }
        }
    }
%>

</body>
</html>

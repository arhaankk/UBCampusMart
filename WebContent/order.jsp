<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
    // Get customer id from the request
    String custId = request.getParameter("customerId");
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String errorMessage = "";
    boolean isValidCustomer = false;

    // Check if customer id is valid and exists in database
    if (custId != null && !custId.isEmpty()) {
        try {
            con = DriverManager.getConnection(url,uid,pw);

            // Check if the customer id exists in the database
            stmt = con.prepareStatement("SELECT customerId FROM customer WHERE customerId = ?");
            stmt.setInt(1, Integer.parseInt(custId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                isValidCustomer = true;
            } else {
                errorMessage = "Invalid Customer ID.";
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
        out.println("<h3>Your shopping cart is empty. Please add items to your cart before checking out.</h3>");
    } else if (!isValidCustomer) {
        out.println("<h3>" + (errorMessage.isEmpty() ? "Customer not found!" : errorMessage) + "</h3>");
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
			
            //Insert each product into orderproduct table
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

            //Update totalAmount in the ordersummary table
            String updateTotalAmountSQL = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
            stmt = con.prepareStatement(updateTotalAmountSQL);
            stmt.setDouble(1, totalAmount);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

            //Commit the transaction
            con.commit();

            //Display the order information including all ordered items
            out.println("<h3>Order Summary</h3>");
            out.println("<p>Order ID: " + orderId + "</p>");
            out.println("<p>Total Amount: $" + totalAmount + "</p>");
            out.println("<h4>Ordered Items:</h4>");
            out.println("<ul>");
            iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                String productName = (String) product.get(1);
                int qty = ((Integer) product.get(3)).intValue();
                String price = (String) product.get(2);
                out.println("<li>" + productName + " - Quantity: " + qty + " - Price: $" + price + "</li>");
            }
            out.println("</ul>");

            // Clear the shopping cart (session variable)
            session.removeAttribute("productList");

            out.println("<h3>Thank you for your order! Your cart has been cleared.</h3>");

        } catch (SQLException e) {
            out.println("<h3>Database error: " + e.getMessage() + "</h3>");
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                out.println("<h3>Rollback failed: " + ex.getMessage() + "</h3>");
            }
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<h3>Error closing database resources: " + e.getMessage() + "</h3>");
            }
        }
    }
%>

</body>
</html>

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
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fc;
            color: #333;
            margin: 0;
            padding: 0;
        }

        header {
            text-align: center;
            padding: 20px;
            background-color: #3b4a67;
            color: white;
        }

        header h2 {
            margin: 0;
        }

        header nav {
            margin-top: 10px;
        }

        header a {
            margin: 10px;
            color: white;
            text-decoration: none;
        }

        header a:hover {
            text-decoration: underline;
        }

        h1 {
            text-align: center;
            color: #3b4a67;
            padding-top: 30px;
        }

        .container {
            width: 80%;
            margin: 20px auto;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #3b4a67;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .order-summary td {
            font-weight: bold;
            background-color: #f9f9f9;
        }

        .product-table td {
            background-color: #fff;
        }

        .checkout-btn {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 10px;
            text-align: center;
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-size: 18px;
        }

        .checkout-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<header>
    <div>
        <h2>Welcome to Soumil's Grocery Store</h2>
        <nav>
            <a href="listprod.jsp">Products</a>
            <a href="listorder.jsp">Order List</a>
            <a href="showcart.jsp">Shopping Cart</a>
        </nav>
    </div>
</header>

<h1>Order List</h1>

<div class="container">
<%
    // Note: Forces loading of SQL Server driver
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

        // Write query to retrieve all order summary records
        String query = "SELECT o.orderId, o.orderDate, o.totalAmount, c.customerId, c.firstName, c.lastName " +
                       "FROM ordersummary o " +
                       "JOIN customer c ON o.customerId = c.customerId";
        ResultSet rs = s.executeQuery(query);

        // For each order in the ResultSet
        while (rs.next()) {
            int orderId = rs.getInt("orderId");
            Timestamp orderDate = rs.getTimestamp("orderDate");
            double totalAmount = rs.getDouble("totalAmount");
            int customerId = rs.getInt("customerId");
            String customerName = rs.getString("firstName") + " " + rs.getString("lastName");

            // Order Summary Table
            out.println("<table class='order-summary'><tr><td>Order ID:</td><td>" + orderId + "</td></tr>");
            out.println("<tr><td>Order Date:</td><td>" + orderDate + "</td></tr>");
            out.println("<tr><td>Customer ID:</td><td>" + customerId + "</td></tr>");
            out.println("<tr><td>Customer Name:</td><td>" + customerName + "</td></tr>");
            out.println("<tr><td>Total Amount:</td><td>" + currFormat.format(totalAmount) + "</td></tr>");
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
            out.println("<h4>Ordered Products:</h4>");
            out.println("<table class='product-table'><thead><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th></tr></thead><tbody>");
            while (productRs.next()) {
                int productId = productRs.getInt("productId");
                String productName = productRs.getString("productName");
                int quantity = productRs.getInt("quantity");
                double price = productRs.getDouble("price");

                out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" + currFormat.format(price) + "</td></tr>");
            }
            out.println("</tbody></table>");
        }
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    }
%>

</div>

<a href="checkout.jsp" class="checkout-btn">Proceed to Checkout</a>

</body>
</html>

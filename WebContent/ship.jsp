<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>UBCampusMart Shipment Processing</title>

<!-- Add FontAwesome for the back button icon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- Add some basic styles to make it look professional -->
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f7fc;
        margin: 0;
        padding: 0;
        color: #333;
    }

    h1, h2 {
        color: #2C3E50;
    }

    h3 {
        color: #E74C3C;
        font-weight: bold;
    }

    p {
        font-size: 16px;
        line-height: 1.6;
    }

    .container {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-top: 80px; /* Adjusted to move the card lower */
    }

    .message {
        background-color: #F2DEDE;
        color: #C0392B;
        padding: 15px;
        border: 1px solid #E74C3C;
        border-radius: 5px;
        margin-bottom: 20px;
    }

    /* Green success bubble */
    .success {
        background-color: #DFF0D8;
        color: #3C763D;
        padding: 20px;
        border: 1px solid #D6E9C6;
        border-radius: 5px;
        margin-bottom: 20px;
    }

    .btn {
        background-color: #3498DB;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        font-size: 16px;
        margin-top: 20px;
    }

    .btn:hover {
        background-color: #2980B9;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    table, th, td {
        border: 1px solid #ddd;
    }

    th, td {
        padding: 12px;
        text-align: left;
    }

    th {
        background-color: #f1f1f1;
    }

    td {
        background-color: #f9f9f9;
    }

    td, th {
        font-size: 16px;
    }

    .back-btn {
        position: relative;
        top: 50px; /* Adjusted to position the button lower */
        left: 20px;
        background-color: #3498DB;
        color: white;
        border: none;
        padding: 10px 15px;
        font-size: 18px;
        border-radius: 5px;
        cursor: pointer;
        display: flex;
        align-items: center;
    }

    .back-btn:hover {
        background-color: #2980B9;
    }

    .back-btn i {
        margin-right: 8px;
    }

    .back-link {
        color: #3498DB;
        font-size: 18px;
        text-decoration: none;
    }

    .back-link:hover {
        text-decoration: underline;
    }
</style>

</head>
<body>

<!-- Back button placed at the top left -->
<button class="back-btn" onclick="window.location.href='index.jsp';">
    <i class="fas fa-arrow-left"></i>Back
</button>

<%-- <%@ include file="header.jsp" %> --%>

<div class="container">

    <h1>UBCampusMart Shipment Processing</h1>

    <%
        // Get order ID from the request
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        // SQL query to fetch order products
        String orderProductQuery = "SELECT op.productId, op.quantity, op.price, p.productName " +
                                   "FROM orderproduct op " +
                                   "JOIN product p ON op.productId = p.productId " +
                                   "WHERE op.orderId = ?";
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement ps2 = con.prepareStatement(orderProductQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {

            ps2.setInt(1, orderId);
            
            try (ResultSet rs2 = ps2.executeQuery()) {
                boolean canShip = true;
                StringBuilder successMessage = new StringBuilder();

                while (rs2.next()) {
                    int productId = rs2.getInt("productId");
                    int quantity = rs2.getInt("quantity");
                    double price = rs2.getDouble("price");
                    String productName = rs2.getString("productName");

                    // SQL query to check inventory for the product
                    String inventoryQuery = "SELECT pi.quantity FROM productinventory pi " +
                                             "WHERE pi.productId = ? AND pi.warehouseId = 1";
                    try (PreparedStatement ps3 = con.prepareStatement(inventoryQuery)) {
                        ps3.setInt(1, productId);
                        try (ResultSet rs3 = ps3.executeQuery()) {
                            if (rs3.next()) {
                                int availableQuantity = rs3.getInt("quantity");
                                if (availableQuantity < quantity) {
                                    out.println("<div class='message'>");
                                    out.println("<h3>Not enough inventory for product: " + productName + " (Product ID: " + productId + "). Available: " + availableQuantity + ", Required: " + quantity + "</h3>");
                                    out.println("<h3>Shipment not done. Insufficient inventory for product ID: " + productId + "</h3>");
                                    out.println("</div>");
                                    canShip = false;
                                    break;
                                } else {
                                    // Display the previous and new inventory for the product
                                    int newInventory = availableQuantity - quantity;
                                    out.println("<table>");
                                    out.println("<tr><th>Ordered Product</th><th>Quantity</th><th>Previous Inventory</th><th>New Inventory</th></tr>");
                                    out.println("<tr>");
                                    out.println("<td>" + productId + "</td>");
                                    out.println("<td>" + quantity + "</td>");
                                    out.println("<td>" + availableQuantity + "</td>");
                                    out.println("<td>" + newInventory + "</td>");
                                    out.println("</tr>");
                                    out.println("</table>");
                                    successMessage.append("<p>Inventory updated for product ID: " + productId + " (" + productName + "). </p>");
                                }
                            } else {
                                out.println("<div class='message'>");
                                out.println("<h3>Product (ID: " + productId + ") not found in inventory.</h3>");
                                out.println("<h3>Shipment not done. Insufficient inventory for product ID: " + productId + "</h3>");
                                out.println("</div>");
                                canShip = false;
                                break;
                            }
                        }
                    }
                }
                
                // Proceed with shipment processing if inventory is sufficient
                if (canShip) {
                    // Loop through the products again for inventory update
                    rs2.beforeFirst();
                    while (rs2.next()) {
                        int productId = rs2.getInt("productId");
                        int quantity = rs2.getInt("quantity");

                        String updateInventoryQuery = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
                        try (PreparedStatement ps4 = con.prepareStatement(updateInventoryQuery)) {
                            ps4.setInt(1, quantity);
                            ps4.setInt(2, productId);
                            int rowsAffected = ps4.executeUpdate();
                            if (rowsAffected > 0) {
                                successMessage.append("<p>Updated inventory for product ID: " + productId + ".</p>");
                            }
                        }
                    }

                    // Create shipment record here (insert into shipment table)
                    String createShipmentQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (CURRENT_TIMESTAMP, 'Shipment for Order ID: " + orderId + "', 1)";
                    try (PreparedStatement ps5 = con.prepareStatement(createShipmentQuery)) {
                        int rowsAffected = ps5.executeUpdate();
                        if (rowsAffected > 0) {
                            successMessage.append("<h3>Shipment successfully processed.</h3>");
                        }
                    }
                }

                // If success message is not empty, show the success bubble
                if (successMessage.length() > 0) {
                    out.println("<div class='success'>");
                    out.println(successMessage.toString());
                    out.println("</div>");
                }

            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='message'>");
            out.println("<h2>Error checking inventory: " + e.getMessage() + "</h2>");
            out.println("</div>");
        }
    %>
</div>

</body>
</html>

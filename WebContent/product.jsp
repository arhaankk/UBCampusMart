<%@ page import="java.sql.*, java.text.NumberFormat, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>UBCampusMart - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 30px;
            padding: 20px;
        }
        .product-details {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }
        .product-details img {
            max-width: 300px;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .product-info {
            flex: 1;
        }
        .product-info h1 {
            font-size: 28px;
            color: #2c3e50;
        }
        .product-info p {
            font-size: 18px;
            color: #7f8c8d;
        }
        .product-info .description {
            font-size: 20px;
            color: #2c3e50;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .product-info .price {
            font-size: 24px;
            color: red;
            font-weight: bold;
        }
        .buttons {
            margin-top: 20px;
        }
        .buttons a {
            margin-right: 10px;
            padding: 10px 15px;
            font-size: 16px;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            border-radius: 4px;
        }
        .buttons a:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<%-- <%@ include file="header.jsp" %> --%>

<div class="container">
    <%
        // Retrieve product ID from request parameter
        String productId = request.getParameter("id");
        if (productId == null || productId.trim().isEmpty()) {
            out.println("<p>Invalid product. Please go back to the product list.</p>");
        } else {
            try {
                // SQL query to get product details including productDesc and productImage
                String sql = "SELECT productName, productPrice, productDesc, productImageURL, productImage FROM product WHERE productId = ?";
                try (Connection con = DriverManager.getConnection(url, uid, pw);
                     PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(productId));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            // Fetch product details
                            String productName = rs.getString("productName");
                            double productPrice = rs.getDouble("productPrice");
                            String productDesc = rs.getString("productDesc");
                            String productImageURL = rs.getString("productImageURL");
                            byte[] productImage = rs.getBytes("productImage");

                            // Format price
                            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                            String formattedPrice = currFormat.format(productPrice);

                            // Prepare the images
                            String imageTag1 = "";
                            String imageTag2 = "";

                            // Check if binary image is available
                            if (productImage != null && productImage.length > 0) {
                                // If there's a binary image, create a Data URL for the image
                                String imageBase64 = java.util.Base64.getEncoder().encodeToString(productImage);
                                imageTag1 = "<img src='data:image/jpeg;base64," + imageBase64 + "' alt='" + productName + "'>";
                            }

                            // Check if URL-based image is available
                            if (productImageURL != null && !productImageURL.isEmpty()) {
                                imageTag2 = "<img src='" + productImageURL + "' alt='" + productName + "'>";
                            } 

                            // Display product details with images and description
                            out.println("<div class='product-details'>");
                            out.println("<div class='product-image'>" + imageTag1 + "</div>");
                            out.println("<div class='product-image'>" + imageTag2 + "</div>");
                            out.println("<div class='product-info'>");
                            out.println("<h1>" + productName + "</h1>");
                            out.println("<p class='description'><strong>Description:</strong> " + productDesc + "</p>");
                            out.println("<p class='price'><strong>Price:</strong> " + formattedPrice + "</p>");
                            out.println("<div class='buttons'>");
                            out.println("<a href='addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice + "'>Add to Cart</a>");
                            out.println("<a href='listprod.jsp'>Continue Shopping</a>");
                            out.println("</div>");
                            out.println("</div>");
                            out.println("</div>");
                        } else {
                            out.println("<p>Product not found. Please go back to the product list.</p>");
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>

</body>
</html>

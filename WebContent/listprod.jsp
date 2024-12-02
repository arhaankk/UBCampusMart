<%@ page import="java.sql.*, java.net.URLEncoder, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart - Product List</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
    }
    h1 {
        text-align: center;
        color: #2c3e50;
    }
    .search-form {
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
        background-color: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .search-form input[type="text"], .search-form select {
        padding: 10px;
        width: 45%;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    .search-form input[type="submit"], .search-form input[type="reset"] {
        padding: 10px 15px;
        font-size: 16px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .search-form input[type="submit"]:hover, .search-form input[type="reset"]:hover {
        background-color: #2980b9;
    }
    .product-list {
        display: flex;
        flex-wrap: wrap;
        gap: 15px; /* Space between cards */
        justify-content: center;
    }
    .product-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 200px; /* Fixed width for uniformity */
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        padding: 15px;
        text-align: center;
        overflow: hidden;
    }
    .product-card img {
        width: 180px; /* Fixed width */
        height: 180px; /* Fixed height */
        object-fit: cover; /* Ensures the image covers the area without distortion */
        border-radius: 4px;
        margin-bottom: 10px;
    }
    .product-card h3 {
        font-size: 16px;
        color: #2c3e50;
        margin: 10px 0;
    }
   .product-card p {
    font-size: 20px; /* Increased font size */
    font-weight: bold; /* Make it bold */
    color: #e74c3c; /* Highlight with a red color */
    margin-top: 10px; /* Add spacing from other elements */
}

    .add-to-cart {
        display: inline-block;
        padding: 10px 15px;
        margin-top: 10px;
        background-color: #3498db;
        color: white;
        text-decoration: none;
        border-radius: 4px;
    }
    .add-to-cart:hover {
        background-color: #2980b9;
    }
    </style>

</head>
<body>

<header>
    <div style="text-align: center; padding: 20px; background-color: #3b4a67; color: white;">
        <h2>UBCampusMart</h2>
        <nav>
            <a href="listprod.jsp" style="margin: 10px; color: white; text-decoration: none;">Products</a>
            <a href="listorder.jsp" style="margin: 10px; color: white; text-decoration: none;">Order List</a>
            <a href="showcart.jsp" style="margin: 10px; color: white; text-decoration: none;">Shopping Cart</a>
        </nav>
    </div>
</header>

<div class="container">
    <h1>Search for the products you want to buy:</h1>

    <!-- Search Form -->
    <form method="get" action="listprod.jsp" class="search-form">
        <input type="text" name="productName" placeholder="Search by product name">
        <select name="categoryId">
            <option value="">Select Category</option>
            <% 
                try {
                    String categoryQuery = "SELECT categoryId, categoryName FROM category";
                    try (Connection con = DriverManager.getConnection(url, uid, pw);
                         PreparedStatement ps = con.prepareStatement(categoryQuery);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            int categoryId = rs.getInt("categoryId");
                            String categoryName = rs.getString("categoryName");
                            out.println("<option value='" + categoryId + "'>" + categoryName + "</option>");
                        }
                    }
                } catch (SQLException e) {
                    out.println("<option>Error loading categories</option>");
                }
            %>
        </select>
        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </form>

<%
    String name = request.getParameter("productName");
    String categoryId = request.getParameter("categoryId");

    String query = "SELECT productId, productName, productPrice, productImageURL, productImage FROM product WHERE productName LIKE ?";
    if (categoryId != null && !categoryId.isEmpty()) {
        query += " AND categoryId = ?";
    }

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setString(1, "%" + (name != null ? name : "") + "%");
        if (categoryId != null && !categoryId.isEmpty()) {
            ps.setInt(2, Integer.parseInt(categoryId));
        }

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                out.println("<p>No products found matching your search.</p>");
            } else {
                out.println("<div class='product-list'>");
                do {
                    int productId = rs.getInt("productId");
                    String productName = rs.getString("productName");
                    double productPrice = rs.getDouble("productPrice");
                    String productImageURL = rs.getString("productImageURL");
                    byte[] productImage = rs.getBytes("productImage");

                    String imageTag = (productImage != null && productImage.length > 0)
                        ? "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(productImage) + "' alt='" + productName + "'>"
                        : (productImageURL != null && !productImageURL.isEmpty())
                            ? "<img src='" + productImageURL + "' alt='" + productName + "'>"
                            : "<img src='images/default.jpg' alt='Default Image'>";

                    String formattedPrice = currFormat.format(productPrice);
                    String productLink = "product.jsp?id=" + productId;

                    out.println("<a href='" + productLink + "' style='text-decoration: none; color: inherit;'>");
                    out.println("<div class='product-card'>");
                    out.println(imageTag);
                    out.println("<h3>" + productName + "</h3>");
                    out.println("<p>" + formattedPrice + "</p>");
                    out.println("</div>");
                    out.println("</a>");
                } while (rs.next());
                out.println("</div>");
            }
        }
    } catch (SQLException e) {
        out.print("<p>Error: " + e.getMessage() + "</p>");
    }
%>

</div>

</body>
</html>

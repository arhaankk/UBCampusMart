<%@ page import="java.sql.*, java.net.URLEncoder, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart - Product List</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom Styles (Optional, to enhance layout) */
        .product-card img {
            object-fit: cover;
        }
    </style>
</head>
<body class="bg-gray-100">

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

<div class="max-w-7xl mx-auto px-4 py-16">
    <h1 class="text-3xl font-bold text-center mb-8">Search for Products</h1>

    <!-- Search Form -->
    <form method="get" action="listprod.jsp" class="mb-8 bg-white p-6 rounded-lg shadow-md flex justify-between space-x-4">
        <input type="text" name="productName" placeholder="Search by product name" class="border border-gray-300 p-3 rounded-lg w-1/2">
        <select name="categoryId" class="border border-gray-300 p-3 rounded-lg w-1/3">
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
        <div class="flex space-x-4">
            <input type="submit" value="Submit" class="bg-blue-500 text-white py-2 px-4 rounded">
            <input type="reset" value="Reset" class="bg-gray-300 text-gray-700 py-2 px-4 rounded">
        </div>
    </form>

<!-- Product List -->
<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-8">
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
                    out.println("<p class='text-center text-gray-500'>No products found matching your search.</p>");
                } else {
                    do {
                        int productId = rs.getInt("productId");
                        String productName = rs.getString("productName");
                        double productPrice = rs.getDouble("productPrice");
                        String productImageURL = rs.getString("productImageURL");
                        byte[] productImage = rs.getBytes("productImage");
                        String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;

                        String imageTag = (productImage != null && productImage.length > 0)
                            ? "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(productImage) + "' alt='" + productName + "' class='w-full h-48 object-cover rounded-lg'>"
                            : (productImageURL != null && !productImageURL.isEmpty())
                                ? "<img src='" + productImageURL + "' alt='" + productName + "' class='w-full h-48 object-cover rounded-lg'>"
                                : "<img src='images/default.jpg' alt='Default Image' class='w-full h-48 object-cover rounded-lg'>";

                        String formattedPrice = currFormat.format(productPrice);
                        String productLink = "product.jsp?id=" + productId;

                        out.println("<div class='bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 flex flex-col'>");
                        out.println("<a href='" + productLink + "' class='group block'>");
                        out.println(imageTag);
                        out.println("</a>");
                        out.println("<div class='p-4'>");
                        out.println("<h3 class='text-lg font-medium text-gray-900'>" + productName + "</h3>");
                        out.println("<p class='text-xl font-semibold text-gray-700'>" + formattedPrice + "</p>");
                        out.println("<a href='" + addToCartLink + "' class='bg-blue-500 text-white px-4 py-2 mt-4 inline-block rounded-lg shadow-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition-all duration-200'>Add to Cart</a>");
                        out.println("</div>");
                        out.println("</div>");
                    } while (rs.next());
                }
            }
        } catch (SQLException e) {
            out.print("<p class='text-red-500 text-center'>Error: " + e.getMessage() + "</p>");
        }
    %>
</div>



</div>

<!-- Footer -->
    <footer class="bg-gray-900 text-white text-center py-4">
        &copy; 2024 UBCampusMart. All rights reserved.
    </footer>
</body>
</html>

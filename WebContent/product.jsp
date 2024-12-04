<%@ page import="java.sql.*, java.text.NumberFormat, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>UBCampusMart - Product Information</title>
    <script src="https://cdn.tailwindcss.com"></script>
      <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-white text-gray-900">

     <!-- Back Button -->
    <a href="listprod.jsp" class="absolute top-4 left-4 bg-slate-900 text-white p-2 rounded-full shadow-md hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-slate-600">
        <i class="fas fa-arrow-left"></i> <!-- Font Awesome Back Arrow Icon -->
    </a>

    <!-- Navbar Placeholder -->
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
                </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-4 py-8">
        <%
            // Retrieve product ID from request parameter
            String productId = request.getParameter("id");
            if (productId == null || productId.trim().isEmpty()) {
                out.println("<p class='text-gray-900'>Invalid product. Please go back to the product list.</p>");
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
                                    imageTag1 = "<img src='data:image/jpeg;base64," + imageBase64 + "' alt='" + productName + "' class='w-full h-auto object-contain rounded-lg border border-gray-300'>";
                                }

                                // Check if URL-based image is available
                                if (productImageURL != null && !productImageURL.isEmpty()) {
                                    imageTag2 = "<img src='" + productImageURL + "' alt='" + productName + "' class='w-full h-auto object-contain rounded-lg border border-gray-300'>";
                                }

                                // Display product details with images and description
                                out.println("<div class='flex flex-col lg:flex-row gap-8'>");

                                // First image (binary or base64)
                                if (!imageTag1.isEmpty()) {
                                    out.println("<div class='w-full lg:w-1/3'>" + imageTag1 + "</div>");
                                }

                                // Second image (URL)
                                if (!imageTag2.isEmpty()) {
                                    out.println("<div class='w-full lg:w-1/3'>" + imageTag2 + "</div>");
                                }

                                out.println("<div class='w-full lg:w-2/3 space-y-6'>");
                                out.println("<h1 class='text-3xl font-bold'>" + productName + "</h1>");
                                out.println("<p class='text-lg text-gray-600'><strong>Description:</strong> " + productDesc + "</p>");
                                out.println("<p class='text-2xl text-red-500 font-semibold'><strong>Price:</strong> " + formattedPrice + "</p>");
                                out.println("<div class='flex space-x-4 mt-6'>");
                                out.println("<a href='addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice + "' class='px-6 py-3 text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition duration-300'>Add to Cart</a>");
                                out.println("<a href='listprod.jsp' class='px-6 py-3 text-white bg-gray-700 hover:bg-gray-600 rounded-lg transition duration-300'>Continue Shopping</a>");
                                out.println("</div>");
                                out.println("</div>");
                                out.println("</div>");
                            } else {
                                out.println("<p class='text-gray-900'>Product not found. Please go back to the product list.</p>");
                            }
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p class='text-gray-900'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>

</body>
</html>

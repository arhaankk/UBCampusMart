<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="font-sans bg-white">
    <nav class="bg-white border-gray-200 dark:bg-gray-900">
        <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
            <a href="http://localhost/shop/index.jsp" class="flex items-center space-x-3 rtl:space-x-reverse">
                <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">UBCampusMart</span>
            </a>
            <!-- Other nav items here -->
        </div>
    </nav>

    <%
    String message = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String productName = request.getParameter("productName");
        String productDescription = request.getParameter("productDescription");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("category"));

        String sql = "INSERT INTO product (productName, productDesc, productPrice, categoryId) VALUES (?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, productName);
            pstmt.setString(2, productDescription);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, categoryId);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Product added successfully!";
            } else {
                message = "Failed to add product.";
            }
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }
    }
    %>

    <div class="min-h-screen flex items-start justify-center py-12 px-4">
        <div class="max-w-md w-full">

            <!-- Add Product Form Section -->
            <div class="border border-gray-300 rounded-lg p-6 shadow-lg">
                <form action="addProduct.jsp" method="POST">
                    <div class="mb-8">
                        <h3 class="text-gray-800 text-3xl font-extrabold">Add a Product</h3>
                    </div>

                    <!-- Product Name -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">Product Name</label>
                        <input name="productName" type="text" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>

                    <!-- Price -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">Price</label>
                        <input name="price" type="number" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">Description</label>
                        <input name="productDescription" type="text" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>

                    <!-- Category Dropdown -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">Category</label>
                        <div class="relative">
                            <button id="dropdownButton" type="button" class="block w-full bg-white border border-gray-300 rounded-lg shadow-sm py-3 px-4 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 flex justify-between items-center">
                                <span id="selectedCategory">Select Category</span>
                                <svg class="w-5 h-5 text-gray-500 ml-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </button>

                            <div id="dropdownList" class="absolute w-full bg-white border border-gray-300 rounded-lg shadow-md mt-1 hidden max-h-60 overflow-y-auto z-10">
                                <ul class="py-1 text-sm text-gray-700">
                                    <li class="px-4 py-2 hover:bg-gray-100 cursor-pointer" data-value="">
                                        Select Category
                                    </li>
                                    <% 
                                    try {
                                        String categoryQuery = "SELECT categoryId, categoryName FROM category";
                                        try (Connection con = DriverManager.getConnection(url, uid, pw);
                                             PreparedStatement ps = con.prepareStatement(categoryQuery);
                                             ResultSet rs = ps.executeQuery()) {
                                            while (rs.next()) {
                                                int categoryId = rs.getInt("categoryId");
                                                String categoryName = rs.getString("categoryName");
                                                out.println("<li class='px-4 py-2 hover:bg-gray-100 cursor-pointer' data-value='" + categoryId + "'>" + categoryName + "</li>");
                                            }
                                        }
                                    } catch (SQLException e) {
                                        out.println("<li class='px-4 py-2 text-red-500'>Error loading categories</li>");
                                    }
                                    %>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden Input to Store Category Value -->
                    <input type="hidden" id="categoryInput" name="category" />

                    <!-- Submit Button -->
                    <div class="!mt-8">
                        <button type="submit" class="w-full shadow-xl py-3 px-4 text-sm tracking-wide rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none">Submit</button>
                    </div>
                </form>

                <!-- Display Success/Failure Message -->
                <% if (!message.isEmpty()) { %>
                    <p class="mt-4 text-center font-semibold text-green-500"><%= message %></p>
                <% } %>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownButton = document.getElementById('dropdownButton');
        const dropdownList = document.getElementById('dropdownList');
        const selectedCategory = document.getElementById('selectedCategory');
        const categoryInput = document.getElementById('categoryInput');

        // Show/Hide dropdown list on button click
        dropdownButton.addEventListener('click', function() {
            dropdownList.classList.toggle('hidden');
        });

        // Update the selected category when a list item is clicked
        const categoryItems = dropdownList.querySelectorAll('li');
        categoryItems.forEach(item => {
            item.addEventListener('click', function() {
                const categoryId = this.getAttribute('data-value');
                const categoryName = this.innerText;
                
                selectedCategory.innerText = categoryName;  // Update button text
                categoryInput.value = categoryId;  // Set hidden input value
                dropdownList.classList.add('hidden');  // Hide dropdown after selection
            });
        });
    });
    </script>

</body>
</html>

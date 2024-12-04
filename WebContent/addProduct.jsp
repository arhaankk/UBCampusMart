<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <script src="https://cdn.tailwindcss.com"></script> <!-- Include Tailwind CSS -->
</head>
<body class="font-sans bg-white">
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
                        <a href="addProduct.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Add Product</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Edit Product</a>
                    </li>
                    <li>
                        <a href="loaddata.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Restore DB</a>
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
  <div class="min-h-screen flex items-start justify-center py-12 px-4">
    <div class="max-w-md w-full">

        <!-- Add Product Form Section -->
        <div class="border border-gray-300 rounded-lg p-6 shadow-lg">
            <form class="space-y-4" method="post" action="addProductHandler.jsp" enctype="multipart/form-data">

                <!-- Title and Description -->
                <div class="mb-8">
                    <h3 class="text-gray-800 text-3xl font-extrabold">Add a Product</h3>
                </div>

                <!-- Error Message Display (from session) -->
                <%
                // Only show error message if a login attempt has been made and it failed
                String loginMessage = (String) session.getAttribute("loginMessage");
                if (loginMessage != null) {
                    out.println("<p class='text-red-500 text-sm mt-2'>" + loginMessage + "</p>");
                    // Remove the login message after displaying it
                    session.removeAttribute("loginMessage");
                }
                %>

                <!-- Product Name -->
                <div>
                    <label class="text-gray-800 text-sm mb-2 block">Product Name</label>
                    <div class="relative flex items-center">
                        <input name="product_name" type="text" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>
                </div>

                <!-- Price -->
                <div>
                    <label class="text-gray-800 text-sm mb-2 block">Price</label>
                    <div class="relative flex items-center">
                        <input name="price" type="number" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label class="text-gray-800 text-sm mb-2 block">Description</label>
                    <div class="relative flex items-center">
                        <input name="description" type="text" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>
                </div>

                <!-- Image Upload -->
                <div>
                    <label class="text-gray-800 text-sm mb-2 block">Product Image</label>
                    <div class="relative flex items-center">
                        <input name="product_image" type="file" accept="image/*" class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" />
                    </div>
                </div>

                <!-- Category Dropdown -->
                <div>
                    <label class="text-gray-800 text-sm mb-2 block">Category</label>
                    <div class="relative flex items-center">
                        <select name="categoryId" class="border border-gray-300 p-3 rounded-lg w-full text-sm text-gray-800 outline-blue-600">
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
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="!mt-8">
                    <button type="submit" class="w-full shadow-xl py-3 px-4 text-sm tracking-wide rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none">Submit</button>
                </div>
            </form>
        </div>
    </div>
</div>

    </div>
</div>

    </div>
</div>
        </div>
    </div>

</body>
</html>

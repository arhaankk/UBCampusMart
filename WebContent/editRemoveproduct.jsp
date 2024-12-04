<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit/Remove Products</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
   <!-- Back Button -->
    <a href="admin.jsp" class="absolute top-4 left-4 bg-slate-900 text-white p-2 rounded-full shadow-md hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-slate-600">
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

<div class="max-w-7xl mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-8">Edit or Remove Products</h1>
    
    <table class="min-w-full bg-white border rounded-lg overflow-hidden">
        <thead class="bg-gray-200">
            <tr>
                <th class="px-4 py-2 border">Product ID</th>
                <th class="px-4 py-2 border">Product Name</th>
                <th class="px-4 py-2 border">Price</th>
                <th class="px-4 py-2 border">Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                String query = "SELECT productId, productName, productPrice FROM product";
                try (Connection con = DriverManager.getConnection(url, uid, pw);
                     PreparedStatement ps = con.prepareStatement(query);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        int productId = rs.getInt("productId");
                        String productName = rs.getString("productName");
                        double productPrice = rs.getDouble("productPrice");
            %>
            <tr class="text-center border-b">
                <td class="px-4 py-2 border"><%= productId %></td>
                <td class="px-4 py-2 border"><%= productName %></td>
                <td class="px-4 py-2 border"><%= String.format("$%.2f", productPrice) %></td>
                <td class="px-4 py-2 border">
                    <form action="editRemoveProduct.jsp" method="post" class="inline">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Edit</button>
                    </form>
                    <form action="editRemoveProduct.jsp" method="post" class="inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='4' class='text-red-500'>Error loading products: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>
</div>

<%
    String action = request.getParameter("action");
    String productId = request.getParameter("productId");

    if ("edit".equals(action) && productId != null) {
        // Redirect to an edit page or show edit form
        response.sendRedirect("editProduct.jsp?productId=" + productId);
    }else if ("delete".equals(action) && productId != null) {
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // First, delete the related records in orderproduct
        try (PreparedStatement deleteOrders = con.prepareStatement("DELETE FROM dbo.orderproduct WHERE productId = ?")) {
            deleteOrders.setInt(1, Integer.parseInt(productId));
            deleteOrders.executeUpdate();
        }

        // Now delete the product
        try (PreparedStatement ps = con.prepareStatement("DELETE FROM product WHERE productId = ?")) {
            ps.setInt(1, Integer.parseInt(productId));
            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                out.println("<script>alert('Product deleted successfully!'); window.location.href='editRemoveProduct.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to delete the product.'); window.location.href='editRemoveProduct.jsp';</script>");
            }
        }

    } catch (SQLException e) {
        out.println("<script>alert('Error deleting product: " + e.getMessage().replace("'", "\\'") + "'); window.location.href='editRemoveProduct.jsp';</script>");
    }
}
%>

</body>
</html>

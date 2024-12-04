<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<div class="max-w-7xl mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-8">Edit Product</h1>

    <%
        String productId = request.getParameter("productId");
        String productName = "";
        double productPrice = 0.0;

        if (productId != null) {
            String query = "SELECT productName, productPrice FROM product WHERE productId = ?";
            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 PreparedStatement ps = con.prepareStatement(query)) {
                ps.setInt(1, Integer.parseInt(productId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        productName = rs.getString("productName");
                        productPrice = rs.getDouble("productPrice");
                    }
                }
            } catch (SQLException e) {
                out.println("<div class='text-red-500'>Error fetching product details: " + e.getMessage() + "</div>");
            }
        }
    %>

    <form action="editProduct.jsp" method="post" class="max-w-md mx-auto bg-white p-6 rounded-lg shadow-lg">
        <input type="hidden" name="productId" value="<%= productId %>">
        
        <div class="mb-4">
            <label for="productName" class="block text-lg font-semibold mb-2">Product Name</label>
            <input type="text" name="productName" id="productName" value="<%= productName %>" class="w-full px-4 py-2 border rounded-lg" required>
        </div>

        <div class="mb-4">
            <label for="productPrice" class="block text-lg font-semibold mb-2">Product Price</label>
            <input type="number" name="productPrice" id="productPrice" value="<%= productPrice %>" step="0.01" class="w-full px-4 py-2 border rounded-lg" required>
        </div>

        <div class="mb-4 text-center">
            <button type="submit" name="action" value="update" class="bg-blue-500 text-white px-4 py-2 rounded">Update Product</button>
        </div>
    </form>

    <%
        String action = request.getParameter("action");

        if ("update".equals(action) && productId != null) {
            String updatedName = request.getParameter("productName");
            String updatedPrice = request.getParameter("productPrice");

            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                String updateQuery = "UPDATE product SET productName = ?, productPrice = ? WHERE productId = ?";
                try (PreparedStatement ps = con.prepareStatement(updateQuery)) {
                    ps.setString(1, updatedName);
                    ps.setDouble(2, Double.parseDouble(updatedPrice));
                    ps.setInt(3, Integer.parseInt(productId));

                    int rowsUpdated = ps.executeUpdate();

                    if (rowsUpdated > 0) {
                        out.println("<script>alert('Product updated successfully!'); window.location.href='editRemoveProduct.jsp';</script>");
                    } else {
                        out.println("<script>alert('Failed to update the product.'); window.location.href='editRemoveProduct.jsp';</script>");
                    }
                }
            } catch (SQLException e) {
                out.println("<script>alert('Error updating product: " + e.getMessage().replace("'", "\\'") + "'); window.location.href='editRemoveProduct.jsp';</script>");
            }
        }
    %>
</div>

</body>
</html>

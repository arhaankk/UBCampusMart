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
</head>
<body class="bg-gray-100">

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

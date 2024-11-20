<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%
   // Check if the product ID is present in the request
String productId = request.getParameter("productId");

if (productId == null) {
    out.println("<h3>Error: Product ID not provided. Please try again.</h3>");
    return;
}

// Retrieve the product list from the session
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && productList.containsKey(productId)) {
    // Remove the product from the session cart
    productList.remove(productId);
    session.setAttribute("productList", productList);
    out.println("<h3>Product removed from cart.</h3>");
} else {
    out.println("<h3>Product not found in cart.</h3>");
}

// Check if the orderId is available in the session (if the user has already checked out)
Integer orderId = (Integer) session.getAttribute("orderId");

// If the orderId exists, proceed to delete from the database as well
if (orderId != null) {
    // Proceed with database deletion since the order is finalized
    Connection con = null;
    PreparedStatement stmt = null;
    try {
        con = DriverManager.getConnection(url, uid, pw);
        String sql = "DELETE FROM incart WHERE orderId = ? AND productId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, orderId);
        stmt.setInt(2, Integer.parseInt(productId));
        
        if (stmt.executeUpdate() > 0) {
            out.println("<h3>Product removed from database (cart confirmed).</h3>");
        } else {
            out.println("<h3>Error: Could not remove product from the database.</h3>");
        }
    } catch (SQLException e) {
        out.println("<h3>Database error: " + e.getMessage() + "</h3>");
    } finally {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
} else {
    out.println("<h3>No order ID found. Product removed from cart, but not from the database (order not finalized).</h3>");
}

// Redirect back to the cart page or display the updated cart
response.sendRedirect("showcart.jsp");
%>
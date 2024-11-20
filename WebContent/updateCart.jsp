<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>

<%
    // Retrieve parameters
    String productId = request.getParameter("productId");
    String quantity = request.getParameter("quantity");

    // Get the current product list from session
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList =
        (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    // Safely retrieve and handle orderId from session
    Object orderIdObj = session.getAttribute("orderId");
    int orderId = 0;

    if (orderIdObj != null) {
        orderId = (int) orderIdObj;
    } else {
        out.println("Order ID is not set in the session.");
        // Optional: Redirect or handle error
    }

    // Check if the product exists and update its quantity
    if (productList != null && productList.containsKey(productId)) {
        ArrayList<Object> product = productList.get(productId);
        product.set(3, Integer.parseInt(quantity)); // Update quantity in session
        productList.put(productId, product);
        session.setAttribute("productList", productList);
    }

    // Redirect to the cart page
    response.sendRedirect("showcart.jsp");
%>

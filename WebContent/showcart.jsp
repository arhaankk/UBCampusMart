<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fc;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h1, h2 {
            color: #3b4a67;
            text-align: center;
        }
		header h2 {
    color: white;
}

        .container {
            width: 80%;
            margin: 20px auto;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #3b4a67;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        td input[type="number"] {
            width: 50px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        td button {
            padding: 6px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        td button:hover {
            background-color: #45a049;
        }

        .total-row {
            font-weight: bold;
            background-color: #f0f0f0;
        }

        .checkout-btn {
            display: block;
            width: 200px;
            margin: 30px auto;
            padding: 10px;
            text-align: center;
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-size: 18px;
        }

        .checkout-btn:hover {
            background-color: #218838;
        }

        .continue-shopping {
            text-align: center;
            margin-top: 20px;
        }

        .continue-shopping a {
            color: #007bff;
            text-decoration: none;
            font-size: 18px;
        }

        .continue-shopping a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    <div style="text-align: center; padding: 20px; background-color: #3b4a67; color: white;">
        <h2>Welcome to Soumil's Grocery Store</h2>
        <nav>
            <a href="listprod.jsp" style="margin: 10px; color: white; text-decoration: none;">Products</a>
            <a href="listorder.jsp" style="margin: 10px; color: white; text-decoration: none;">Order List</a>
            <a href="showcart.jsp" style="margin: 10px; color: white; text-decoration: none;">Shopping Cart</a>
        </nav>
    </div>
</header>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {
    out.println("<h1>Your shopping cart is empty!</h1>");
    productList = new HashMap<String, ArrayList<Object>>();
} else {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>

<div class="container">
    <h1>Your Shopping Cart</h1>
    <table>
        <thead>
            <tr>
                <th>Product Id</th>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                if (product.size() < 4) {
                    out.println("Expected product with four entries. Got: " + product);
                    continue;
                }

                String productId = (String) product.get(0);
                String productName = (String) product.get(1);
                double price = Double.parseDouble(product.get(2).toString());
                int quantity = Integer.parseInt(product.get(3).toString());
            %>
            <tr>
                <td><%= productId %></td>
                <td><%= productName %></td>
                <td align="center">
                    <form method="post" action="updateCart.jsp">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <input type="number" name="quantity" value="<%= quantity %>" min="1">
                        <button type="submit">Update</button>
                    </form>
                </td>
                <td align="right"><%= currFormat.format(price) %></td>
                <td align="right"><%= currFormat.format(price * quantity) %></td>
                <td>
                    <form method="post" action="deleteFromCart.jsp">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <button type="submit">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                total += price * quantity;
            }
            %>
            <tr class="total-row">
                <td colspan="4" align="right">Order Total</td>
                <td align="right"><%= currFormat.format(total) %></td>
                <td></td>
            </tr>
        </tbody>
    </table>

    <a href="checkout.jsp" class="checkout-btn">Check Out</a>
</div>

<div class="continue-shopping">
    <h2><a href="listprod.jsp">Continue Shopping</a></h2>
</div>

<% } %>

</body>
</html>

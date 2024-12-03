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
    <title >Your Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.0.0/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 ">

<nav class="bg-gray-900 border-gray-200">
    <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
        <a href="http://localhost/shop/index.jsp" class="flex items-center space-x-3 rtl:space-x-reverse">
            <span class="self-center text-2xl font-semibold whitespace-nowrap text-white">UBCampusMart</span>
        </a>
        <button data-collapse-toggle="navbar-default" type="button" class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600" aria-controls="navbar-default" aria-expanded="false">
            <span class="sr-only">Open main menu</span>
            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
            </svg>
        </button>
        <div class="hidden w-full md:block md:w-auto" id="navbar-default">
            <ul class="font-medium flex flex-col p-4 md:p-0 mt-4 border border-gray-100 rounded-lg bg-gray-50 md:flex-row md:space-x-8 rtl:space-x-reverse md:mt-0 md:border-0 md:bg-gray-900 dark:border-gray-700">
                <!-- Other menu items -->
                <li>
                    <a href="listprod.jsp" class="block py-2 px-3 text-white rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-400 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Products</a>
                </li>
                <li>
                    <a href="listorder.jsp" class="block py-2 px-3 text-white rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-400 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Order List</a>
                </li>
                <li>
                    <a href="showcart.jsp" class="block py-2 px-3 text-white rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-400 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Shopping Cart</a>
                </li>
                <li class="ml-auto">
                    <% 
                        String username = (String) session.getAttribute("authenticatedUser");
                        if (username != null) {
                    %>
                        <a href="customer.jsp" class="block py-2 px-3 text-white rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-400 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Welcome back, <%= username %></a>
                    <% } %>
                </li>
            </ul>
        </div>
    </div>
</nav>




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

<div class="container mx-auto bg-white p-8 shadow-lg rounded-lg mt-8">
    <h1 class="text-3xl text-center mb-6 font-bold">Your Shopping Cart</h1>
    <table class="min-w-full table-auto">
        <thead>
            <tr class="bg-gray-900 text-white">
                <th class="px-4 py-2 text-left">Product Id</th>
                <th class="px-4 py-2 text-left">Product Name</th>
                <th class="px-4 py-2 text-center">Quantity</th>
                <th class="px-4 py-2 text-right">Price</th>
                <th class="px-4 py-2 text-right">Subtotal</th>
                <th class="px-4 py-2">Action</th>
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
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-2"><%= productId %></td>
                <td class="px-4 py-2"><%= productName %></td>
                <td class="px-4 py-2 text-center">
                    <form method="post" action="updateCart.jsp">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <input type="number" name="quantity" value="<%= quantity %>" min="1" class="w-16 px-2 py-1 border border-gray-300 rounded-md text-center">
                        <button type="submit" class="mt-1 px-4 py-2 bg-green-700 text-white rounded-md hover:bg-green-800">Update</button>
                    </form>
                </td>
                <td class="px-4 py-2 text-right"><%= currFormat.format(price) %></td>
                <td class="px-4 py-2 text-right"><%= currFormat.format(price * quantity) %></td>
                <td class="px-4 py-2">
                    <form method="post" action="deleteFromCart.jsp">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <button type="submit" class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                total += price * quantity;
            }
            %>
            <tr class="bg-gray-100 font-bold">
                <td colspan="4" class="px-4 py-2 text-right">Order Total</td>
                <td class="px-4 py-2 text-right"><%= currFormat.format(total) %></td>
                <td></td>
            </tr>
        </tbody>
    </table>

    <a href="checkout.jsp" class="block mt-6 text-center py-2 px-6 bg-green-700 text-white rounded-md hover:bg-green-800 w-auto">Check Out</a>

</div>

<div class="text-center mt-8">
    <h2><a href="listprod.jsp" class="text-blue-500 hover:underline text-lg">Continue Shopping</a></h2>
</div>

<% } %>

</body>
</html>

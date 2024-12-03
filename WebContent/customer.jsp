<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ include file="jdbc.jsp" %>

<%
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("authenticatedUser");

    // If the user is not logged in, redirect before anything is rendered
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;  // Stop further execution to avoid sending response after redirect
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Page</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="text-gray-100">

    <!-- Back Button -->
    <button 
        class="absolute top-2 left-4 p-2 text-2xl text-white"
        onclick="window.location.href='listprod.jsp';">
        &#8592;  <!-- Unicode Left Arrow -->
    </button>

    <!-- Header -->
    <header class="bg-gray-900 text-white py-6 text-center text-3xl font-bold">
        Customer Page
    </header>

    <!-- Main Content -->
    <main class="px-6 md:px-12 py-4">
        <%
            // SQL query to retrieve customer information by username (assuming username is the customer id)
            String sql = "SELECT * FROM customer WHERE userid = ?"; 

            try {
                getConnection();  
                PreparedStatement ps = con.prepareStatement(sql); 
                ps.setString(1, loggedInUser);  
                ResultSet rs = ps.executeQuery();

                // If a customer record is found, display it
                if (rs.next()) {
                    out.println("<h2 class='text-center text-2xl font-semibold text-white mt-6'>Customer Information</h2>");
                    out.println("<div class='relative overflow-x-auto shadow-md sm:rounded-lg mx-auto max-w-4xl'>");
                    out.println("<table class='w-full text-sm text-left text-gray-500 bg-white'>");
                    out.println("<thead class='text-xs text-white uppercase bg-gray-800'>");
                    out.println("<tr>");
                    out.println("<th scope='col' class='px-6 py-3'>Field</th>");
                    out.println("<th scope='col' class='px-6 py-3'>Value</th>");
                    out.println("</tr>");
                    out.println("</thead>");
                    out.println("<tbody>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "ID" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("customerId") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "First Name" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("firstName") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Last Name" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("lastName") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Email" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("email") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Phone" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("phonenum") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Address" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("address") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "City" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("city") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "State" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("state") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Postal Code" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("postalCode") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "Country" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("country") + "</td>");
                    out.println("</tr>");
                    out.println("<tr class='bg-white border-b hover:bg-gray-100'>");
                    out.println("<th scope='row' class='px-6 py-4 font-medium text-gray-900 whitespace-nowrap'>" + "User ID" + "</th>");
                    out.println("<td class='px-6 py-4'>" + rs.getString("userid") + "</td>");
                    out.println("</tr>");
                    out.println("</tbody>");
                    out.println("</table>");
                    out.println("</div>");
                } else {
                    out.println("<p class='text-center text-red-600 mt-4'>No customer found with the username: " + loggedInUser + "</p>");
                }

            } catch (SQLException e) {
                out.println("<p class='text-center text-red-600 mt-4'>Error fetching customer data: " + e.getMessage() + "</p>");
            } finally {
                closeConnection();  
            }
        %>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white text-center py-4">
        &copy; 2024 UBCampusMart. All rights reserved.
    </footer>

</body>
</html>

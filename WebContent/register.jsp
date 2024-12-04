<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Shopping App</title>
    <script src="https://cdn.tailwindcss.com"></script>
     <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script>
        function validateForm() {
            const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const phonePattern = /^[0-9]{10}$/;
            const postalCodePattern = /^[A-Za-z0-9\s]{3,10}$/;

            const firstName = document.forms["registerForm"]["firstName"].value;
            const lastName = document.forms["registerForm"]["lastName"].value;
            const email = document.forms["registerForm"]["email"].value;
            const phonenum = document.forms["registerForm"]["phonenum"].value;
            const postalCode = document.forms["registerForm"]["postalCode"].value;
            const password = document.forms["registerForm"]["password"].value;

            if (firstName.length < 2 || lastName.length < 2) {
                alert("First Name and Last Name must be at least 2 characters long.");
                return false;
            }

            if (!emailPattern.test(email)) {
                alert("Please enter a valid email address.");
                return false;
            }

            if (!phonePattern.test(phonenum)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            if (!postalCodePattern.test(postalCode)) {
                alert("Please enter a valid postal code.");
                return false;
            }

            if (password.length < 6) {
                alert("Password must be at least 6 characters long.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body class="bg-gray-100 font-sans">
<!-- Back Button -->
    <a href="login.jsp" class="absolute top-4 left-4 bg-slate-900 text-white p-2 rounded-full shadow-md hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-slate-600">
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

<div class="min-h-screen flex items-center justify-center py-6 px-4">
    <div class="max-w-lg w-full bg-white p-6 rounded-lg shadow-md">
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Register</h2>
        
        <form name="registerForm" method="post" action="register.jsp" class="space-y-4" onsubmit="return validateForm()">
            <!-- First Name -->
            <div>
                <label class="block text-sm text-gray-700">First Name</label>
                <input type="text" name="firstName" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your first name">
            </div>

            <!-- Last Name -->
            <div>
                <label class="block text-sm text-gray-700">Last Name</label>
                <input type="text" name="lastName" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your last name">
            </div>

            <!-- Email -->
            <div>
                <label class="block text-sm text-gray-700">Email</label>
                <input type="email" name="email" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your email">
            </div>

            <!-- Phone Number -->
            <div>
                <label class="block text-sm text-gray-700">Phone Number</label>
                <input type="text" name="phonenum" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your phone number">
            </div>

            <!-- Address -->
            <div>
                <label class="block text-sm text-gray-700">Address</label>
                <input type="text" name="address" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your address">
            </div>

            <!-- City -->
            <div>
                <label class="block text-sm text-gray-700">City</label>
                <input type="text" name="city" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your city">
            </div>

            <!-- State -->
            <div>
                <label class="block text-sm text-gray-700">State</label>
                <input type="text" name="state" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your state">
            </div>

            <!-- Postal Code -->
            <div>
                <label class="block text-sm text-gray-700">Postal Code</label>
                <input type="text" name="postalCode" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your postal code">
            </div>

            <!-- Country -->
            <div>
                <label class="block text-sm text-gray-700">Country</label>
                <input type="text" name="country" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Enter your country">
            </div>

            <!-- Username -->
            <div>
                <label class="block text-sm text-gray-700">Username</label>
                <input type="text" name="userid" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Choose a username">
            </div>

            <!-- Password -->
            <div>
                <label class="block text-sm text-gray-700">Password</label>
                <input type="password" name="password" required class="w-full px-4 py-3 border rounded-lg text-gray-800" placeholder="Choose a password">
            </div>

            <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700">Register</button>
        </form>


        <!-- Backend logic -->
        <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phonenum = request.getParameter("phonenum");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String country = request.getParameter("country");
            String userid = request.getParameter("userid");
            String password = request.getParameter("password");
            
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DriverManager.getConnection(url, uid, pw);
                String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, isAdmin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'false')";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, phonenum);
                stmt.setString(5, address);
                stmt.setString(6, city);
                stmt.setString(7, state);
                stmt.setString(8, postalCode);
                stmt.setString(9, country);
                stmt.setString(10, userid);
                stmt.setString(11, password);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<p class='text-green-500 text-sm mt-2'>Registration successful! You can now <a href='login.jsp' class='text-blue-600 underline'>log in</a>.</p>");
                }
            } catch (SQLException e) {
                out.println("<p class='text-red-500 text-sm mt-2'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        }
        %>
    </div>
</div>

</body>
</html>

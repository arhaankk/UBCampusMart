<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart Main Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #2c3e50;
        }
        .button-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
            margin-top: 20px;
        }
        .button-container a {
            padding: 10px 20px;
            font-size: 18px;
            text-decoration: none;
            background-color: #3498db;
            color: white;
            border-radius: 4px;
            transition: background-color 0.3s, transform 0.3s;
        }
        .button-container a:hover {
            background-color: #2980b9;
            transform: scale(1.05);
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
        }
        .footer h3 {
            color: #2c3e50;
        }
        .test-links {
            margin-top: 20px;
            text-align: center;
        }
        .test-links h4 {
            font-size: 16px;
        }
        .test-links a {
            color: #3498db;
            text-decoration: none;
            font-size: 16px;
        }
        .test-links a:hover {
            color: #2980b9;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Welcome to UBCampusMart</h1>

        <div class="button-container">
            <a href="login.jsp">Login</a>
            <a href="listprod.jsp">Begin Shopping</a>
            <a href="listorder.jsp">List All Orders</a>
            <a href="customer.jsp">Customer Info</a>
            <a href="admin.jsp">Administrators</a>
            <a href="logout.jsp">Log out</a>
        </div>

        <% String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) {
            out.println("<div class=\"footer\"><h3>Signed in as: " + userName + "</h3></div>");
        }
        %>

        <div class="test-links">
            <h4><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>
            <h4><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>
        </div>
    </div>

</body>
</html>

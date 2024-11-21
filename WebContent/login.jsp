<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
            height: 100vh; /* Full viewport height */
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: center; /* Center vertically */
        }
        .container {
            width: 400px;
            padding: 40px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h3 {
            color: #2c3e50;
            margin-bottom: 30px;
        }
        p {
            color: #e74c3c;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        label {
            font-size: 16px;
            color: #2c3e50;
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="password"] {
            padding: 10px;
            width: 100%;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .submit-btn {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
            transition: background-color 0.3s, transform 0.3s;
        }
        .submit-btn:hover {
            background-color: #2980b9;
            transform: scale(1.05);
        }
    </style>
</head>
<body>

    <div class="container">
        <h3>Please Login to System</h3>

        <% 
        // Only show error message if a login attempt has been made and it failed
        String loginMessage = (String) session.getAttribute("loginMessage");
        if (loginMessage != null) {
            out.println("<p>" + loginMessage + "</p>");
            // Remove the login message after displaying it
            session.removeAttribute("loginMessage");
        }
        %>

        <form name="MyForm" method="post" action="validateLogin.jsp">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" name="username" id="username" size="10" maxlength="10" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" name="password" id="password" size="10" maxlength="10" required>
            </div>
            <input class="submit-btn" type="submit" name="Submit2" value="Log In">
        </form>
    </div>

</body>
</html>

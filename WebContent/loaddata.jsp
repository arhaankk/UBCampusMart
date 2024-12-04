<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loading Data</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white text-gray-900 font-sans">

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
                    <!-- Other menu items -->
                    <li>
                        <a href="listprod.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Products</a>
                    </li>
                    <li>
                        <a href="listorder.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Order History</a>
                    </li>
                    <li>
                        <a href="showcart.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Shopping Cart</a>
                    </li>
                     <li class="ml-auto">
                    <% 
                        String username = (String) session.getAttribute("authenticatedUser");
                        if (username != null) {
                    %>
                        <a href="customer.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Welcome back, <%= username %></a>
                    <% } %>
                </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mx-auto px-4 py-6">
        <h1 class="text-3xl font-semibold mb-6 text-center">Connecting to database...</h1>

        <%
        out.print("<h2 class='text-lg font-medium mb-4 text-center'>Connecting to database.</h2>");
        
        try {
            // Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            throw new SQLException("ClassNotFoundException: " +e);
        }

        String fileName = "/usr/local/tomcat/webapps/shop/ddl/SQLServer_orderdb.ddl";

        try ( Connection con = DriverManager.getConnection(urlForLoadData, uid, pw); ) {
            // Create statement
            Statement stmt = con.createStatement();
            
            Scanner scanner = new Scanner(new File(fileName));
            // Read commands separated by ;
            scanner.useDelimiter(";");
            while (scanner.hasNext()) {
                String command = scanner.next();
                if (command.trim().equals("") || command.trim().equals("go"))
                    continue;
                
                if (command.trim().indexOf("go") == 0)
                    command = command.substring(3, command.length());

                // Hack to make sure variable is declared
                if (command.contains("INSERT INTO ordersummary") && !command.contains("DECLARE @orderId"))
                    command = "DECLARE @orderId int \n"+command;

                out.print(command+"<br>");  // Uncomment if want to see commands executed
                try {
                    stmt.execute(command);
                } catch (Exception e) {
                    // Keep running on exception. This is mostly for DROP TABLE if table does not exist.
                    if (!e.toString().contains("Database 'orders' already exists"))  // Ignore error when database already exists
                        out.println(e+"<br>");
                }
            }     
            scanner.close();

            out.print("<br><br><h1 class='text-3xl font-semibold text-center'>Database loaded successfully.</h1>");
        } catch (Exception e) {
            out.print("<h2 class='text-lg font-medium text-center text-red-500'>"+e+"</h2>");
        }
        %>
    </div>
    
</body>
</html>

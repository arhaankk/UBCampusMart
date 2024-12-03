<%@ page language="java" import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<%
    String authenticatedUser = null;
    session = request.getSession(true);  // Start a new session or get the existing session

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println("Error validating login: " + e.getMessage());
    }

    // Redirect to the appropriate page based on the login status
    if (authenticatedUser != null) {
        response.sendRedirect("listprod.jsp");  // Successful login, redirect to the main page
    } else {
        response.sendRedirect("login.jsp");  // Failed login, redirect back to the login page
    }
%>

<%!
    // Method to validate user login credentials
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        // Validate input parameters (check for null or empty values)
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            session.setAttribute("loginMessage", "Username and password cannot be empty.");
            return null;
        }

        try {
            getConnection();  // Establish a connection to the database

            // SQL query to check if the username and password match in the customer table
            String sql = "SELECT userid, password FROM customer WHERE userid = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            // If a matching record is found, the login is successful
            if (rs.next()) {
                retStr = username;  // Login successful, return the username
            }
        } catch (SQLException ex) {
            out.println("Error: " + ex.getMessage());  // Print any SQL errors
        } finally {
            closeConnection();  // Close the database connection
        }

        // If login is successful, remove the error message from the session
        if (retStr != null) {
            session.removeAttribute("loginMessage");  // Clear any previous login error message
            session.setAttribute("authenticatedUser", username);  // Store the authenticated user in the session
        } else {
            session.setAttribute("loginMessage", "Invalid username or password.");  // Set an error message for invalid login
        }

        return retStr;
    }
%>

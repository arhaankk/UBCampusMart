<%@ page language="java" import="java.io.*, java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println(e);
    }

    if (authenticatedUser != null)
        response.sendRedirect("index.jsp"); // Successful login
    else
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message 
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        try {
            getConnection();
            // SQL query to check if the username and password match
            String sql = "SELECT username FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                retStr = username; // Successful login
            }
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection(); // Close the connection
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Invalid username or password.");
        }

        return retStr;
    }
%>

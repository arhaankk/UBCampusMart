<%@ page import="java.sql.*, java.io.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve form data
    String productName = request.getParameter("product_name");
    String priceString = request.getParameter("price");
    String description = request.getParameter("description");
    Part productImagePart = request.getPart("product_image");
    String categoryIdString = request.getParameter("categoryId");

    // Convert price string to decimal value
    double price = 0.0;
    out.println("<p class='text-red-500'>Price is required. "+description+"</p>");
    if (priceString == null || priceString.trim().isEmpty()) {
        out.println("<p class='text-red-500'>Price is required. Please enter a valid price.</p>");
        return;
    }
    try {
        price = Double.parseDouble(priceString);
    } catch (NumberFormatException e) {
        out.println("<p class='text-red-500'>Invalid price format. Please enter a valid number.</p>");
        return;
    }

    // Prepare product image file (if uploaded)
    String productImageFileName = null;
    if (productImagePart != null && productImagePart.getSize() > 0) {
        productImageFileName = productImagePart.getSubmittedFileName();
        String uploadDirectory = application.getRealPath("/") + "../uploads/";
        File uploadDir = new File(uploadDirectory);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String filePath = uploadDirectory + productImageFileName;

        // Save the image to the server
        try (InputStream inputStream = productImagePart.getInputStream()) {
            try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (IOException e) {
            out.println("<p class='text-red-500'>Error uploading the image. Please try again.</p>");
            return;
        }
    }

    // Prepare SQL statement for inserting product data
    Connection con = null;
    PreparedStatement ps = null;
    try {
        con = DriverManager.getConnection(url, uid, pw);
        String insertQuery = "INSERT INTO product (productName, price, description, productImage, categoryId) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(insertQuery);
        ps.setString(1, productName);
        ps.setDouble(2, price);
        ps.setString(3, description);
        ps.setString(4, productImageFileName);
        ps.setInt(5, Integer.parseInt(categoryIdString));

        // Execute insert
        int rowsInserted = ps.executeUpdate();
        if (rowsInserted > 0) {
            out.println("<p class='text-green-500'>Product added successfully!</p>");
        } else {
            out.println("<p class='text-red-500'>Failed to add the product. Please try again.</p>");
        }
    } catch (SQLException e) {
        out.println("<p class='text-red-500'>Database error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>


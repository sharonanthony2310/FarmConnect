package com.mycompany.farmconnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("farmconnect")
public class FarmConnectResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getText() {
        return "Welcome to FarmConnect REST API";
    }

    @POST
    @Path("users/register")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.TEXT_PLAIN)
    public Response registerUser(
            @javax.ws.rs.FormParam("name") String name,
            @javax.ws.rs.FormParam("email") String email,
            @javax.ws.rs.FormParam("password") String password,
            @javax.ws.rs.FormParam("phone") String phone,
            @javax.ws.rs.FormParam("address") String address,
            @javax.ws.rs.FormParam("role") String role) {

        String sql = "INSERT INTO users "
                + "(name, email, password, phone, address, role) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, role.toUpperCase());

            ps.executeUpdate();

            return Response.ok("User registered successfully").build();

        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Registration failed: " + e.getMessage())
                    .build();
        }
    }
    @POST
@Path("users/login")
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
@Produces(MediaType.TEXT_PLAIN)
public Response loginUser(
        @javax.ws.rs.FormParam("email") String email,
        @javax.ws.rs.FormParam("password") String password) {

    String sql = "SELECT user_id, name, role FROM users "
            + "WHERE email = ? AND password = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            String message = "Login successful! "
                    + "User ID: " + rs.getInt("user_id")
                    + ", Name: " + rs.getString("name")
                    + ", Role: " + rs.getString("role");

            return Response.ok(message).build();

        } else {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("Invalid email or password")
                    .build();
        }

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Login failed: " + e.getMessage())
                .build();
    }
}
@POST
@Path("products")
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
@Produces(MediaType.TEXT_PLAIN)
public Response addProduct(
        @javax.ws.rs.FormParam("farmer_id") int farmerId,
        @javax.ws.rs.FormParam("product_name") String productName,
        @javax.ws.rs.FormParam("category") String category,
        @javax.ws.rs.FormParam("description") String description,
        @javax.ws.rs.FormParam("price") double price,
        @javax.ws.rs.FormParam("quantity") double quantity,
        @javax.ws.rs.FormParam("unit") String unit) {

    String sql = "INSERT INTO products "
            + "(farmer_id, product_name, category, description, price, quantity, unit) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, farmerId);
        ps.setString(2, productName);
        ps.setString(3, category);
        ps.setString(4, description);
        ps.setDouble(5, price);
        ps.setDouble(6, quantity);
        ps.setString(7, unit);

        ps.executeUpdate();

        return Response.ok("Product added successfully").build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Product addition failed: " + e.getMessage())
                .build();
    }
}
@GET
@Path("products")
@Produces(MediaType.TEXT_PLAIN)
public Response getProducts() {

    String sql = "SELECT product_id, farmer_id, product_name, "
            + "category, description, price, quantity, unit FROM products";

    StringBuilder result = new StringBuilder();

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            result.append("Product ID: ")
                    .append(rs.getInt("product_id"))
                    .append("\n");

            result.append("Farmer ID: ")
                    .append(rs.getInt("farmer_id"))
                    .append("\n");

            result.append("Product: ")
                    .append(rs.getString("product_name"))
                    .append("\n");

            result.append("Category: ")
                    .append(rs.getString("category"))
                    .append("\n");

            result.append("Description: ")
                    .append(rs.getString("description"))
                    .append("\n");

            result.append("Price: ₹")
                    .append(rs.getDouble("price"))
                    .append("\n");

            result.append("Quantity: ")
                    .append(rs.getDouble("quantity"))
                    .append(" ")
                    .append(rs.getString("unit"))
                    .append("\n");

            result.append("-------------------------\n");
        }

        if (result.length() == 0) {
            return Response.ok("No products available").build();
        }

        return Response.ok(result.toString()).build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Could not retrieve products: " + e.getMessage())
                .build();
    }
}
@GET
@Path("products/{id}")
@Produces(MediaType.TEXT_PLAIN)
public Response getProductById(
        @javax.ws.rs.PathParam("id") int productId) {

    String sql = "SELECT product_id, farmer_id, product_name, "
            + "category, description, price, quantity, unit "
            + "FROM products WHERE product_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, productId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            String result =
                    "Product ID: " + rs.getInt("product_id") + "\n"
                    + "Farmer ID: " + rs.getInt("farmer_id") + "\n"
                    + "Product: " + rs.getString("product_name") + "\n"
                    + "Category: " + rs.getString("category") + "\n"
                    + "Description: " + rs.getString("description") + "\n"
                    + "Price: ₹" + rs.getDouble("price") + "\n"
                    + "Quantity: " + rs.getDouble("quantity")
                    + " " + rs.getString("unit");

            return Response.ok(result).build();

        } else {

            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Product not found")
                    .build();
        }

    } catch (Exception e) {

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Could not retrieve product: " + e.getMessage())
                .build();
    }
}
@GET
@Path("products/search/{name}")
@Produces(MediaType.TEXT_PLAIN)
public Response searchProduct(
        @javax.ws.rs.PathParam("name") String productName) {

    String sql = "SELECT product_id, farmer_id, product_name, "
            + "category, description, price, quantity, unit "
            + "FROM products WHERE product_name LIKE ?";

    StringBuilder result = new StringBuilder();

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, "%" + productName + "%");

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            result.append("Product ID: ")
                    .append(rs.getInt("product_id"))
                    .append("\n");

            result.append("Farmer ID: ")
                    .append(rs.getInt("farmer_id"))
                    .append("\n");

            result.append("Product: ")
                    .append(rs.getString("product_name"))
                    .append("\n");

            result.append("Category: ")
                    .append(rs.getString("category"))
                    .append("\n");

            result.append("Description: ")
                    .append(rs.getString("description"))
                    .append("\n");

            result.append("Price: ₹")
                    .append(rs.getDouble("price"))
                    .append("\n");

            result.append("Quantity: ")
                    .append(rs.getDouble("quantity"))
                    .append(" ")
                    .append(rs.getString("unit"))
                    .append("\n");

            result.append("-------------------------\n");
        }

        if (result.length() == 0) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("No matching products found")
                    .build();
        }

        return Response.ok(result.toString()).build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Search failed: " + e.getMessage())
                .build();
    }
}
@PUT
@Path("products/{id}")
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
@Produces(MediaType.TEXT_PLAIN)
public Response updateProduct(
        @PathParam("id") int productId,
        @javax.ws.rs.FormParam("product_name") String productName,
        @javax.ws.rs.FormParam("category") String category,
        @javax.ws.rs.FormParam("description") String description,
        @javax.ws.rs.FormParam("price") double price,
        @javax.ws.rs.FormParam("quantity") double quantity,
        @javax.ws.rs.FormParam("unit") String unit) {

    String sql = "UPDATE products SET product_name = ?, "
            + "category = ?, description = ?, price = ?, "
            + "quantity = ?, unit = ? WHERE product_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, productName);
        ps.setString(2, category);
        ps.setString(3, description);
        ps.setDouble(4, price);
        ps.setDouble(5, quantity);
        ps.setString(6, unit);
        ps.setInt(7, productId);

        int rows = ps.executeUpdate();

        if (rows == 0) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Product not found")
                    .build();
        }

        return Response.ok("Product updated successfully").build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Product update failed: " + e.getMessage())
                .build();
    }
}
@DELETE
@Path("products/{id}")
@Produces(MediaType.TEXT_PLAIN)
public Response deleteProduct(
        @PathParam("id") int productId) {

    String sql = "DELETE FROM products WHERE product_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, productId);

        int rows = ps.executeUpdate();

        if (rows == 0) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Product not found")
                    .build();
        }

        return Response.ok("Product deleted successfully").build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Product deletion failed: " + e.getMessage())
                .build();
    }
}
@POST
@Path("orders")
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
@Produces(MediaType.TEXT_PLAIN)
public Response placeOrder(
        @javax.ws.rs.FormParam("buyer_id") int buyerId,
        @javax.ws.rs.FormParam("product_id") int productId,
        @javax.ws.rs.FormParam("quantity") double quantity) {

    Connection con = null;

    try {
        con = DBConnection.getConnection();
        con.setAutoCommit(false);

        String productSql =
                "SELECT price, quantity FROM products WHERE product_id = ?";

        PreparedStatement productPs =
                con.prepareStatement(productSql);

        productPs.setInt(1, productId);

        ResultSet rs = productPs.executeQuery();

        if (!rs.next()) {
            con.rollback();

            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Product not found")
                    .build();
        }

        double price = rs.getDouble("price");
        double availableQuantity = rs.getDouble("quantity");

        if (quantity <= 0) {
            con.rollback();

            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Quantity must be greater than zero")
                    .build();
        }

        if (quantity > availableQuantity) {
            con.rollback();

            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Insufficient product quantity")
                    .build();
        }

        double totalAmount = price * quantity;

        String orderSql =
                "INSERT INTO orders (buyer_id, total_amount, status) "
                + "VALUES (?, ?, 'PENDING')";

        PreparedStatement orderPs =
                con.prepareStatement(
                        orderSql,
                        java.sql.Statement.RETURN_GENERATED_KEYS);

        orderPs.setInt(1, buyerId);
        orderPs.setDouble(2, totalAmount);

        orderPs.executeUpdate();

        ResultSet generatedKeys = orderPs.getGeneratedKeys();

        int orderId = 0;

        if (generatedKeys.next()) {
            orderId = generatedKeys.getInt(1);
        }

        String itemSql =
                "INSERT INTO order_items "
                + "(order_id, product_id, quantity, price) "
                + "VALUES (?, ?, ?, ?)";

        PreparedStatement itemPs =
                con.prepareStatement(itemSql);

        itemPs.setInt(1, orderId);
        itemPs.setInt(2, productId);
        itemPs.setDouble(3, quantity);
        itemPs.setDouble(4, price);

        itemPs.executeUpdate();

        String updateProductSql =
                "UPDATE products SET quantity = quantity - ? "
                + "WHERE product_id = ?";

        PreparedStatement updatePs =
                con.prepareStatement(updateProductSql);

        updatePs.setDouble(1, quantity);
        updatePs.setInt(2, productId);

        updatePs.executeUpdate();

        con.commit();

        return Response.ok(
                "Order placed successfully. "
                + "Order ID: " + orderId
                + ", Total Amount: ₹" + totalAmount)
                .build();

    } catch (Exception e) {

        try {
            if (con != null) {
                con.rollback();
            }
        } catch (Exception ignored) {
        }

        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Order failed: " + e.getMessage())
                .build();

    } finally {

        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception ignored) {
        }
    }
}
@GET
@Path("orders/buyer/{id}")
@Produces(MediaType.TEXT_PLAIN)
public Response getBuyerOrders(
        @PathParam("id") int buyerId) {

    String sql =
            "SELECT o.order_id, o.order_date, "
            + "o.total_amount, o.status, "
            + "p.product_name, oi.quantity, oi.price "
            + "FROM orders o "
            + "JOIN order_items oi ON o.order_id = oi.order_id "
            + "JOIN products p ON oi.product_id = p.product_id "
            + "WHERE o.buyer_id = ? "
            + "ORDER BY o.order_date DESC";

    StringBuilder result = new StringBuilder();

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, buyerId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            result.append("Order ID: ")
                    .append(rs.getInt("order_id"))
                    .append("\n");

            result.append("Date: ")
                    .append(rs.getTimestamp("order_date"))
                    .append("\n");

            result.append("Product: ")
                    .append(rs.getString("product_name"))
                    .append("\n");

            result.append("Quantity: ")
                    .append(rs.getDouble("quantity"))
                    .append("\n");

            result.append("Price: ₹")
                    .append(rs.getDouble("price"))
                    .append("\n");

            result.append("Total Amount: ₹")
                    .append(rs.getDouble("total_amount"))
                    .append("\n");

            result.append("Status: ")
                    .append(rs.getString("status"))
                    .append("\n");

            result.append("-------------------------\n");
        }

        if (result.length() == 0) {
            return Response.ok("No orders found").build();
        }

        return Response.ok(result.toString()).build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Could not retrieve orders: "
                        + e.getMessage())
                .build();
    }
}
@GET
@Path("orders/farmer/{id}")
@Produces(MediaType.TEXT_PLAIN)
public Response getFarmerOrders(
        @PathParam("id") int farmerId) {

    String sql =
            "SELECT o.order_id, o.order_date, "
            + "o.total_amount, o.status, "
            + "p.product_name, oi.quantity, oi.price, "
            + "o.buyer_id "
            + "FROM orders o "
            + "JOIN order_items oi ON o.order_id = oi.order_id "
            + "JOIN products p ON oi.product_id = p.product_id "
            + "WHERE p.farmer_id = ? "
            + "ORDER BY o.order_date DESC";

    StringBuilder result = new StringBuilder();

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, farmerId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            result.append("Order ID: ")
                    .append(rs.getInt("order_id"))
                    .append("\n");

            result.append("Buyer ID: ")
                    .append(rs.getInt("buyer_id"))
                    .append("\n");

            result.append("Date: ")
                    .append(rs.getTimestamp("order_date"))
                    .append("\n");

            result.append("Product: ")
                    .append(rs.getString("product_name"))
                    .append("\n");

            result.append("Quantity: ")
                    .append(rs.getDouble("quantity"))
                    .append("\n");

            result.append("Price: ₹")
                    .append(rs.getDouble("price"))
                    .append("\n");

            result.append("Total Amount: ₹")
                    .append(rs.getDouble("total_amount"))
                    .append("\n");

            result.append("Status: ")
                    .append(rs.getString("status"))
                    .append("\n");

            result.append("-------------------------\n");
        }

        if (result.length() == 0) {
            return Response.ok("No orders found").build();
        }

        return Response.ok(result.toString()).build();

    } catch (Exception e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("Could not retrieve farmer orders: "
                        + e.getMessage())
                .build();
    }
}
@GET
@Path("products/farmer/{id}")
@Produces(MediaType.TEXT_PLAIN)
public Response getFarmerProducts(
        @javax.ws.rs.PathParam("id") int farmerId) {

    String sql =
            "SELECT product_id, product_name, category, "
            + "description, price, quantity, unit "
            + "FROM products "
            + "WHERE farmer_id = ? "
            + "ORDER BY product_id DESC";

    StringBuilder result = new StringBuilder();

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, farmerId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            result.append("Product ID: ")
                    .append(rs.getInt("product_id"))
                    .append("\n");

            result.append("Product Name: ")
                    .append(rs.getString("product_name"))
                    .append("\n");

            result.append("Category: ")
                    .append(rs.getString("category"))
                    .append("\n");

            result.append("Description: ")
                    .append(rs.getString("description"))
                    .append("\n");

            result.append("Price: ")
                    .append(rs.getDouble("price"))
                    .append("\n");

            result.append("Quantity: ")
                    .append(rs.getDouble("quantity"))
                    .append("\n");

            result.append("Unit: ")
                    .append(rs.getString("unit"))
                    .append("\n");

            result.append("-------------------------\n");
        }

        if (result.length() == 0) {

            return Response.ok(
                    "No products found for this farmer")
                    .build();
        }

        return Response.ok(result.toString()).build();

    } catch (Exception e) {

        return Response.status(
                Response.Status.BAD_REQUEST)
                .entity(
                    "Could not retrieve farmer products: "
                    + e.getMessage())
                .build();
    }
}
}
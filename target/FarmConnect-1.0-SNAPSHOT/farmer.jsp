<!DOCTYPE html>
<html>

<head>

    <title>FarmConnect - Farmer Dashboard</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f8f2;
        }

        header {
            background: #2e7d32;
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
        }

        .logout {
            color: white;
            text-decoration: none;
            background: #1b5e20;
            padding: 10px 18px;
            border-radius: 5px;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 35px auto;
        }

        .welcome {
            margin-bottom: 30px;
        }

        .welcome h1 {
            color: #2e7d32;
            margin-bottom: 8px;
        }

        .welcome p {
            color: #666;
        }

        .section {
            background: white;
            padding: 30px;
            margin-bottom: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        .section h2 {
            color: #2e7d32;
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        .full {
            grid-column: 1 / 3;
        }

        button {
            padding: 12px 25px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        button:hover {
            background: #256628;
        }

        #message {
            margin-top: 15px;
            font-weight: bold;
        }

        .product {
            background: #f4f8f2;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            border-left: 5px solid #2e7d32;
        }

        .product h3 {
            color: #2e7d32;
            margin-bottom: 12px;
        }

        .product p {
            margin: 7px 0;
        }

        .product-buttons {
            margin-top: 15px;
        }

        .edit-btn {
            background: #1976d2;
            margin-right: 10px;
        }

        .edit-btn:hover {
            background: #125aa0;
        }

        .delete-btn {
            background: #c62828;
        }

        .delete-btn:hover {
            background: #8e0000;
        }

        .orders {
            white-space: pre-line;
            background: #f4f8f2;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
        }

    </style>

</head>


<body>


<header>

    <div class="logo">
        FarmConnect
    </div>

    <a
        href="index.jsp"
        class="logout"
        onclick="logout()"
    >
        Logout
    </a>

</header>


<div class="container">


    <!-- WELCOME -->

    <div class="welcome">

        <h1>Farmer Dashboard</h1>

        <p>
            Manage your agricultural products and orders.
        </p>

    </div>


    <!-- ADD PRODUCT -->

    <div class="section">

        <h2>Add New Product</h2>

        <form id="productForm">

            <div class="form-grid">

                <input
                    type="text"
                    id="product_name"
                    placeholder="Product Name"
                    required
                >

                <input
                    type="text"
                    id="category"
                    placeholder="Category"
                    required
                >

                <input
                    type="text"
                    id="description"
                    placeholder="Description"
                    required
                >

                <input
                    type="number"
                    id="price"
                    placeholder="Price"
                    step="0.01"
                    required
                >

                <input
                    type="number"
                    id="quantity"
                    placeholder="Quantity"
                    step="0.01"
                    required
                >

                <input
                    type="text"
                    id="unit"
                    placeholder="Unit (kg, litre, etc.)"
                    required
                >

            </div>

            <button type="submit">
                Add Product
            </button>

        </form>

        <div id="message"></div>

    </div>


    <!-- MY PRODUCTS -->

    <div class="section">

        <h2>My Products</h2>

        <button onclick="loadProducts()">
            Refresh Products
        </button>

        <div id="products">

            Loading products...

        </div>

    </div>


    <!-- EDIT PRODUCT -->

    <div
        class="section"
        id="editSection"
        style="display:none;"
    >

        <h2>Edit Product</h2>

        <form id="editForm">

            <input
                type="hidden"
                id="edit_id"
            >

            <div class="form-grid">

                <input
                    type="text"
                    id="edit_name"
                    placeholder="Product Name"
                    required
                >

                <input
                    type="text"
                    id="edit_category"
                    placeholder="Category"
                    required
                >

                <input
                    type="text"
                    id="edit_description"
                    placeholder="Description"
                    required
                >

                <input
                    type="number"
                    id="edit_price"
                    placeholder="Price"
                    step="0.01"
                    required
                >

                <input
                    type="number"
                    id="edit_quantity"
                    placeholder="Quantity"
                    step="0.01"
                    required
                >

                <input
                    type="text"
                    id="edit_unit"
                    placeholder="Unit"
                    required
                >

            </div>

            <button type="submit">
                Update Product
            </button>

            <button
                type="button"
                onclick="cancelEdit()"
                style="background:#777;"
            >
                Cancel
            </button>

        </form>

        <div id="editMessage"></div>

    </div>


    <!-- FARMER ORDERS -->

    <div class="section">

        <h2>Orders for My Products</h2>

        <button onclick="loadFarmerOrders()">
            Refresh Orders
        </button>

        <div
            id="farmerOrders"
            class="orders"
        >
            Loading orders...
        </div>

    </div>


</div>


<script>


/* GET LOGGED-IN FARMER */

var farmerId =
    localStorage.getItem("userId");


var role =
    localStorage.getItem("role");


/*
 * Check whether a farmer
 * is logged in.
 */

if (!farmerId || role !== "FARMER") {

    alert("Please login as a farmer.");

    window.location.href =
        "login.jsp";

}


/* ADD PRODUCT */

document.getElementById("productForm").addEventListener(
    "submit",
    function(event) {

        event.preventDefault();


        var formData =
            new URLSearchParams();


        formData.append(
            "farmer_id",
            farmerId
        );

        formData.append(
            "product_name",
            document.getElementById("product_name").value
        );

        formData.append(
            "category",
            document.getElementById("category").value
        );

        formData.append(
            "description",
            document.getElementById("description").value
        );

        formData.append(
            "price",
            document.getElementById("price").value
        );

        formData.append(
            "quantity",
            document.getElementById("quantity").value
        );

        formData.append(
            "unit",
            document.getElementById("unit").value
        );


        fetch(
            "webresources/farmconnect/products",
            {

                method: "POST",

                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded"
                },

                body: formData

            }
        )

        .then(function(response) {

            return response.text().then(function(data) {

                document.getElementById("message").innerHTML =
                    data;


                if (response.ok) {

                    document.getElementById("message").style.color =
                        "green";

                    document.getElementById("productForm").reset();

                    loadProducts();

                } else {

                    document.getElementById("message").style.color =
                        "red";

                }

            });

        })

        .catch(function(error) {

            document.getElementById("message").innerHTML =
                "Unable to connect to server.";

            document.getElementById("message").style.color =
                "red";

        });

    }
);


/* LOAD FARMER PRODUCTS */

function loadProducts() {

    fetch(
        "webresources/farmconnect/products/farmer/"
        + farmerId
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(data) {

        var productsDiv =
            document.getElementById("products");


        if (
            data.indexOf("No products found") === 0
        ) {

            productsDiv.innerHTML =
                "<p>No products added yet.</p>";

            return;
        }


        var productBlocks =
            data.split("-------------------------");


        productsDiv.innerHTML = "";


        for (
            var i = 0;
            i < productBlocks.length;
            i++
        ) {

            var block =
                productBlocks[i].trim();


            if (block === "") {
                continue;
            }


            var idMatch =
                block.match(/Product ID:\s*(\d+)/);

            var nameMatch =
                block.match(/Product Name:\s*(.*)/);

            var categoryMatch =
                block.match(/Category:\s*(.*)/);

            var descriptionMatch =
                block.match(/Description:\s*(.*)/);

            var priceMatch =
                block.match(/Price:\s*(.*)/);

            var quantityMatch =
                block.match(/Quantity:\s*(.*)/);

            var unitMatch =
                block.match(/Unit:\s*(.*)/);


            if (!idMatch || !nameMatch) {
                continue;
            }


            var productId =
                idMatch[1];

            var productName =
                nameMatch[1];

            var category =
                categoryMatch
                    ? categoryMatch[1]
                    : "";

            var description =
                descriptionMatch
                    ? descriptionMatch[1]
                    : "";

            var price =
                priceMatch
                    ? priceMatch[1]
                    : "";

            var quantity =
                quantityMatch
                    ? quantityMatch[1]
                    : "";

            var unit =
                unitMatch
                    ? unitMatch[1]
                    : "";


            var productHTML =

                "<div class='product'>"

                + "<h3>"
                + productName
                + "</h3>"

                + "<p><b>Product ID:</b> "
                + productId
                + "</p>"

                + "<p><b>Category:</b> "
                + category
                + "</p>"

                + "<p><b>Description:</b> "
                + description
                + "</p>"

                + "<p><b>Price:</b> "
                + price
                + "</p>"

                + "<p><b>Quantity:</b> "
                + quantity
                + " "
                + unit
                + "</p>"

                + "<div class='product-buttons'>"

                + "<button "
                + "class='edit-btn' "
                + "onclick=\"editProduct("
                + productId
                + ")\">"
                + "Edit"
                + "</button>"

                + "<button "
                + "class='delete-btn' "
                + "onclick=\"deleteProduct("
                + productId
                + ")\">"
                + "Delete"
                + "</button>"

                + "</div>"

                + "</div>";


            productsDiv.innerHTML +=
                productHTML;

        }

    })

    .catch(function(error) {

        document.getElementById("products").innerHTML =
            "Unable to load products.";

    });

}


/* EDIT PRODUCT */

function editProduct(productId) {

    fetch(
        "webresources/farmconnect/products/"
        + productId
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(data) {

        var idMatch =
            data.match(/Product ID:\s*(\d+)/);

        var nameMatch =
            data.match(/Product:\s*(.*)/);

        var categoryMatch =
            data.match(/Category:\s*(.*)/);

        var descriptionMatch =
            data.match(/Description:\s*(.*)/);

        var priceMatch =
            data.match(/Price:\s*(.*)/);

        var quantityMatch =
            data.match(/Quantity:\s*([0-9.]+)/);

        var unitMatch =
            data.match(
                /Quantity:\s*[0-9.]+\s*(.*)/
            );


        document.getElementById("edit_id").value =
            idMatch[1];

        document.getElementById("edit_name").value =
            nameMatch[1];

        document.getElementById("edit_category").value =
            categoryMatch[1];

        document.getElementById("edit_description").value =
            descriptionMatch[1];

        document.getElementById("edit_price").value =
            priceMatch[1];

        document.getElementById("edit_quantity").value =
            quantityMatch[1];

        document.getElementById("edit_unit").value =
            unitMatch[1];


        document.getElementById("editSection").style.display =
            "block";


        window.scrollTo({
            top:
                document.getElementById(
                    "editSection"
                ).offsetTop,

            behavior: "smooth"
        });

    })

    .catch(function(error) {

        alert(
            "Unable to load product details."
        );

    });

}


/* UPDATE PRODUCT */

document.getElementById("editForm").addEventListener(
    "submit",
    function(event) {

        event.preventDefault();


        var productId =
            document.getElementById("edit_id").value;


        var formData =
            new URLSearchParams();


        formData.append(
            "product_name",
            document.getElementById("edit_name").value
        );

        formData.append(
            "category",
            document.getElementById("edit_category").value
        );

        formData.append(
            "description",
            document.getElementById("edit_description").value
        );

        formData.append(
            "price",
            document.getElementById("edit_price").value
        );

        formData.append(
            "quantity",
            document.getElementById("edit_quantity").value
        );

        formData.append(
            "unit",
            document.getElementById("edit_unit").value
        );


        fetch(
            "webresources/farmconnect/products/"
            + productId,
            {

                method: "PUT",

                headers: {
                    "Content-Type":
                        "application/x-www-form-urlencoded"
                },

                body: formData

            }
        )

        .then(function(response) {

            return response.text().then(function(data) {

                var message =
                    document.getElementById(
                        "editMessage"
                    );


                message.innerHTML =
                    data;


                if (response.ok) {

                    message.style.color =
                        "green";

                    loadProducts();

                } else {

                    message.style.color =
                        "red";

                }

            });

        })

        .catch(function(error) {

            document.getElementById(
                "editMessage"
            ).innerHTML =
                "Unable to connect to server.";

            document.getElementById(
                "editMessage"
            ).style.color =
                "red";

        });

    }
);


/* DELETE PRODUCT */

function deleteProduct(productId) {

    var confirmation =
        confirm(
            "Are you sure you want to delete this product?"
        );


    if (!confirmation) {
        return;
    }


    fetch(
        "webresources/farmconnect/products/"
        + productId,
        {
            method: "DELETE"
        }
    )

    .then(function(response) {

        return response.text().then(function(data) {

            if (response.ok) {

                alert(data);

                loadProducts();

            } else {

                alert(data);

            }

        });

    })

    .catch(function(error) {

        alert(
            "Unable to connect to server."
        );

    });

}


/* CANCEL EDIT */

function cancelEdit() {

    document.getElementById(
        "editSection"
    ).style.display = "none";


    document.getElementById(
        "editForm"
    ).reset();

}


/* LOAD FARMER ORDERS */

function loadFarmerOrders() {

    fetch(
        "webresources/farmconnect/orders/farmer/"
        + farmerId
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(data) {

        document.getElementById(
            "farmerOrders"
        ).innerText = data;

    })

    .catch(function(error) {

        document.getElementById(
            "farmerOrders"
        ).innerText =
            "Unable to load orders.";

    });

}


/* LOGOUT */

function logout() {

    localStorage.removeItem("userId");

    localStorage.removeItem("name");

    localStorage.removeItem("role");

}


/* LOAD WHEN PAGE OPENS */

loadProducts();

loadFarmerOrders();


</script>


</body>

</html>
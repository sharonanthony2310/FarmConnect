<!DOCTYPE html>
<html>

<head>

    <title>FarmConnect - Buyer Dashboard</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f8f2;
            color: #333;
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

        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-box input {
            flex: 1;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            padding: 12px 22px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background: #256628;
        }

        .product {
            background: #f4f8f2;
            padding: 20px;
            margin-bottom: 18px;
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

        .order-area {
            margin-top: 15px;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .order-area input {
            width: 150px;
        }

        .order-btn {
            background: #1976d2;
        }

        .order-btn:hover {
            background: #125aa0;
        }

        .orders {
            white-space: pre-line;
            background: #f4f8f2;
            padding: 20px;
            border-radius: 8px;
        }

        #message {
            margin-top: 15px;
            font-weight: bold;
        }

    </style>

</head>


<body>


<header>

    <div class="logo">
        FarmConnect
    </div>

    <a href="index.jsp"
       class="logout"
       onclick="logout()">
        Logout
    </a>

</header>


<div class="container">


    <!-- WELCOME -->

    <div class="welcome">

        <h1>Buyer Dashboard</h1>

        <p>
            Browse fresh agricultural products
            directly from farmers.
        </p>

    </div>


    <!-- PRODUCTS -->

    <div class="section">

        <h2>Browse Products</h2>


        <div class="search-box">

            <input
                type="text"
                id="searchName"
                placeholder="Search product..."
            >

            <button onclick="searchProducts()">
                Search
            </button>

            <button onclick="loadProducts()">
                All Products
            </button>

        </div>


        <div id="products">

            Loading products...

        </div>

    </div>


    <!-- ORDERS -->

    <div class="section">

        <h2>My Orders</h2>

        <button onclick="loadOrders()">
            Refresh Orders
        </button>

        <div
            id="orders"
            class="orders"
            style="margin-top:20px;"
        >
            Loading orders...
        </div>

    </div>


    <div id="message"></div>


</div>


<script>


/* GET LOGGED-IN BUYER */

var buyerId =
    localStorage.getItem("userId");


var role =
    localStorage.getItem("role");


/*
 * Make sure only a buyer
 * uses this dashboard.
 */

if (!buyerId || role !== "BUYER") {

    alert("Please login as a buyer.");

    window.location.href =
        "login.jsp";

}


/* LOAD ALL PRODUCTS */

function loadProducts() {

    fetch(
        "webresources/farmconnect/products"
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(data) {

        displayProducts(data);

    })

    .catch(function(error) {

        document.getElementById("products").innerHTML =
            "Unable to load products.";

    });

}


/* SEARCH PRODUCTS */

function searchProducts() {

    var name =
        document.getElementById("searchName").value;


    if (name.trim() === "") {

        loadProducts();

        return;
    }


    fetch(
        "webresources/farmconnect/products/search/"
        + encodeURIComponent(name)
    )

    .then(function(response) {

        return response.text().then(function(data) {

            if (!response.ok) {

                document.getElementById("products").innerHTML =
                    "<p>" + data + "</p>";

                return;
            }

            displayProducts(data);

        });

    })

    .catch(function(error) {

        document.getElementById("products").innerHTML =
            "Unable to search products.";

    });

}


/* DISPLAY PRODUCTS */

function displayProducts(data) {

    var productsDiv =
        document.getElementById("products");


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

        var farmerMatch =
            block.match(/Farmer ID:\s*(\d+)/);

        var nameMatch =
            block.match(/Product:\s*(.*)/);

        var categoryMatch =
            block.match(/Category:\s*(.*)/);

        var descriptionMatch =
            block.match(/Description:\s*(.*)/);

        var priceMatch =
            block.match(/Price:\s*(.*)/);

        var quantityMatch =
            block.match(/Quantity:\s*([0-9.]+)\s*(.*)/);


        if (!idMatch || !nameMatch) {
            continue;
        }


        var productId =
            idMatch[1];

        var farmerId =
            farmerMatch ? farmerMatch[1] : "";

        var productName =
            nameMatch[1];

        var category =
            categoryMatch ? categoryMatch[1] : "";

        var description =
            descriptionMatch ? descriptionMatch[1] : "";

        var price =
            priceMatch ? priceMatch[1] : "";

        var availableQuantity =
            quantityMatch ? quantityMatch[1] : "";

        var unit =
            quantityMatch ? quantityMatch[2] : "";


        var productHTML =

            "<div class='product'>"

            + "<h3>"
            + productName
            + "</h3>"

            + "<p><b>Product ID:</b> "
            + productId
            + "</p>"

            + "<p><b>Farmer ID:</b> "
            + farmerId
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

            + "<p><b>Available:</b> "
            + availableQuantity
            + " "
            + unit
            + "</p>"


            + "<div class='order-area'>"

            + "<input "
            + "type='number' "
            + "id='quantity_"
            + productId
            + "' "
            + "placeholder='Quantity' "
            + "min='0.01' "
            + "step='0.01'>"

            + "<button "
            + "class='order-btn' "
            + "onclick='placeOrder("
            + productId
            + ")'>"
            + "Place Order"
            + "</button>"

            + "</div>"


            + "</div>";


        productsDiv.innerHTML +=
            productHTML;

    }

}


/* PLACE ORDER */

function placeOrder(productId) {

    var quantity =
        document.getElementById(
            "quantity_" + productId
        ).value;


    if (
        quantity === ""
        ||
        parseFloat(quantity) <= 0
    ) {

        alert(
            "Please enter a valid quantity."
        );

        return;
    }


    var confirmation =
        confirm(
            "Do you want to place this order?"
        );


    if (!confirmation) {
        return;
    }


    var formData =
        new URLSearchParams();


    formData.append(
        "buyer_id",
        buyerId
    );

    formData.append(
        "product_id",
        productId
    );

    formData.append(
        "quantity",
        quantity
    );


    fetch(
        "webresources/farmconnect/orders",
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

            var message =
                document.getElementById("message");


            message.innerHTML =
                data;


            if (response.ok) {

                message.style.color =
                    "green";

                loadProducts();

                loadOrders();

            } else {

                message.style.color =
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


/* LOAD BUYER ORDERS */

function loadOrders() {

    fetch(
        "webresources/farmconnect/orders/buyer/"
        + buyerId
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(data) {

        document.getElementById("orders").innerText =
            data;

    })

    .catch(function(error) {

        document.getElementById("orders").innerText =
            "Unable to load orders.";

    });

}


/* LOGOUT */

function logout() {

    localStorage.removeItem("userId");

    localStorage.removeItem("name");

    localStorage.removeItem("role");

}


/* INITIAL LOAD */

loadProducts();

loadOrders();

</script>


</body>

</html>
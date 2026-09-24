<!DOCTYPE html>
<html>
<head>
    <title>FarmConnect</title>

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
            padding: 20px 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            font-size: 16px;
        }

        nav a:hover {
            text-decoration: underline;
        }

        .hero {
            min-height: 500px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 40px;
        }

        .hero-content {
            max-width: 700px;
        }

        .hero h1 {
            font-size: 48px;
            color: #2e7d32;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 20px;
            line-height: 1.6;
            margin-bottom: 30px;
            color: #555;
        }

        .buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 16px;
        }

        .primary {
            background: #2e7d32;
            color: white;
        }

        .secondary {
            border: 2px solid #2e7d32;
            color: #2e7d32;
        }

        .primary:hover {
            background: #256628;
        }

        .secondary:hover {
            background: #e8f5e9;
        }

        .features {
            background: white;
            padding: 50px;
            text-align: center;
        }

        .features h2 {
            color: #2e7d32;
            margin-bottom: 35px;
            font-size: 30px;
        }

        .cards {
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
        }

        .card {
            width: 260px;
            padding: 30px;
            border-radius: 10px;
            background: #f4f8f2;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .card h3 {
            color: #2e7d32;
            margin-bottom: 12px;
        }

        .card p {
            line-height: 1.5;
            color: #666;
        }

        footer {
            background: #1b5e20;
            color: white;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>

<body>

<header>

    <div class="logo">
        FarmConnect
    </div>

    <nav>
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
    </nav>

</header>

<section class="hero">

    <div class="hero-content">

        <h1>FarmConnect</h1>

        <p>
            Connecting farmers directly with buyers.
            Buy fresh agricultural products directly from
            local farmers and support sustainable farming.
        </p>

        <div class="buttons">

            <a href="login.jsp" class="btn primary">
                Login
            </a>

            <a href="register.jsp" class="btn secondary">
                Create Account
            </a>

        </div>

    </div>

</section>

<section class="features">

    <h2>What FarmConnect Offers</h2>

    <div class="cards">

        <div class="card">
            <h3>For Farmers</h3>
            <p>
                Farmers can list their agricultural products,
                update product details and manage orders.
            </p>
        </div>

        <div class="card">
            <h3>For Buyers</h3>
            <p>
                Buyers can browse available products,
                search for products and place orders.
            </p>
        </div>

        <div class="card">
            <h3>Fresh Products</h3>
            <p>
                Get agricultural products directly from
                farmers without unnecessary intermediaries.
            </p>
        </div>

    </div>

</section>

<footer>

    <p>Copyright 2026 FarmConnect | Connecting Farmers and Buyers</p>

</footer>

</body>
</html>
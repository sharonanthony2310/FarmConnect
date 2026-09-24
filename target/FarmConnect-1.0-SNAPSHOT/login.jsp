<!DOCTYPE html>
<html>
<head>

    <title>FarmConnect - Login</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f8f2;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            width: 400px;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        h1 {
            text-align: center;
            color: #2e7d32;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            border-color: #2e7d32;
            outline: none;
        }

        button {
            width: 100%;
            padding: 13px;
            background: #2e7d32;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #256628;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }

        .register-link a {
            color: #2e7d32;
            text-decoration: none;
            font-weight: bold;
        }

        #message {
            margin-top: 20px;
            text-align: center;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="login-container">

    <h1>FarmConnect</h1>

    <p class="subtitle">Login to your account</p>

    <form id="loginForm">

        <label>Email</label>

        <input
            type="email"
            id="email"
            placeholder="Enter your email"
            required
        >

        <label>Password</label>

        <input
            type="password"
            id="password"
            placeholder="Enter your password"
            required
        >

        <button type="submit">
            Login
        </button>

    </form>

    <div id="message"></div>

    <div class="register-link">
        Don't have an account?
        <a href="register.jsp">Register</a>
    </div>

</div>
<script>

document.getElementById("loginForm").addEventListener(
    "submit",
    function(event) {

        event.preventDefault();

        var email = document.getElementById("email").value;
        var password = document.getElementById("password").value;

        var formData = new URLSearchParams();

        formData.append("email", email);
        formData.append("password", password);


        fetch("webresources/farmconnect/users/login", {

            method: "POST",

            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            body: formData

        })

        .then(function(response) {

            return response.text().then(function(data) {

                if (response.ok) {

                    /*
                     * Example response:
                     * Login successful! User ID: 1,
                     * Name: Rahul, Role: FARMER
                     */

                    var userIdMatch =
                        data.match(/User ID:\s*(\d+)/);

                    var nameMatch =
                        data.match(/Name:\s*(.*?),\s*Role:/);

                    var roleMatch =
                        data.match(/Role:\s*(\w+)/);


                    if (userIdMatch && roleMatch) {

                        var userId =
                            userIdMatch[1];

                        var name =
                            nameMatch ? nameMatch[1] : "";

                        var role =
                            roleMatch[1];


                        /*
                         * Save login information
                         */

                        localStorage.setItem(
                            "userId",
                            userId
                        );

                        localStorage.setItem(
                            "name",
                            name
                        );

                        localStorage.setItem(
                            "role",
                            role
                        );


                        /*
                         * Redirect according to role
                         */

                        if (role === "FARMER") {

                            window.location.href =
                                "farmer.jsp";

                        } else if (role === "BUYER") {

                            window.location.href =
                                "buyer.jsp";

                        } else {

                            document.getElementById("message").innerHTML =
                                "Invalid account role.";

                            document.getElementById("message").style.color =
                                "red";
                        }

                    } else {

                        document.getElementById("message").innerHTML =
                            "Login successful, but user information could not be read.";

                        document.getElementById("message").style.color =
                            "red";
                    }

                } else {

                    document.getElementById("message").innerHTML =
                        data;

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

</script>
</body>
</html>
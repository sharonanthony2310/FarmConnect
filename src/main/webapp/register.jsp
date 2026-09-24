<!DOCTYPE html>
<html>
<head>

    <title>FarmConnect - Register</title>

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
            padding: 30px;
        }

        .register-container {
            width: 450px;
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
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus, select:focus {
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

        .login-link {
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
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

<div class="register-container">

    <h1>FarmConnect</h1>

    <p class="subtitle">Create your account</p>

    <form id="registerForm">

        <label>Name</label>

        <input
            type="text"
            id="name"
            placeholder="Enter your name"
            required
        >

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

        <label>Phone</label>

        <input
            type="text"
            id="phone"
            placeholder="Enter your phone number"
            required
        >

        <label>Address</label>

        <input
            type="text"
            id="address"
            placeholder="Enter your address"
            required
        >

        <label>Account Type</label>

        <select id="role" required>

            <option value="">Select account type</option>
            <option value="FARMER">Farmer</option>
            <option value="BUYER">Buyer</option>

        </select>

        <button type="submit">
            Create Account
        </button>

    </form>

    <div id="message"></div>

    <div class="login-link">
        Already have an account?
        <a href="login.jsp">Login</a>
    </div>

</div>


<script>

document.getElementById("registerForm").addEventListener("submit", function(event) {

    event.preventDefault();

    var name = document.getElementById("name").value;
    var email = document.getElementById("email").value;
    var password = document.getElementById("password").value;
    var phone = document.getElementById("phone").value;
    var address = document.getElementById("address").value;
    var role = document.getElementById("role").value;

    var formData = new URLSearchParams();

    formData.append("name", name);
    formData.append("email", email);
    formData.append("password", password);
    formData.append("phone", phone);
    formData.append("address", address);
    formData.append("role", role);

    fetch("webresources/farmconnect/users/register", {

        method: "POST",

        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },

        body: formData

    })

    .then(function(response) {

        return response.text().then(function(data) {

            if (response.ok) {

                document.getElementById("message").innerHTML =
                    data;

                document.getElementById("message").style.color =
                    "green";

                document.getElementById("registerForm").reset();

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

});

</script>

</body>
</html>
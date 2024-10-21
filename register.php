<?php
session_start();
require 'config.php';  // Include DB connection

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = htmlspecialchars(trim($_POST['username']));  // Sanitize input
    $email = filter_var($_POST['email'], FILTER_VALIDATE_EMAIL);  // Validate email format
    $password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];

    // Check if passwords match
    if ($password !== $confirm_password) {
        $_SESSION['error'] = "Passwords do not match!";
        header("Location: register.html");
        exit();
    }

    // Hash the password
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);

    // Check if email or username already exists
    $stmt = $conn->prepare("SELECT * FROM users WHERE username = ? OR email = ?");
    $stmt->bind_param("ss", $username, $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $_SESSION['error'] = "Username or email already exists!";
        header("Location: register.html");
        exit();
    }

    // Insert user into the database
    $stmt = $conn->prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $email, $hashed_password);

    if ($stmt->execute()) {
        $_SESSION['message'] = "Registration successful! You can now log in.";
        header("Location: login.html");
    } else {
        $_SESSION['error'] = "Registration failed! Please try again.";
        header("Location: register.html");
    }

    $stmt->close();
    $conn->close();
}
?>

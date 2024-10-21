<?php
session_start();
require 'config.php';  // Include DB connection

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = filter_var($_POST['email'], FILTER_VALIDATE_EMAIL);
    $password = $_POST['password'];

    // Check if the user exists
    $stmt = $conn->prepare("SELECT id, username, password FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($id, $username, $hashed_password);
        $stmt->fetch();

        // Verify password
        if (password_verify($password, $hashed_password)) {
            $_SESSION['user_id'] = $id;
            $_SESSION['username'] = $username;
            header("Location: dashboard.php");
        } else {
            $_SESSION['error'] = "Invalid credentials!";
            header("Location: login.html");
        }
    } else {
        $_SESSION['error'] = "User not found!";
        header("Location: login.html");
    }

    $stmt->close();
    $conn->close();
}
?>

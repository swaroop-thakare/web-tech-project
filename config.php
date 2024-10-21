<?php
$servername = "localhost";  // Change if using a remote database
$dbusername = "root";  // Your database username
$dbpassword = "satvik123";  // Your database password
$dbname = "access_transit";  // The database we created

// Create connection
$conn = new mysqli($servername, $dbusername, $dbpassword, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

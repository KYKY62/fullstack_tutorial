<?php

$host = 'localhost';
$userName = 'root';
$password = '';
$dbName = 'rizky_a';

// cors
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");

$koneksi = mysqli_connect($host, $userName, $password, $dbName)
    or die('unable connect');

<?php

include_once 'koneksi.php';

// biar bisa mode raw json
$value = json_decode(file_get_contents('php://input'), true);

$tbName = 'faktur';
$kode = $value['kode'];
$description = $value['description'];
$price = $value['price'];
$stock = $value['stock'];

$query = "INSERT INTO $tbName(kode,description,price,stock)
                        VALUES('$kode', '$description', '$price', '$stock' )";
$sql = mysqli_query($koneksi, $query);

// periksa query berhasil koneksi
if ($sql) {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Created!')
    );
} else {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Failed!')
    );
}

<?php

include_once 'koneksi.php';

// untuk input updatenya
$value = json_decode(file_get_contents('php://input'), true);

$tbName = 'faktur';
$kode = $value['kode'];
$description = $value['description'];
$price = $value['price'];
$stock = $value['stock'];

$query = "UPDATE $tbName SET description='$description', price='$price', stock='$stock' WHERE kode='$kode'";

$sql = mysqli_query($koneksi, $query);

// periksa query berhasil koneksi
if ($sql) {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Updated!')
    );
} else {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Failed!')
    );
}

<?php

include_once 'koneksi.php';

// untuk input updatenya
$value = json_decode(file_get_contents('php://input'), true);

// Validasi data
if (!isset($_GET['kode'])) {
    echo json_encode(['message' => 'Invalid input data']);
    exit;
}


$tbName = 'faktur';
// biar ada parameter
$kode = mysqli_escape_string($koneksi, $_GET['kode']);

$query = "DELETE FROM $tbName WHERE kode='$kode'";
$sql = mysqli_query($koneksi, $query);


// periksa query berhasil koneksi
if ($sql) {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Deleted Success!')
    );
} else {
    // untuk mengubah data kedalam json
    echo json_encode(
        array('message' => 'Deleted Failed!')
    );
}

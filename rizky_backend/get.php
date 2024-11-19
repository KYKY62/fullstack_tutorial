<?php

include_once 'koneksi.php';

$tbName = 'faktur';

// periksa apakah dicari melalui ID/Kode
if (empty($_GET)) {
    $query = mysqli_query($koneksi, "SELECT * FROM $tbName ORDER BY kode DESC");

    // karna berbentuk List
    $data = array();
    // untuk mengambil data kode berupa List
    while ($row = mysqli_fetch_array($query)) {
        // data nya berupa list yang dimasukkan ke objek result
        array_push($data, array(
            'kode' => $row['kode'],
            'description' => $row['description'],
            'price' => $row['price'],
            'stock' => $row['stock'],
        ));
    }

    // untuk mengambil data tadi kedalam json
    echo json_encode(
        array('data' => $data)
    );
} else {
    // agar terhindar dari error string
    $kode = mysqli_escape_string($koneksi, $_GET['kode']);

    $query = mysqli_query($koneksi, "SELECT * FROM $tbName WHERE kode = '$kode'");

    // Cek jika data ditemukan
    if (mysqli_num_rows($query) > 0) {
        $data = array();

        while ($row = $query->fetch_assoc()) {
            // Data ditemukan, masukkan ke array
            $data = array(
                'kode' => $row['kode'],
                'description' => $row['description'],
                'price' => $row['price'],
                'stock' => $row['stock'],
                'success' => true
            );
        }

        // Kembalikan data dalam format JSON
        echo json_encode(
            array($data)
        );
    } else {
        $data =   array(
            'message' => 'Data tidak ditemukan',
            'success' => false
        );
        // Data tidak ditemukan, kembalikan pesan
        echo json_encode(
            array($data)
        );
    }
}

-- SKENARIO 1: ROLLBACK
-- Memasukkan data sementara lalu membatalkan transaksi.

BEGIN;

INSERT INTO "SALAM".mahasiswas
    (nim, nama, email, semester, ipk)
VALUES
    ('1207050997',
     'Mahasiswa Transaksi',
     'transaksi@student.uinsgd.ac.id',
     5,
     3.85);

SELECT *
FROM "SALAM".mahasiswas
WHERE nim = '1207050997';

ROLLBACK;

-- Memastikan data tidak tersimpan.
SELECT *
FROM "SALAM".mahasiswas
WHERE nim = '1207050997';


-- SKENARIO 2: COMMIT
-- Memasukkan data dan menyimpan transaksi secara permanen.

BEGIN;

INSERT INTO "SALAM".mahasiswas
    (nim, nama, email, semester, ipk)
VALUES
    ('1207050996',
     'Mahasiswa Commit',
     'commit@student.uinsgd.ac.id',
     5,
     3.90);

SELECT *
FROM "SALAM".mahasiswas
WHERE nim = '1207050996';

COMMIT;

-- Memastikan data tetap tersimpan.
SELECT *
FROM "SALAM".mahasiswas
WHERE nim = '1207050996';

# UTS Manajemen Basis Data
## Implementasi PostgreSQL dan pgAdmin Menggunakan Docker

**Nama:** M. Radit Assegaf  
**NIM:** 1207050133  
**Kelas:** B  
**Mata Kuliah:** Manajemen Basis Data  

---

## 1. Deskripsi Project

Project ini merupakan implementasi sistem manajemen basis data menggunakan PostgreSQL yang dijalankan melalui Docker Compose. pgAdmin digunakan sebagai antarmuka administrasi database, sedangkan DBeaver digunakan untuk menguji koneksi database dari lingkungan eksternal.

Implementasi ini mencakup konfigurasi container, pembuatan schema dan tabel, penerapan constraint, pengelolaan user database, serta pengaturan hak akses berdasarkan peran masing-masing pengguna.

## 2. Teknologi yang Digunakan

| Teknologi | Keterangan |
|---|---|
| PostgreSQL 15 Alpine | Database Management System |
| Docker | Containerization |
| Docker Compose | Orkestrasi container |
| pgAdmin 4 | Administrasi PostgreSQL |
| DBeaver | Database client eksternal |
| SQL | Bahasa pengelolaan database |

## 3. Struktur Project

```text
manajemen-basis-data/
│
├── .env
├── .env.example
├── .gitignore
├── docker-compose.yml
│
├── 01_create_schema_table.sql
├── 02_create_users.sql
├── 03_grant_privileges.sql
├── 04_test_privileges.sql
├── 05_transaction_management.sql
│
└── README.md
```

Keterangan:
- `.env`: Menyimpan konfigurasi dan kredensial lingkungan lokal.
- `.env.example`: Template konfigurasi environment.
- `.gitignore`: Mengatur file yang tidak disertakan dalam Git.
- `docker-compose.yml`: Konfigurasi layanan PostgreSQL dan pgAdmin.
- `01_create_schema_table.sql`: Membuat schema dan tabel mahasiswa.
- `02_create_users.sql`: Membuat akun pengguna database.
- `03_grant_privileges.sql`: Mengatur hak akses setiap pengguna.
- `04_test_privileges.sql`: Berisi query pengujian hak akses.
- `05_transaction_management.sql`: Mengimplementasikan dan menguji transaksi database menggunakan COMMIT dan ROLLBACK.

## 4. Konfigurasi Environment

Sebelum menjalankan project, buat file `.env` berdasarkan template `.env.example`.

Konfigurasi environment digunakan untuk memisahkan kredensial dari file Docker Compose.

Variabel utama yang digunakan:

| Variabel | Fungsi |
|---|---|
| `POSTGRES_USER` | Username PostgreSQL |
| `POSTGRES_PASSWORD` | Password PostgreSQL |
| `POSTGRES_DB` | Database awal |
| `POSTGRES_PORT` | Port eksternal PostgreSQL |
| `PGADMIN_PORT` | Port eksternal pgAdmin |
| `PGADMIN_DEFAULT_EMAIL` | Email administrator pgAdmin |
| `PGADMIN_DEFAULT_PASSWORD` | Password administrator pgAdmin |

**Catatan:** File `.env` tidak disertakan dalam repository karena mengandung informasi kredensial. Gunakan `.env.example` sebagai referensi konfigurasi.

## 5. Konfigurasi Docker

Project menggunakan dua layanan utama:

### PostgreSQL
- Image: `postgres:15-alpine`
- Container: `postgres_M_Radit_Assegaf`
- Port internal: `5432`
- Port eksternal: `22133`
- Volume: `postgres_data`

### pgAdmin
- Image: `dpage/pgadmin4:latest`
- Container: `pgadmin_M_Radit_Assegaf`
- Port internal: `80`
- Port eksternal: `44133`
- Volume: `pgadmin_data`

Kedua container terhubung melalui Docker bridge network bernama `salam_network`.

PostgreSQL dilengkapi health check menggunakan `pg_isready`, sehingga layanan pgAdmin menunggu PostgreSQL berada dalam kondisi sehat sebelum dijalankan.

## 6. Menjalankan Project

Pastikan Docker Desktop telah berjalan, kemudian buka terminal pada direktori project.

Validasi konfigurasi:

```bash
docker compose config --quiet
```

Menjalankan seluruh container:

```bash
docker compose up -d
```

Memeriksa status container:

```bash
docker ps
```

Melihat log PostgreSQL:

```bash
docker compose logs postgres
```

Menghentikan container:

```bash
docker compose down
```

## 7. Akses Database

### pgAdmin 4

Buka browser dan akses:

```text
http://localhost:44133
```

Tambahkan server PostgreSQL dengan konfigurasi:

| Parameter | Nilai |
|---|---|
| Host | `postgres` |
| Port | `5432` |
| Maintenance Database | `postgres` |
| Username | `postgres` |
| Password | Sesuai `.env` |

Host menggunakan nama service `postgres` karena koneksi dilakukan dari container pgAdmin melalui Docker network.

### DBeaver

Untuk menguji koneksi dari luar container, gunakan konfigurasi:

| Parameter | Nilai |
|---|---|
| Host | `localhost` |
| Port | `22133` |
| Database | `postgres` |
| Username | `postgres` |
| Password | Sesuai `.env` |

## 8. Implementasi Database

Project menggunakan schema bernama `SALAM` dengan tabel `mahasiswas`.

Tabel tersebut memiliki struktur berikut:

| Kolom | Tipe Data | Constraint |
|---|---|---|
| `id_mahasiswa` | SERIAL | PRIMARY KEY |
| `nim` | VARCHAR(20) | NOT NULL, UNIQUE |
| `nama` | VARCHAR(100) | NOT NULL |
| `email` | VARCHAR(100) | UNIQUE |
| `semester` | INTEGER | NOT NULL, CHECK |
| `ipk` | NUMERIC(3,2) | CHECK |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

Constraint diterapkan untuk menjaga integritas data, yaitu:
- **PRIMARY KEY:** Menjamin identitas setiap mahasiswa bersifat unik.
- **UNIQUE:** Mencegah duplikasi NIM dan email.
- **NOT NULL:** Memastikan atribut wajib memiliki nilai.
- **CHECK:** Membatasi semester pada rentang 1–14 dan IPK pada rentang 0–4.
- **DEFAULT:** Mengisi waktu pembuatan data secara otomatis.

## 9. Manajemen User dan Hak Akses

Project menerapkan tiga akun pengguna dengan pembagian hak akses:

| User | Hak Akses |
|---|---|
| `backend_dev` | SELECT, INSERT, UPDATE, DELETE |
| `bi_dev` | SELECT |
| `data_engineer` | CREATE, MODIFY, DROP, serta CRUD |

Pembagian hak akses dilakukan menggunakan perintah SQL seperti `GRANT`, `ALTER`, dan pengaturan ownership objek database.

Penerapan ini bertujuan untuk membatasi akses berdasarkan tanggung jawab masing-masing pengguna.

## 10. Transaction Management

Sebagai fitur tambahan, project ini mengimplementasikan mekanisme transaksi database (*Transaction Management*) menggunakan PostgreSQL.

Implementasi ini bertujuan untuk menunjukkan bagaimana perubahan data dapat disimpan secara permanen atau dibatalkan sesuai kebutuhan.

### A. ROLLBACK

ROLLBACK digunakan untuk membatalkan seluruh perubahan yang dilakukan selama transaksi berlangsung dan belum di-commit.

Pengujian dilakukan dengan:
1. Memulai transaksi menggunakan `BEGIN`.
2. Menambahkan data mahasiswa menggunakan `INSERT`.
3. Memeriksa data menggunakan `SELECT`.
4. Membatalkan transaksi menggunakan `ROLLBACK`.
5. Memastikan data tidak tersimpan setelah transaksi dibatalkan.

### B. COMMIT

COMMIT digunakan untuk menyimpan seluruh perubahan dalam transaksi secara permanen.

Pengujian dilakukan dengan:
1. Memulai transaksi menggunakan `BEGIN`.
2. Menambahkan data mahasiswa menggunakan `INSERT`.
3. Memeriksa data menggunakan `SELECT`.
4. Menyimpan perubahan menggunakan `COMMIT`.
5. Memastikan data tetap tersedia setelah transaksi selesai.

### Kesimpulan

Implementasi COMMIT dan ROLLBACK menunjukkan penerapan pengelolaan transaksi pada PostgreSQL. Kedua mekanisme tersebut memberikan kontrol terhadap perubahan data serta membantu menjaga konsistensi database.

## 11. Urutan Eksekusi SQL

Jalankan file SQL menggunakan akun administrator PostgreSQL dengan urutan berikut:

1. `01_create_schema_table.sql`
2. `02_create_users.sql`
3. `03_grant_privileges.sql`
4. `04_test_privileges.sql`
5. `05_transaction_management.sql`

Pengujian dilakukan untuk memastikan schema, tabel, akun pengguna, serta hak akses telah diterapkan sesuai kebutuhan.

## 12. Repository

Source code dan konfigurasi project tersedia di GitHub:

[UTS Manajemen Basis Data - GitHub](https://github.com/mrassegaf21/UTS-Manajemen-Basis-Data)

---

**Project UTS Manajemen Basis Data**  
JurusanTeknik Informatika  
UIN Sunan Gunung Djati Bandung  
2026
# Analyzing-E-Commerce-Business-Performance-with-SQL
This project focuses on analyzing the performance of an e-commerce business using SQL. The analysis covers various aspects such as revenue trends, customer behavior, product performance, and operational efficiency.

# Problem Statement
## Background
“Dalam suatu perusahaan mengukur performa bisnis sangatlah penting untuk melacak, memantau, dan menilai keberhasilan atau kegagalan dari berbagai proses bisnis. Oleh karena itu, dalam paper ini akan menganalisa performa bisnis untuk sebuah perusahan eCommerce,  dengan memperhitungkan beberapa metrik bisnis yaitu pertumbuhan pelanggan, kualitas produk, dan tipe pembayaran.”

## Objective
Berdasarkan Background story yang telah diketahui maka bojective dari analisis ini adalah :
1.  **Annual Customer Activity Growth**
2.  **Annual Product Category Quality**
3.  **Annual Payment Type Usage**

# ERD / Struktur Tabel
![Entity Relationship Diagram](https://drive.google.com/uc?export=view&id=1U6u7FfRWTmPay8CDxCaSA8nm5yZhaIog)
Basis data tersebut terdiri dari beberapa tabel, termasuk `customers`, `geolocation`, `order_items`, `order_payments`, `order_reviews`, `orders`, `product`, dan `sellers`. Setiap tabel berisi informasi spesifik yang terkait dengan bisnis eCommerce. Sebagai contoh, tabel orders berisi informasi tentang setiap pesanan, termasuk status pesanan dan waktu pembelian.
Basis data tersebut terdiri dari beberapa tabel, termasuk customers, geolocation, order_items, order_payments, order_reviews, orders, product, dan sellers. Setiap tabel berisi informasi spesifik yang terkait dengan bisnis eCommerce. Sebagai contoh, tabel orders berisi informasi tentang setiap pesanan, termasuk status pesanan dan waktu pembelian.

# Analisis
Berdasarkan dari proses yang sudah dilakukan maka:
1. Analisis Pendapatan Tahunan : 
    Menganalisis pendapatan tahunan dari bisnis e-commerce.

2. Analisis Pesanan yang Dibatalkan :
Yaitu Menganalisis jumlah pesanan yang dibatalkan setiap tahun, dimana dalam hal ini pembuatan tabel canceled_orders yang berisi informasi tentang total jumlah pesanan yang dibatalkan setiap tahun.

3. Analisis Kategori Produk :
Menganalisis kategori produk berdasarkan pendapatan dan pesanan yang dibatalkan yaitu 'highest_product_revenues' dan 'highest_canceled_product'. Tabel 'highest_product_revenues' berisi nama kategori produk yang menghasilkan pendapatan total tertinggi setiap tahun. Tabel 'highest_canceled_product' berisi nama kategori produk yang memiliki jumlah pesanan yang dibatalkan terbanyak setiap tahun.

4. Analisis Tipe Pembayaran :
Menganalisis penggunaan tipe pembayaran. sepanjang waktu, yang iurutkan dari paling populer. Analisis ini juga menampilkan informasi rinci tentang penggunaan setiap tipe pembayaran untuk setiap tahun.

5. Analisis Pelanggan :
Menganalisis perilaku pelanggan termasuk rata-rata pelanggan aktif, pelanggan baru, dan pelanggan dengan pesanan berulang, dan menampilkan rata-rata jumlah pesanan yang dilakukan oleh pelanggan setiap tahun.

# Kesimpulan
Analisis menggunakan SQL memberikan wawasan penting tentang performa e-commerce, termasuk tren pendapatan tahunan, frekuensi pembatalan pesanan, kategori produk yang berpendapatan tinggi atau sering dibatalkan, dan preferensi metode pembayaran. Analisis perilaku pelanggan mengungkap pola aktivitas bulanan, jumlah pelanggan baru, dan frekuensi pesanan berulang. Temuan ini memungkinkan perusahaan untuk mengoptimalkan strategi pemasaran, meningkatkan pengalaman pelanggan, dan mengelola produk dengan lebih baik.

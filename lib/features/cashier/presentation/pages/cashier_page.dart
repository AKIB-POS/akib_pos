import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/main.dart';
import 'package:flutter/material.dart';


class CashierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromRGBO(248, 248, 248, 1),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Cafe Arrazzaq', style: TextStyle(color: Colors.black, fontSize: 18)),
                          Text('Fadhil Muhaimin', style: TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari Produk',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.discount, color: Colors.black),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Nama Pelanggan', style: TextStyle(color: Colors.black, fontSize: 18)),
                            Text('No. Order: 0001', style: TextStyle(color: Colors.black, fontSize: 14)),
                          ],
                        ),
                        Icon(Icons.edit, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box, size: 100, color: Colors.orange),
                SizedBox(height: 20),
                Text('Belum Ada Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Tambah produk terlebih dahulu untuk bisa mengatur sesuai kebutuhan'),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nama Pelanggan', style: TextStyle(fontSize: 16)),
                Text('No. Order: 0001', style: TextStyle(fontSize: 12)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dine In'),
                    Radio(value: true, groupValue: true, onChanged: (value) {}),
                    SizedBox(width: 20),
                    Text('Take Away'),
                    Radio(value: false, groupValue: true, onChanged: (value) {}),
                  ],
                ),
                Icon(Icons.shopping_cart, size: 100, color: Colors.orange),
                SizedBox(height: 20),
                Text('Keranjang Masih Kosong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Silahkan tambahkan produk ke keranjang melalui katalog yang ada'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Bayar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(244, 96, 63, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
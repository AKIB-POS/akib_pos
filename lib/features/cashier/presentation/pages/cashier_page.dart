import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_search_cubit.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';


class CashierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: appBar(context),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_box, size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                BlocBuilder<CashierSearchCubit, String>(
                  builder: (context, searchText) {
                    return Text(
                      searchText.isEmpty ? 'Belum Ada Produk' : searchText,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                    'Tambah produk terlebih dahulu untuk bisa mengatur sesuai kebutuhan'),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nama Pelanggan', style: TextStyle(fontSize: 16)),
                const Text('No. Order: 0001', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dine In'),
                    Radio(value: true, groupValue: true, onChanged: (value) {}),
                    const SizedBox(width: 20),
                    const Text('Take Away'),
                    Radio(value: false, groupValue: true, onChanged: (value) {}),
                  ],
                ),
                const Icon(Icons.shopping_cart, size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                const Text('Keranjang Masih Kosong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    'Silahkan tambahkan produk ke keranjang melalui katalog yang ada'),
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
              child: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Bayar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(244, 96, 63, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
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
                        icon: SvgPicture.asset(
                          "assets/icons/ic_burger_menu.svg",
                          height: 50,
                          width: 50,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cafe Arrazzaq', style: AppTextStyle.headline5),
                      Text('Fadhil Muhaimin', style: AppTextStyle.body2),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      child: Center(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Cari Produk',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 25.0),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search, color: Colors.black),
                              onPressed: () {
                                BlocProvider.of<CashierSearchCubit>(context)
                                    .updateSearchText(_controller.text);
                              },
                            ),
                          ),
                          onSubmitted: (text) {
                            BlocProvider.of<CashierSearchCubit>(context)
                                .updateSearchText(text);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.discount, color: Colors.black),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Nama Pelanggan',
                            style: TextStyle(color: Colors.black, fontSize: 18)),
                        Text('No. Order: 0001',
                            style: TextStyle(color: Colors.black, fontSize: 14)),
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
    );
  }
}

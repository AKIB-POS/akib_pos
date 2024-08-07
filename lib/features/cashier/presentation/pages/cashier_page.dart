import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

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
                BlocBuilder<CashierCubit, String>(
                  builder: (context, searchText) {
                    return Text(
                      searchText.isEmpty ? 'Belum Ada Produk' : searchText,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text('Tambah produk terlebih dahulu untuk bisa mengatur sesuai kebutuhan'),
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
                    Radio(
                        value: false, groupValue: true, onChanged: (value) {}),
                  ],
                ),
                const Icon(Icons.shopping_cart,
                    size: 100, color: Colors.orange),
                const SizedBox(height: 20),
                const Text('Keranjang Masih Kosong',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    'Silahkan tambahkan produk ke keranjang melalui katalog yang ada'),
              ],
            ),
          ),
        ],
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
            section_one(_controller, context),
            section_two(),
          ],
        ),
      ),
    );
  }

  Expanded section_two() {
    return Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 2, 2.5.h),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset("assets/icons/ic_disc.svg",height: 3.5.h,width: 3.5.w,),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nama Pelanggan',
                          style:
                              TextStyle(color: Colors.black, fontSize: 18)),
                      Text('No. Order: 0001',
                          style:
                              TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                  SvgPicture.asset("assets/icons/ic_note.svg",height: 3.5.h,width: 3.5.w,),
                ],
              ),
            ),
          );
  }

  Expanded section_one(TextEditingController _controller, BuildContext context) {
    return Expanded(
            flex: 5,
            child: Row(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/ic_burger_menu.svg",
                        height: 6.w,
                        width: 6.h,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                const SizedBox(width: 10),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cafe Arrazzaq', style: AppTextStyle.headline6),
                    Text('Fadhil Muhaimin', style: AppTextStyle.body3),
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
                            horizontal: 16,
                            vertical: 8.0,
                          ),
                          suffixIcon: IconButton(
                            icon:
                                const Icon(Icons.search, color: Colors.black),
                            onPressed: () {
                              BlocProvider.of<CashierCubit>(context)
                                  .updateSearchText(_controller.text);
                            },
                          ),
                        ),
                        onSubmitted: (text) {
                          BlocProvider.of<CashierCubit>(context)
                              .updateSearchText(text);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50.0, 
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/ic_save.svg",
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

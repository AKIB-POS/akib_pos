import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/stockist/data/models/vendor.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/pages/vendor/add_vendor_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class VendorListPage extends StatefulWidget {
  const VendorListPage({Key? key}) : super(key: key);

  @override
  State<VendorListPage> createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  final TextEditingController _searchController = TextEditingController();
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  List<Vendor> filteredVendors = [];

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    await context.read<GetVendorCubit>().fetchVendors(branchId: branchId);
  }

  void _filterVendors(String query, List<Vendor> vendors) {
    setState(() {
      filteredVendors = vendors
          .where((vendor) =>
              vendor.vendorName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: const Text('Daftar Vendor', style: AppTextStyle.headline5),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<GetVendorCubit, GetVendorState>(
                builder: (context, state) {
                  if (state is GetVendorLoading) {
                    return _buildLoading();
                  } else if (state is GetVendorLoaded) {
                    final vendors = state.vendorList.vendors;
                    if (_searchController.text.isEmpty) {
                      filteredVendors = vendors;
                    }
                    if (vendors.isEmpty) {
                      return Utils.buildEmptyStatePlain(
                        "Tidak Ada Vendor",
                        "Belum ada vendor yang terdaftar.",
                      );
                    } else {
                      return _buildVendorList(filteredVendors);
                    }
                  } else if (state is GetVendorError) {
                    return Utils.buildErrorStatePlain(
                      title: "Gagal Memuat Data",
                      message: state.message,
                      onRetry: _fetchVendors,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton:
            Utils.buildFloatingActionButton(onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddVendorPage(),
            ),
          );

          // Jika result true, refresh data cuti
          if (result == true) {
            _fetchVendors(); // Panggil fungsi untuk refresh data
          }
        }));
  }

  // Build search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          final vendors = context.read<GetVendorCubit>().state;
          if (vendors is GetVendorLoaded) {
            _filterVendors(value, vendors.vendorList.vendors);
          }
        },
        decoration: InputDecoration(
          hintText: 'Cari Vendor',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  // Build loading state (shimmer)
  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Utils.buildLoadingCardShimmer(), // Shimmer effect widget
      ),
    );
  }

  // Build vendor list
  Widget _buildVendorList(List<Vendor> vendors) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 70),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return _buildVendorItem(vendor);
      },
    );
  }

  // Build individual vendor item
  Widget _buildVendorItem(Vendor vendor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vendor.vendorName,
            style: AppTextStyle.headline5,
          ),
          const SizedBox(height: 8),
          Text(vendor.phoneNumber, style: AppTextStyle.caption),
          const SizedBox(height: 4),
          Text(vendor.address, style: AppTextStyle.caption),
        ],
      ),
    );
  }
}

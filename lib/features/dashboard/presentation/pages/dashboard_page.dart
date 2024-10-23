import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/dashboard/data/models/branch.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/branch_interaction_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_accounting_summary_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_stock_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_top_products_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_purchase_chart_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_sales_chart_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/appbar_dashboard_page.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/branch_info.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/dashboard_accounting_summary_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/dashboard_hrd_summary_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/dashboard_stock_summary_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/purchase_chart_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/sales_chart_widget.dart';
import 'package:akib_pos/features/dashboard/presentation/widgets/top_product_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final BranchInteractionCubit _branchInteractionCubit;
  String? selectedBranchName;
  int? selectedBranchId;
  bool isLoading = true;
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  late final MobilePermissions? permissions;
  @override
  void initState() {
    super.initState();
    _branchInteractionCubit =
        BranchInteractionCubit(authSharedPref: _authSharedPref);
    permissions = _authSharedPref.getMobilePermissions();
    _loadInitialBranch();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Current role: ${_authSharedPref.getEmployeeRole()}");

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: AppbarDashboardPage(),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: _onRefresh, // Pull-to-refresh handler
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BranchInfo(onTap: () => _showBranchPicker(context)),

              // Menggunakan ternary operator
              if (_authSharedPref.getEmployeeRole() == "employee")
                employeeItem(),

              if (_authSharedPref.getEmployeeRole() == "owner" ||
                  _authSharedPref.getEmployeeRole() == "manager")
                dashboardItem(), // Jika employeeRole tidak null

              if (_authSharedPref.getEmployeeRole() == null) dashboardItem()
            ],
          ),
        ),
      ),
    );
  }

  Column dashboardItem() {
    return Column(
      children: [
        if (permissions?.dashboard.contains("accounting") ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: DashboardAccountingSummaryWidget(
                branchId: selectedBranchId ?? 1),
          ),
        const SizedBox(height: 12),
        // Check permission and display widget accordingly

        if (permissions?.dashboard.contains("cashier") ?? false)
          TopProductWidget(branchId: selectedBranchId ?? 1),

        if (permissions?.dashboard.contains("accounting") ?? false)
          SalesChartWidget(branchId: selectedBranchId ?? 1),

        if (permissions?.dashboard.contains("cashier") ?? false)
          PurchaseChartWidget(branchId: selectedBranchId ?? 1),

        if (permissions?.dashboard.contains("hr") ?? false)
          DashboardHrdSummaryWidget(branchId: selectedBranchId ?? 1),

        if (permissions?.dashboard.contains("stok") ?? false)
          DashboardStockSummaryWidget(branchId: selectedBranchId ?? 1),
      ],
    );
  }

  Future<void> _onRefresh() async {
    // Run both fetch operations concurrently using Future.wait
    // Buat list task yang akan dijalankan
    List<Future<void>> fetchTasks = [];

    // Load data berdasarkan izin akses
    if (permissions?.dashboard.contains("accounting") ?? false) {
      fetchTasks.add(context.read<GetDashboardAccountingSummaryCubit>().fetchAccountingSummary(
        branchId: selectedBranchId ?? 1,
      ));
      fetchTasks.add(context.read<GetSalesChartCubit>().fetchSalesChart(
        branchId: selectedBranchId ?? 1,
      ));
    }

    if (permissions?.dashboard.contains("cashier") ?? false) {
      fetchTasks.add(context.read<GetDashboardTopProductsCubit>().fetchTopProducts(
        branchId: selectedBranchId ?? 1,
      ));
      fetchTasks.add(context.read<GetPurchaseChartCubit>().fetchPurchaseChart(
        branchId: selectedBranchId ?? 1,
      ));
    }

    if (permissions?.dashboard.contains("hr") ?? false) {
      fetchTasks.add(context.read<GetDashboardSummaryHrdCubit>().fetchDashboardHrdSummary(
        branchId: selectedBranchId ?? 1,
      ));
    }

    if (permissions?.dashboard.contains("stok") ?? false) {
      fetchTasks.add(context.read<GetDashboardSummaryStockCubit>().fetchDashboardStockSummary(
        branchId: selectedBranchId ?? 1,
      ));
    }

    fetchTasks.add(context.read<GetBranchesCubit>().fetchBranches());

    // Run all tasks concurrently
    await Future.wait(fetchTasks);
  }

  Future<void> _loadInitialBranch() async {
    // Panggil cubit fetchBranches di sini

    final branchList = _authSharedPref.getBranchList();

    if (branchList.isNotEmpty) {
      final branchId = _authSharedPref.getBranchId();

      final branch = branchList.firstWhere(
        (b) => b.id == branchId,
        orElse: () => branchList[0],
      );

      setState(() {
        selectedBranchId = branchId;
        selectedBranchName = branch.branchName;
        isLoading = false;
      });

      _branchInteractionCubit.selectBranch(branch);

      // Fetch accounting summary setelah memilih branch
      _onRefresh();
    } else {
      _onRefresh();
    }
  }

  Future<void> _showBranchPicker(BuildContext context) async {
    final branchInteractionCubit = context.read<BranchInteractionCubit>();
    final branchList = _authSharedPref.getBranchList();
    String? tempSelectedBranchName = branchInteractionCubit.state.branchName;

    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textGrey300,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Branch',
                          style: AppTextStyle.headline5,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: branchList.length,
                      itemBuilder: (context, index) {
                        final branch = branchList[index];
                        return RadioListTile<String>(
                          title: Text(branch.branchName),
                          value: branch.branchName,
                          groupValue: tempSelectedBranchName,
                          activeColor: AppColors.primaryMain,
                          onChanged: (String? value) {
                            setState(() {
                              tempSelectedBranchName = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMain,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (tempSelectedBranchName != null) {
                          final selectedBranch = branchList.firstWhere(
                            (b) => b.branchName == tempSelectedBranchName,
                          );

                          branchInteractionCubit.selectBranch(selectedBranch);
                          _onRefresh();
                        }
                      },
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget employeeItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Text(
            "Dashboard",
            style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
                image: ExtendedAssetImageProvider(
                    "assets/images/dashboard_welcome.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Datang",
                  style: AppTextStyle.caption.copyWith(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Selamat Beraktifitas",
                  style: AppTextStyle.bigCaptionBold
                      .copyWith(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

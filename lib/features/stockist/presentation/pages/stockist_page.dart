import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/stockist/presentation/widgets/appbar_stockist_content.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class StockistPage extends StatefulWidget {
  const StockistPage({super.key});
	@override
	createState() => _StockistPage();
}

class _StockistPage extends State<StockistPage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      appBar: PreferredSize(preferredSize: Size.fromHeight(8.h), child: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        flexibleSpace: SafeArea(child: AppbarStockistContent()),
      ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryMain,
        onRefresh: () {
          
        },
        child: ListView(
          children: [
            
          ],
        ),
        )
    );
	}
}

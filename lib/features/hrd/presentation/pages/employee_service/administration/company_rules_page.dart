import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/company_rules_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CompanyRulesPage extends StatefulWidget {
  const CompanyRulesPage({Key? key}) : super(key: key);

  @override
  _CompanyRulesPageState createState() => _CompanyRulesPageState();
}

class _CompanyRulesPageState extends State<CompanyRulesPage> {
  @override
  void initState() {
    super.initState();
    _fetchCompanyRules();
  }

  void _fetchCompanyRules() {
    context.read<CompanyRulesCubit>().fetchCompanyRules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Peraturan Perusahaan', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<CompanyRulesCubit, CompanyRulesState>(
        builder: (context, state) {
          if (state is CompanyRulesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompanyRulesError) {
            return _buildErrorState(state.message);
          } else if (state is CompanyRulesLoaded) {
            return _buildCompanyRulesContent(state.companyRulesResponse.companyRules);
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }

  // Method untuk menampilkan konten peraturan perusahaan
  Widget _buildCompanyRulesContent(String companyRules) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchCompanyRules();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HtmlWidget(
            companyRules,
            textStyle: const TextStyle(fontSize: 16),
            customStylesBuilder: (element) {
              if (element.localName == 'li') {
                return {'margin-bottom': '8px'};
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Method untuk menampilkan error state dengan tombol refresh
  Widget _buildErrorState(String errorMessage) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchCompanyRules();
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: AppThemes.elevatedBUttonPrimaryStyle,
                onPressed: _fetchCompanyRules,
                child: const Text('Coba Lagi',),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
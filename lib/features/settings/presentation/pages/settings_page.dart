import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/settings/presentation/pages/change_password_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/help_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/personal_information_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/terms_agreement_page.dart';
import 'package:akib_pos/features/settings/presentation/widgets/appbar_setting_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 1,
          flexibleSpace: SafeArea(child: AppBarSettingContent()),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Akun Section
            _buildSectionTitle("Akun"),
            _buildSettingsItem(
              title: "Informasi Personal",
              iconPath: "assets/icons/setting/ic_profile.svg",
              onTap: () {
                Utils.navigateToPage(context, PersonalInformationPage());
              },
            ),
            _buildSettingsItem(
              title: "Ubah Kata Sandi",
              iconPath: "assets/icons/setting/ic_change_password.svg",
              onTap: () {
                // Action for Ubah Kata Sandi
                Utils.navigateToPage(context, ChangePasswordPage());
              },
            ),
            const SizedBox(height: 24),
            // Lainnya Section
            _buildSectionTitle("Lainnya"),
            _buildSettingsItem(
              title: "Kebijakan Privasi",
              iconPath: "assets/icons/setting/ic_privacy_policy.svg",
              onTap: () {
                Utils.navigateToPage(context, PrivacyPolicyPage());
              },
            ),
            _buildSettingsItem(
              title: "Syarat dan Ketentuan",
              iconPath: "assets/icons/setting/ic_terms_condition.svg",
              onTap: () {
                Utils.navigateToPage(context, TermsAgreementPage());
              },
            ),
            _buildSettingsItem(
              title: "Bantuan",
              iconPath: "assets/icons/setting/ic_help.svg",
              onTap: () {
                // Action for Bantuan
                Utils.navigateToPage(context, HelpPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to build section title (Akun, Lainnya)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: AppTextStyle.headline5,
      ),
    );
  }

  // Method to build each settings item (ListTile)
  Widget _buildSettingsItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(iconPath, height: 24, width: 24),
        title: Text(
          title,
          style: AppTextStyle.bodyInput,
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textGrey600),
        onTap: onTap,
      ),
    );
  }
}

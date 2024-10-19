import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        title: const Text('Bantuan', style: AppTextStyle.headline5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/setting/bg_kepegawaian.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Haloo, ada yang bisa dibantu?",
                    style:
                        AppTextStyle.headline5.copyWith(color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                    "Kamu bisa menghubungi customer\nservice atau datang langsung ke Kantor",
                    style: AppTextStyle.caption.copyWith(color: Colors.white)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Utils.whatsapp(
                        "+628114129168", "Halo, Saya Ingin Mengajukan Support");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    "Customer Service",
                    style: AppTextStyle.bigCaptionBold
                        .copyWith(color: AppColors.primaryMain),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("Alamat Kantor", style: AppTextStyle.headline5),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/icons/setting/ic_office.svg"),
                const SizedBox(height: 16),
          Text("Akib Tech", style: AppTextStyle.headline5),
                const SizedBox(height: 16),
          Text("Jl. Dahlia No.10, RT.001/RW.01, Maccini Sombala, Kec. Tamalate, Kota Makassar, Sulawesi Selatan 90224", style: AppTextStyle.caption),
              ],
            ),

          )
        ],
      ),
    );
  }
}

import 'package:akib_pos/features/auth/presentation/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';
import '../../../../common/app_themes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  TextEditingController emailController = TextEditingController();

  _sendResetPasswordLink(){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/identity/content_right.png',)
            )
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 12
            ),
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.8,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.backgroundWhite,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow.withOpacity(0.07),
                      blurRadius: 0.32,
                      offset: Offset(0,4),
                      spreadRadius: 0
                  )
                ]
            ),
            padding: isLandscape ? EdgeInsets.all(60) : EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lupa password? silahkan masukkan email", style: AppTextStyle.headline4,),
                  const SizedBox(height: 12,),
                  const Text("*Email", style: AppTextStyle.body2,),
                  const SizedBox(height: 8,),
                  FormBuilderTextField(
                      name: 'email',
                      controller: emailController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Harap isi email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppThemes.inputDecorationStyle.copyWith(
                          hintText: "Email"
                      )
                  ),
                  const SizedBox(height: 12,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      onPressed: () async {
                        await _sendResetPasswordLink();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text("Kirim", style: AppTextStyle.body2.copyWith(
                              color: AppColors.backgroundWhite,
                              fontWeight: FontWeight.w700
                          ),)
                      )
                  ),
                ],
              ),
            ),
          )
      ),
      ),
    );
  }
}

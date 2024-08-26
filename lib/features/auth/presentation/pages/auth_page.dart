import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:akib_pos/features/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:akib_pos/common/app_colors.dart';


class AuthPage extends StatefulWidget {
  final bool isCashier;

  AuthPage({super.key, this.isCashier = false});

  @override
  createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String currentPage = "Login";
  int currentSteps = 0;

  bool _passwordVisible = false;
  bool _isLoading = false;

  void _unfocusAllFields() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = isTabletDevice(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                  _unfocusAllFields();
                } else if (state is AuthError) {
                  setState(() {
                    _isLoading = false;
                  });
                  _unfocusAllFields();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is AuthLoginSuccess) {
                  setState(() {
                    _isLoading = false;
                  });
                  _navigateToHome(context);
                } else if (state is AuthRegisterSuccess) {
                  setState(() {
                    _isLoading = false;
                  });
                  _unfocusAllFields();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Registrasi berhasil, silakan login")),
                  );
                  setState(() {
                    currentPage = "Login";
                  });
                }
              },
              child: isTablet ? landscapeView() : verticalView(),
            ),
            if (_isLoading)
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(20),color: Colors.white,
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    _unfocusAllFields();
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pop(context); // Close the loading indicator
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  void _login(BuildContext context) {
    _unfocusAllFields();

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      context.read<AuthCubit>().login(email, password);
    } else {
      _unfocusAllFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap mengisi data yang diperlukan")),
      );
    }
  }

  Widget landscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset('assets/identity/content_right.png', fit: BoxFit.cover),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundGrey,
            ),
            child: formLogin(),
          ),
        )
      ],
    );
  }

  Widget verticalView() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/identity/content_right.png'),
        ),
      ),
      child: formLogin(),
    );
  }

  Widget formLogin() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: isTabletDevice(context) ? screenWidth / 2 * 0.8 : screenWidth * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.backgroundWhite,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.07),
              blurRadius: 0.32,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.all(60),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Login untuk memulai", style: AppTextStyle.headline4),
                const SizedBox(height: 12),
                const Text("*Email atau Username", style: AppTextStyle.body2),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'username',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap isi Email/Username';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Harap masukkan email yang valid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppThemes.inputDecorationStyle.copyWith(hintText: "Email atau Username"),
                ),
                const SizedBox(height: 12),
                const Text("Password", style: AppTextStyle.body2),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'password',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap isi password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  decoration: AppThemes.inputDecorationStyle.copyWith(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGrey500,
                      ),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              checkColor: AppColors.backgroundWhite,
                              hoverColor: AppColors.primaryDark,
                              fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return AppColors.primaryMain;
                                }
                                return AppColors.backgroundWhite;
                              }),
                              side: const BorderSide(color: AppColors.primaryMain),
                              value: false,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("Tetap Masuk", style: AppTextStyle.body4),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Lupa Password?",
                        style: AppTextStyle.body4.copyWith(color: AppColors.primaryMain),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: _isLoading ? null : () => _login(context),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Masuk",
                      style: AppTextStyle.body2.copyWith(
                        color: AppColors.backgroundWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentSteps = 0;
                      currentPage = currentPage == "Login" ? "Register" : "Login";
                    });
                  },
                  child: Text(
                    "Belum punya akun? daftar di sini",
                    style: AppTextStyle.body2.copyWith(color: AppColors.primaryMain),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isTabletDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final aspectRatio = width / height;

    return aspectRatio >= 1.0 && width >= 600;
  }
}
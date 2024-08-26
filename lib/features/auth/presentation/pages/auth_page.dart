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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _registerFormKey = GlobalKey<FormBuilderState>();

  final PageController pageController = PageController();

  String currentPage = "Login";
  int currentSteps = 0;

  bool _passwordVisible = false;
  bool _isLoading = false;

  bool _rePasswordVisible = false;

  bool _isSaveUsername = false;
  bool _isAcceptedTermsAndCondition = false;

  void _unfocusAllFields() {
    FocusScope.of(context).unfocus();
  }

  switchPage(){
    currentSteps = 0;
    if(currentPage == "Login"){
      currentPage = "Register";
    }
    else{
      currentPage = "Login";
    }
    setState(() {});
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

  void _register(BuildContext context) {
    _unfocusAllFields();

    if (_registerFormKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final passwordConfirmation = _passwordConfirmationController.text.trim();
      final companyName = _companyNameController.text.trim();
      final companyPhone = _companyPhoneController.text.trim();
      final companyEmail = _companyEmailController.text.trim();
      final companyAddress = _companyAddressController.text.trim();

      context.read<AuthCubit>().register(
        username: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        companyName: companyName,
        companyPhone: companyPhone,
        companyEmail: companyEmail,
        companyAddress: companyAddress,
      );
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
            child: currentPage == "Login" ? formLogin() : formSignup(),
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
      child: currentPage == "Login" ? formLogin() : formSignup(),
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
                              fillColor: WidgetStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primaryMain;
                                }
                                return AppColors.backgroundWhite;
                              }),
                              side: const BorderSide(color: AppColors.primaryMain),
                              value: _isSaveUsername,
                              onChanged: (val) {
                                _isSaveUsername = val?? false;
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

  Widget formSignup() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 12
            ),
            constraints: BoxConstraints(
              maxWidth: isTabletDevice(context) ? screenWidth/2 * 0.8 : screenWidth * 0.8,
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
            padding: EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Form Pendaftaran Akun", style: AppTextStyle.headline4,),
                const SizedBox(height: 12,),
                Expanded(
                  child: FormBuilder(
                    key: _registerFormKey,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (pageIndex){
                        currentSteps = pageIndex;
                        setState(() {});
                      },
                      children: [
                        formUser(),
                        formCompany(),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero
                    ),
                    onPressed: (){
                      switchPage();
                    },
                    child: Text("Sudah punya akun? masuk di sini", style: AppTextStyle.body2.copyWith(
                        color: AppColors.primaryMain
                    ),)
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () async {
                      if(currentSteps == 1){
                        if(_registerFormKey.currentState!.validate()){
                          if(_isAcceptedTermsAndCondition == false){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Harap setujui syarat dan ketentuan")));
                          }
                          else{
                            _register(context);
                          }
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Harap mengisi semua data yang diperlukan")));
                        }
                      }
                      else{
                        if(_nameController.text.isNotEmpty
                            && _emailController.text.isNotEmpty
                            && _passwordController.text.isNotEmpty
                            && _passwordConfirmationController.text.isNotEmpty){
                          pageController.animateToPage(currentSteps+1, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Harap mengisi semua data yang diperlukan")));
                        }
                      }
                    },
                    child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(currentSteps == 0 ? "Berikutnya" : "Daftar", style: AppTextStyle.body2.copyWith(
                            color: AppColors.backgroundWhite,
                            fontWeight: FontWeight.w700
                        ),)
                    )
                ),
              ],
            )
        )
    );
  }

  Widget formUser(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Halaman Pengguna", style: AppTextStyle.headline6,),
          const SizedBox(height: 12,),
          const Text("*Nama", style: AppTextStyle.body2,),
          const SizedBox(height: 8,),
          FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: 'name',
              controller: _nameController,
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Harap isi nama anda';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: AppThemes.inputDecorationStyle.copyWith(
                  hintText: "Nama"
              )
          ),
          const SizedBox(height: 12,),
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("*Email", style: AppTextStyle.body2,),
                  const SizedBox(height: 8,),
                  FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      name: 'email',
                      controller: _emailController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Harap isi email anda';
                        }

                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Harap masukkan email yang valid';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: AppThemes.inputDecorationStyle.copyWith(
                          hintText: "Email"
                      )
                  ),
                ],
              )),
              SizedBox(width: 12,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("No Telepon", style: AppTextStyle.body2,),
                  const SizedBox(height: 8,),
                  FormBuilderTextField(
                      name: 'phone',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: AppThemes.inputDecorationStyle.copyWith(
                          hintText: "No Telepon"
                      )
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 12,),
          const Text("*Password", style: AppTextStyle.body2,),
          const SizedBox(height: 8,),
          FormBuilderTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'password',
            controller: _passwordController,
            obscureText: !_passwordVisible,
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Harap isi password anda';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            decoration: AppThemes.inputDecorationStyle.copyWith(
                hintText: "Password",
                suffixIcon: IconButton(
                    onPressed: (){
                      _passwordVisible = !_passwordVisible;
                      setState(() {

                      });
                    },
                    icon: Icon(
                      _passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textGrey500,
                    )
                )
            ),
          ),
          const SizedBox(height: 12,),
          const Text("*Konfirmasi Password", style: AppTextStyle.body2,),
          const SizedBox(height: 8,),
          FormBuilderTextField(
            name: 'repassword',
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordConfirmationController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Harap melakukan pengisian ulang password anda';
              }
              else if(value.isNotEmpty && value.compareTo(_passwordController.text) != 0){
                return 'Password tidak sama, ulangi password';
              }
              return null;
            },
            decoration: AppThemes.inputDecorationStyle.copyWith(
                hintText: "Konfirmasi Password",
                suffixIcon: IconButton(
                    onPressed: (){
                      _rePasswordVisible = !_rePasswordVisible;
                      setState(() {

                      });
                    },
                    icon: Icon(
                      _rePasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textGrey500,
                    )
                )
            ),
            obscureText: !_rePasswordVisible,
          )
        ],
      )
    );


  }

  Widget formCompany(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Halaman Perusahaan", style: AppTextStyle.headline6,),
          const SizedBox(height: 12,),
          const Text("Nama Perushaan ", style: AppTextStyle.body2,),
          const SizedBox(height: 8,),
          FormBuilderTextField(
              name: 'companyName',
              controller: _companyNameController,
              keyboardType: TextInputType.text,
              decoration: AppThemes.inputDecorationStyle.copyWith(
                  hintText: "Nama Perusahaan "
              )
          ),
          const SizedBox(height: 12,),
          Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("*Email Perushaan ", style: AppTextStyle.body2,),
                      const SizedBox(height: 8,),
                      FormBuilderTextField(
                          name: 'companyEmail',
                          controller: _companyEmailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return "Harap isi email perusahaan";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                              hintText: "Email Perusahaan "
                          )
                      ),
                    ],
                  )
              ),
              SizedBox(width: 12,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nomor Perushaan ", style: AppTextStyle.body2,),
                      const SizedBox(height: 8,),
                      FormBuilderTextField(
                          name: 'companyPhone',
                          controller: _companyPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                              hintText: "Nomor Telepon Perusahaan "
                          )
                      ),
                    ],
                  )
              )
            ],
          ),
          const SizedBox(height: 12,),
          const Text("Alamat Perusahaan", style: AppTextStyle.body2,),
          const SizedBox(height: 8,),
          FormBuilderTextField(
              name: 'companyAddress',
              controller: _companyAddressController,
              keyboardType: TextInputType.text,
              decoration: AppThemes.inputDecorationStyle.copyWith(
                  hintText: "Alamat Perusahaan "
              )
          ),
          const SizedBox(height: 12,),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                    checkColor: AppColors.backgroundWhite,
                    hoverColor: AppColors.primaryDark,
                    fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) { // When the checkbox is checked
                        return AppColors.primaryMain;
                      }
                      return AppColors.backgroundWhite; // Default color when unchecked
                    }),
                    side: const BorderSide(
                        color: AppColors.primaryMain
                    ),
                    value: _isAcceptedTermsAndCondition, onChanged: (val){
                  _isAcceptedTermsAndCondition = val ?? false;
                  setState(() {

                  });
                }),
              ),
              TextButton(
                onPressed: (){
                  //TODO: go to terms and condition page
                },
                child: RichText(
                    text: TextSpan(
                        style: AppTextStyle.body4.copyWith(
                            color: AppColors.black
                        ),
                        children: [
                          TextSpan(text: "Saya telah menyetujui ",),
                          TextSpan(text: "syarat dan ketentuan", style: AppTextStyle.body4.copyWith(
                              color: AppColors.primaryMain
                          ))
                        ]
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:akib_pos/common/app_colors.dart';

class AuthPage extends StatefulWidget {
	bool isCashier;

  AuthPage({super.key, this.isCashier = false});
	@override
	createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
	// final FirebaseAuth _auth = FirebaseAuth.instance;
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


	PageController _pageController = PageController();

	String currentPage = "Login";
	int currentSteps = 0;
	bool _passwordVisible = false;
	bool _rePasswordVisible = false;

	bool _isSaveUsername = false;
	bool _isAcceptedTermsAndCondition = false;

	bool _canSwipe = false;

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

	Future<void> _login() async{
		try{

		} catch (e, stackTrace){

		}
	}

	Future<void> _register() async{
		try{

		} catch (e, stackTrace){

		}
	}

	// Future<void> _signInWithEmail() async {
	// 	try {
	// 		UserCredential userCredential = await _auth.signInWithEmailAndPassword(
	// 			email: _emailController.text,
	// 			password: _passwordController.text,
	// 		);
	// 		// Handle successful sign-in
	// 	} catch (e) {
	// 		// Handle error
	// 		print(e);
	// 	}
	// }

	// Future<void> _signInWithGoogle() async {
	// 	try {
	// 		final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
	// 		final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
	//
	// 		final UserCredential userCredential = await _auth.signInWithCredential(
	// 			GoogleAuthProvider.credential(
	// 				accessToken: googleAuth?.accessToken,
	// 				idToken: googleAuth?.idToken,
	// 			),
	// 		);
	//
	// 		print(userCredential.user!.getIdToken());
	// 		// Handle successful sign-in
	// 	} catch (e, stackTrace) {
	// 		// Handle error
	// 		print(e);
	// 		print(stackTrace);
	// 	}
	// }

	bool isTabletDevice(BuildContext context){
		final mediaQuery = MediaQuery.of(context);
		final width = mediaQuery.size.width;
		final height = mediaQuery.size.height;

		final aspectRatio = width/height;

		return aspectRatio >= 1.0 && width >= 600;
	}

	@override
  void initState() {
    super.initState();
  }

	@override
	Widget build(BuildContext context) {

		bool isTablet = isTabletDevice(context);

		return Scaffold(
			resizeToAvoidBottomInset: false,
			body: SafeArea(
				child: isTablet ? landscapeView() : verticalView(),
			)
		);
	}

  Widget landscapeView() {
		return Row(
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
					Expanded(
							child: Image.asset('assets/identity/content_right.png', fit: BoxFit.cover,)
					),
					Expanded(
							child: Container(
								decoration: const BoxDecoration(
									color: AppColors.backgroundGrey
								),
								child: currentPage == "Login" ? formLogin() : formSignup(),
							)
					)
			],
		);
	}

  Widget verticalView() {
		return Container(
			decoration: const BoxDecoration(
					image: DecorationImage(
						fit: BoxFit.cover,
						image: AssetImage('assets/identity/content_right.png',)
					)
			),
			child: currentPage == "Login" ? formLogin() : formSignup(),
		);
	}

	Widget formLogin() {
		final screenWidth = MediaQuery.of(context).size.width;
		return Center(
				child: Container(
					margin: const EdgeInsets.symmetric(
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
				  child: SingleChildScrollView(
				    child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								const Text("Login untuk memulai", style: AppTextStyle.headline4,),
								const SizedBox(height: 12,),
								const Text("*Email atau Username", style: AppTextStyle.body2,),
								const SizedBox(height: 8,),
								FormBuilderTextField(
									name: 'username',
									autovalidateMode: AutovalidateMode.onUserInteraction,
									controller: _nameController,
									validator: (value){
										if(value == null || value.isEmpty){
											return 'Harap isi Email/Username';
										}
										return null;
									},
									keyboardType: TextInputType.text,
									decoration: AppThemes.inputDecorationStyle.copyWith(
										hintText: "Email atau Username"
									)
								),
								const SizedBox(height: 12,),
								const Text("Password", style: AppTextStyle.body2,),
								const SizedBox(height: 8,),
								FormBuilderTextField(
									name: 'password',
									autovalidateMode: AutovalidateMode.onUserInteraction,
									controller: _passwordController,
									validator: (value){
										if(value == null || value.isEmpty){
											return 'Harap isi password';
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
									obscureText: !_passwordVisible,
								),
								const SizedBox(height: 12,),
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
															fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
																if (states.contains(WidgetState.selected)) { // When the checkbox is checked
																	return AppColors.primaryMain;
																}
																return AppColors.backgroundWhite; // Default color when unchecked
															}),
															side: const BorderSide(
																color: AppColors.primaryMain
															),
													  	value: _isSaveUsername, onChanged: (val){
													  	_isSaveUsername = val ?? false;
													  	setState(() {

													  	});
													  }),
													),
													const SizedBox(width: 8,),
													Text("Tetap Masuk", style: AppTextStyle.body4,)
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
											child: Text("Lupa Password?", style: AppTextStyle.body4.copyWith(
												color: AppColors.primaryMain
											),),
										)
									],
								),
								ElevatedButton(
										style: ElevatedButton.styleFrom(
											backgroundColor: AppColors.primaryMain,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(4.0),
											),
										),
										onPressed: (){

										},
										child: Container(
											width: double.infinity,
												alignment: Alignment.center,
												child: Text("Masuk", style: AppTextStyle.body2.copyWith(
													color: AppColors.backgroundWhite,
													fontWeight: FontWeight.w700
												),)
										)
								),
								TextButton(
										onPressed: (){
											switchPage();
										},
										child: Text("Belum punya akun? daftar di sini", style: AppTextStyle.body2.copyWith(
												color: AppColors.primaryMain
										),)
								),
								// const SizedBox(height: 20,),
								// Row(
								// 	mainAxisAlignment: MainAxisAlignment.center,
								// 	crossAxisAlignment: CrossAxisAlignment.center,
								// 	children: [
								// 		Expanded(
								// 			child: Container(
								// 				color: AppColors.textGrey300,
								// 				height: 1,
								// 			),
								// 		),
								// 		SizedBox(width: 11,),
								// 		Text("Atau", style: AppTextStyle.body2.copyWith(
								// 				color: AppColors.textGrey300
								// 		),),
								// 		SizedBox(width: 11,),
								// 		Expanded(
								// 			child: Container(
								// 				color: AppColors.textGrey300,
								// 				height: 1,
								// 			),
								// 		),
								// 	],
								// ),
								// const SizedBox(height: 20,),
								// ElevatedButton(
								// 	style: ElevatedButton.styleFrom(
								// 		backgroundColor: AppColors.backgroundWhite,
								// 		shape: RoundedRectangleBorder(
								// 			borderRadius: BorderRadius.circular(4.0),
								// 		),
								// 	),
								// 		onPressed: (){
								//
								// 		},
								// 		child: Row(
								// 			mainAxisAlignment: MainAxisAlignment.center,
								// 			children: [
								// 				SvgPicture.asset('assets/icons/ic_google.svg'),
								// 				SizedBox(width: 12,),
								// 				Text("Masuk dengan google", style: AppTextStyle.body2.copyWith(
								// 					fontWeight: FontWeight.w700,
								// 					color: AppColors.black
								// 				),)
								// 			],
								// 		)
								// )
							],
				    ),
				  ),
				)
		);
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
					      	key: _formKey,
					        child: PageView(
										physics: NeverScrollableScrollPhysics(),
					        	controller: _pageController,
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
											if(_formKey.currentState!.validate()){
												if(_isAcceptedTermsAndCondition == false){
													ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Harap setujui syarat dan ketentuan")));
												}
												else{
													await _register();
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
												_pageController.animateToPage(currentSteps+1, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
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
						obscureText: !_passwordVisible,
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
					),
				],
			),
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
					const SizedBox(height: 12,),
					const Text("No Telepon Perusahaan ", style: AppTextStyle.body2,),
					const SizedBox(height: 8,),
					FormBuilderTextField(
							name: 'companyPhone',
							controller: _companyPhoneController,
							keyboardType: TextInputType.phone,
							decoration: AppThemes.inputDecorationStyle.copyWith(
									hintText: "No Telepon Perusahaan "
							)
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
							const SizedBox(width: 8,),
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

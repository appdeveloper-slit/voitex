import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voitex/otp.dart';
import 'commonText/commontext.dart';
import 'manage/static_method.dart';
import 'sign_up.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late BuildContext ctx;
  bool _ischanged = true;
  TextEditingController mobileCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        // extendBodyBehindAppBar: false,
        backgroundColor: Clr().black,
        // bottomNavigationBar: Image.asset('assets/bottom_chart.png'),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Dim().d48, bottom: Dim().d20),
                  child: Image.asset("assets/loc.png",
                      height: Dim().d260, width: Dim().d260),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/bg.png'),fit: BoxFit.fitWidth)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Clr().transparent,
                      borderRadius: BorderRadius.all(Radius.circular(Dim().d12))
                    ),
                  ),
                )
                // Text(
                //   'Sign In',
                //   style: Sty().extraLargeText.copyWith(
                //       color: Clr().primaryColor,
                //       fontSize: Dim().d24,
                //       fontWeight: FontWeight.w600),
                // ),
                // SizedBox(
                //   height: Dim().d8,
                // ),
                // Text(
                //   'Fill the detail to sign in into your account.',
                //   style: Sty().smallText.copyWith(
                //       color: Clr().threezero,
                //       fontWeight: FontWeight.w400,
                //       fontSize: Dim().d16),
                // ),
                // SizedBox(
                //   height: Dim().d24,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                //   child: TextFormField(
                //     controller: mobileCtrl,
                //     cursorColor: Clr().primaryColor,
                //     style: Sty().smallText.copyWith(
                //         color: Clr().clr16,
                //         fontSize: Dim().d14,
                //         fontWeight: FontWeight.w400),
                //     maxLength: 10,
                //     keyboardType: TextInputType.number,
                //     textInputAction: TextInputAction.done,
                //     decoration: Sty().textFileddarklinestyle.copyWith(
                //           prefixIcon: Icon(
                //               mobileCtrl.text.isNotEmpty ? Icons.phone : Icons.phone_outlined,
                //               color: mobileCtrl.text.isNotEmpty ? Clr().primaryColor : Clr().a4),
                //           hintStyle: Sty().smallText.copyWith(
                //                 color: Clr().a4,
                //                 fontWeight: FontWeight.w400,
                //                 fontSize: Dim().d14,
                //               ),
                //           prefixText: mobileCtrl.text.isNotEmpty ? "+91 " : "",
                //           prefixStyle: Sty().smallText.copyWith(
                //               color:
                //                   mobileCtrl.text.isNotEmpty ? Clr().clr16 : Clr().transparent),
                //           hintText: "Enter Mobile Number",
                //           counterText: "",
                //           // prefixIcon: Icon(
                //           //   Icons.call,
                //           //   color: Clr().lightGrey,
                //           // ),
                //         ),
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Mobile field is required';
                //       }
                //       if (value.length != 10) {
                //         return 'Mobile number must be 10 digits';
                //       }
                //     },
                //   ),
                // ),
                // SizedBox(
                //   height: Dim().d32,
                // ),
                // _ischanged
                //     ? Padding(
                //         padding:
                //             EdgeInsets.symmetric(horizontal: Dim().d20),
                //         child: Container(
                //           width: double.infinity,
                //           decoration: BoxDecoration(
                //             color: Clr().clr01,
                //             borderRadius: BorderRadius.circular(Dim().d16),
                //           ),
                //           child: ElevatedButton(
                //               onPressed: () {
                //                 if (_formKey.currentState!.validate()) {
                //                   sendOtp();
                //                 }
                //                 // STM().redirect2page(
                //                 //     ctx, Verification(mobileCtrl.text.toString(), 'login'));
                //                 // updateProfile();
                //               },
                //               style: ElevatedButton.styleFrom(
                //                   elevation: 0,
                //                   primary: Colors.transparent,
                //                   onSurface: Colors.transparent,
                //                   shadowColor: Colors.transparent,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius:
                //                           BorderRadius.circular(5))),
                //               child: Text(
                //                 'Send OTP',
                //                 style: Sty().largeText.copyWith(
                //                     fontSize: 16,
                //                     color: Clr().f5,
                //                     fontWeight: FontWeight.w600),
                //               )),
                //         ),
                //       )
                //     : CircularProgressIndicator(
                //         color: Clr().primaryColor,
                //       ),
                // SizedBox(
                //   height: Dim().d12,
                // ),
              ],
            ),
          ),
        ));
  }

  void sendOtp() async {
    setState(() {
      _ischanged = false;
    });
    FormData body = FormData.fromMap({
      'phone': mobileCtrl.text,
      'action': 'login',
    });
    var result = await STM().postWithoutDialog(ctx, 'otp-send', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        _ischanged = true;
      });
      // ignore: use_build_context_synchronously
      STM().redirect2page(
          ctx, Verification(mobileCtrl.text.toString(), 'login'));
    } else {
      setState(() {
        _ischanged = true;
      });
      AwesomeDialog(
              context: ctx,
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              headerAnimationLoop: true,
              title: 'Note',
              desc: message,
              btnOkText: "OK",
              btnOkOnPress: () {},
              btnOkColor: Clr().errorRed)
          .show();
    }
  }
}

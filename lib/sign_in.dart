import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().transparent,
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Dim().d20),
                  child: Image.asset("assets/loc.png",
                      height: Dim().d260, width: Dim().d260),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Dim().d56, left: Dim().d12, right: Dim().d12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                          top: -50.0,
                          right: 2.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/b1.png', height: Dim().d40),
                              Image.asset('assets/b1.png',
                                  height: Dim().d140),
                            ],
                          )),
                      Positioned(
                          left: 2.0,
                          bottom: -56.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/b1.png',
                                  height: Dim().d120),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dim().d28),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Clr().white,width: 0.2),
                              borderRadius: BorderRadius.all(Radius.circular(Dim().d12))
                          ),
                          child: BlurryContainer(
                            blur: 10,
                            width: double.infinity,
                            color: Clr().transparent,
                            elevation: 0.5,
                            borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: Sty().extraLargeText.copyWith(
                                        color: Clr().white,
                                        fontSize: Dim().d24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  TextFormField(
                                    controller: mobileCtrl,
                                    cursorColor: Clr().primaryColor,
                                    style: Sty().smallText.copyWith(
                                        color: Clr().white,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w400),
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: Sty()
                                        .textFieldUnderlineStyle
                                        .copyWith(
                                      hintStyle: Sty().smallText.copyWith(
                                        color: Clr().clr67,
                                        fontWeight: FontWeight.w400,
                                        fontSize: Dim().d14,
                                      ),
                                      prefixText: mobileCtrl.text.isNotEmpty
                                          ? "+91 "
                                          : "",
                                      prefixStyle: Sty().smallText.copyWith(
                                          color: mobileCtrl.text.isNotEmpty
                                              ? Clr().clr16
                                              : Clr().transparent),
                                      hintText: "Enter Mobile Number",
                                      counterText: "",
                                      // prefixIcon: Icon(
                                      //   Icons.call,
                                      //   color: Clr().lightGrey,
                                      // ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile field is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile number must be 10 digits';
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: Dim().d20,
                                  ),
                                  Column(
                                    children: [
                                      _ischanged
                                          ? Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Clr().clr52,
                                          borderRadius:
                                          BorderRadius.circular(Dim().d12),
                                        ),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                sendOtp();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                primary: Colors.transparent,
                                                onSurface: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5))),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dim().d12),
                                              child: Text(
                                                'Send OTP',
                                                style: Sty().largeText.copyWith(
                                                    fontSize: Dim().d16,
                                                    color: Clr().white,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            )),
                                      )
                                          : CircularProgressIndicator(
                                        color: Clr().white,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "you haven't joined us yet ?",
                                            style: Sty().smallText.copyWith(
                                                fontSize: Dim().d14,
                                                fontWeight: FontWeight.w400,
                                                color: Clr().white),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              STM().redirect2page(ctx, SignUp());
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().clref,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Dim().d16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

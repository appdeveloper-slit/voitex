import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/bank_details.dart';
import 'package:voitex/kyc_details.dart';
import 'commonText/commontext.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'personal_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Verification extends StatefulWidget {
  final sMobile;
  final type;

  const Verification(this.sMobile, this.type, {Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late BuildContext ctx;

  bool again = false;

  TextEditingController otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().transparent,
          leading: IconButton(
              onPressed: () {
                STM().back2Previous(ctx);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Clr().white,
                size: Dim().d16,
              )),
        ),
        backgroundColor: Clr().black,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                            horizontal: Dim().d20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Clr().white,width: 0.2),
                              borderRadius: BorderRadius.all(Radius.circular(Dim().d12))
                          ),
                          child: BlurryContainer(
                            blur: 10,
                            width: double.infinity,
                            color: Clr().transparent,
                            elevation: 1.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d12)),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'OTP Verification',
                                    style: Sty().extraLargeText.copyWith(
                                        color: Clr().white,
                                        fontSize: Dim().d24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: 'Code has sent to +91 ',
                                          style: Sty().smallText.copyWith(
                                              color: Clr().white,
                                              fontSize: Dim().d14,
                                              fontWeight: FontWeight.w300),
                                          children: [
                                        TextSpan(
                                          text: '${widget.sMobile}',
                                          style: Sty().smallText.copyWith(
                                              color: Clr().white,
                                              fontSize: Dim().d14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ])),
                                  SizedBox(
                                    height: Dim().d28,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dim().d20),
                                    child: PinCodeTextField(
                                      controller: otpCtrl,
                                      // errorAnimationController: errorController,
                                      appContext: context,
                                      textStyle: Sty().largeText.copyWith(
                                          color: Clr().white,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400),
                                      length: 4,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      animationType: AnimationType.scale,
                                      cursorColor: Clr().white,
                                      cursorWidth: 1.0,
                                      errorTextSpace: 25.0,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.underline,
                                        fieldWidth: Dim().d48,
                                        fieldHeight: Dim().d52,
                                        activeColor: Clr().white,
                                        selectedColor: Clr().white,
                                        inactiveColor: Clr().clr67,
                                      ),
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'(.{4,})').hasMatch(value)) {
                                          return Str().invalidOtp;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Clr().clr52,
                                      borderRadius:
                                          BorderRadius.circular(Dim().d16),
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          verifyOtp();
                                          // if (widget.type == 'register') {
                                          //   STM().redirect2page(
                                          //       ctx,
                                          //       PersonalDetails(
                                          //         mobile: widget.sMobile,
                                          //       ));
                                          // } else {
                                          //   verifyOtp();
                                          //   // STM().finishAffinity(ctx, Home(
                                          //   //       b: true,
                                          //   //     ));
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary: Colors.transparent,
                                            onSurface: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        child: Text(
                                          'Verify',
                                          style: Sty().largeText.copyWith(
                                              fontSize: 16,
                                              color: Clr().f5,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Didn't receive code? ",
                                        style: Sty().smallText.copyWith(
                                            fontSize: Dim().d14,
                                            fontWeight: FontWeight.w400,
                                            color: Clr().white),
                                      ),
                                      Visibility(
                                        visible: !again,
                                        child: TweenAnimationBuilder<Duration>(
                                            duration: const Duration(seconds: 60),
                                            tween: Tween(
                                                begin:
                                                    const Duration(seconds: 60),
                                                end: Duration.zero),
                                            onEnd: () {
                                              // ignore: avoid_print
                                              // print('Timer ended');
                                              setState(() {
                                                again = true;
                                              });
                                            },
                                            builder: (BuildContext context,
                                                Duration value, Widget? child) {
                                              final minutes = value.inMinutes;
                                              final seconds =
                                                  value.inSeconds % 60;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Text(
                                                  " 0$minutes:$seconds",
                                                  textAlign: TextAlign.center,
                                                  style: Sty().smallText.copyWith(
                                                      color: Clr().clref,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              );
                                            }),
                                      ),
                                      // Visibility(
                                      //   visible: !isResend,
                                      //   child: Text("I didn't receive a code! ${(  sTime  )}",
                                      //       style: Sty().mediumText),
                                      // ),
                                      Visibility(
                                        visible: again,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              again = false;
                                            });
                                            resendOtp();
                                            // STM.checkInternet().then((value) {
                                            //   if (value) {
                                            //     sendOTP();
                                            //   } else {
                                            //     STM.internetAlert(ctx, widget);
                                            //   }
                                            // });
                                          },
                                          child: Text(
                                            'Resend',
                                            style: Sty().smallText.copyWith(
                                                color: Clr().clref,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void verifyOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var step;
    FormData body = FormData.fromMap({
      'phone': widget.sMobile,
      'otp': otpCtrl.text,
      'action': widget.type,
    });
    var result = await STM().post(ctx, Str().verifying, 'otp-verify', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.type == 'register') {
        // ignore: use_build_context_synchronously
        STM().successDialog(
            ctx,
            message,
            PersonalDetails(
              mobile: widget.sMobile,
            ));
      } else {
        sp.setString('token', result['token']);
        switch (result['data']['step']) {
          case 1:
            STM().redirect2page(ctx, KYCDetails());
            break;
          case 2:
            STM().redirect2page(ctx, BankDetails());
            break;
          case null:
            setState(() {
              sp.setBool('login', true);
            });
            STM().finishAffinity(
                ctx,
                Home(
                  b: true,
                ));
            break;
        }
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  resendOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'phone': widget.sMobile,
    });
    var result = await STM().post(ctx, Str().verifying, 'resend_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message, ToastGravity.BOTTOM);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}

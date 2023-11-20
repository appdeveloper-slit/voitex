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
        // resizeToAvoidBottomInset: false,
        // backgroundColor: Clr().white,
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Dim().d350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Clr().white,
                image: DecorationImage(
                    image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Dim().d52),
                    bottomLeft: Radius.circular(Dim().d52)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d20, vertical: Dim().d56),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () {
                          STM().back2Previous(ctx);
                        },
                        icon: Icon(Icons.arrow_back, color: Clr().f5)),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    cmnTxt().commonTextWidget('Your Personal'),
                    cmnTxt().commonTextWidget('Stock Guru'),
                    SizedBox(height: Dim().d8),
                    cmnTxt().commonTextWidgetOne(
                        'Navigate the Markets with Confidence'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Text(
              'OTP Verification',
              style: Sty().extraLargeText.copyWith(
                  color: Clr().primaryColor,
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
                        color: Clr().threezero,
                        fontSize: Dim().d16,
                        fontWeight: FontWeight.w400),
                    children: [
                  TextSpan(
                    text: '${widget.sMobile}',
                    style: Sty().smallText.copyWith(
                        color: Clr().clr02,
                        fontSize: Dim().d16,
                        fontWeight: FontWeight.w600),
                  ),
                ])),
            SizedBox(
              height: Dim().d28,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: PinCodeTextField(
                controller: otpCtrl,
                // errorAnimationController: errorController,
                appContext: context,
                enableActiveFill: true,
                textStyle: Sty().largeText.copyWith(
                    color: Color(0xff222222),
                    fontSize: Dim().d14,
                    fontWeight: FontWeight.w400),
                length: 4,
                obscureText: false,
                keyboardType: TextInputType.number,
                animationType: AnimationType.scale,
                cursorColor: Clr().primaryColor,
                cursorWidth: 1.0,
                errorTextSpace: 25.0,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  inactiveBorderWidth: 1.0,
                  activeBorderWidth: 1.0,
                  selectedBorderWidth: 1.0,
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                  fieldWidth: Dim().d60,
                  fieldHeight: Dim().d56,
                  selectedFillColor: Clr().transparent,
                  activeFillColor: Clr().transparent,
                  inactiveFillColor: Clr().transparent,
                  inactiveColor: Clr().a4,
                  activeColor: Clr().primaryColor,
                  selectedColor: Clr().primaryColor,
                ),
                animationDuration: const Duration(milliseconds: 200),
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Clr().clr01,
                  borderRadius: BorderRadius.circular(Dim().d16),
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
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      'Verify',
                      style: Sty().largeText.copyWith(
                          fontSize: 16,
                          color: Clr().f5,
                          fontWeight: FontWeight.w600),
                    )),
              ),
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
                      color: Clr().clr27),
                ),
                Visibility(
                  visible: !again,
                  child: TweenAnimationBuilder<Duration>(
                      duration: const Duration(seconds: 60),
                      tween: Tween(
                          begin: const Duration(seconds: 60),
                          end: Duration.zero),
                      onEnd: () {
                        // ignore: avoid_print
                        // print('Timer ended');
                        setState(() {
                          again = true;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            " 0$minutes:$seconds",
                            textAlign: TextAlign.center,
                            style: Sty().smallText.copyWith(
                                color: Clr().clr00,
                                fontWeight: FontWeight.w600),
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
                          color: Clr().clr00,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
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
    if(success){
      STM().displayToast(message, ToastGravity.BOTTOM);
    }else{
      STM().errorDialog(ctx, message);
    }
  }

}

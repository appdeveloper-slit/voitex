import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voitex/otp.dart';
import 'package:voitex/sign_in.dart';
import 'commonText/commontext.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;

  bool _ischanged = true;
  TextEditingController mobileCtrl2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        // extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        // backgroundColor: Clr().white,
        // bottomNavigationBar: Image.asset('assets/bottom_chart.png'),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
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
                            image: AssetImage('assets/bg.png'),
                            fit: BoxFit.cover),
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
                            IconButton(padding: EdgeInsets.zero,alignment: Alignment.centerLeft,onPressed: (){
                              STM().back2Previous(ctx);
                            }, icon: Icon(Icons.arrow_back,color: Clr().f5)),
                            SizedBox(height: Dim().d20,),
                            cmnTxt().commonTextWidget('Your Gateway'),
                            cmnTxt().commonTextWidget('to Wealth'),
                            SizedBox(height: Dim().d8),
                            cmnTxt().commonTextWidgetOne('Unleash the Power of Smart Trading'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Text(
                      'Sign Up',
                      style: Sty().extraLargeText.copyWith(
                          color: Clr().primaryColor,
                          fontSize: Dim().d24,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      'Enter mobile number to create an account',
                      style: Sty().smallText.copyWith(
                          color: Clr().threezero,
                          fontWeight: FontWeight.w400,
                          fontSize: Dim().d16),
                    ),
                    SizedBox(
                      height: Dim().d24,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                      child: TextFormField(
                        controller: mobileCtrl2,
                        cursorColor: Clr().primaryColor,
                        style: Sty().smallText.copyWith(
                            color: Clr().clr16,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: Sty().textFileddarklinestyle.copyWith(
                          prefixIcon: Icon(
                              mobileCtrl2.text.isNotEmpty ? Icons.phone : Icons.phone_outlined,
                              color: mobileCtrl2.text.isNotEmpty ? Clr().primaryColor : Clr().a4),
                          hintStyle: Sty().smallText.copyWith(
                            color: Clr().a4,
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d14,
                          ),
                          prefixText: mobileCtrl2.text.isNotEmpty ? "+91 " : "",
                          prefixStyle: Sty().smallText.copyWith(
                              color:
                              mobileCtrl2.text.isNotEmpty ? Clr().clr16 : Clr().transparent),
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
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    _ischanged
                        ? Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: Dim().d20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Clr().clr01,
                          borderRadius: BorderRadius.circular(Dim().d16),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                sendOtp();
                              }
                              // STM().redirect2page(
                              //     ctx, Verification(mobileCtrl2.text.toString(), 'register'));
                              // updateProfile();
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
                              'Send OTP',
                              style: Sty().largeText.copyWith(
                                  fontSize: 16,
                                  color: Clr().f5,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    )
                        : CircularProgressIndicator(
                      color: Clr().primaryColor,
                    ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: Dim().d20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By clicking, you have agreed to our',
                          style: Sty().smallText.copyWith(
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w400,
                              color: Clr().clr27
                          ),
                          children: [
                            WidgetSpan(
                              child: InkWell(
                                onTap: () {
                                  STM().openWeb('https://spectrai.in/terms&condition');
                                },
                                child: Text(
                                  ' Terms & Conditions ',
                                  style: Sty().mediumText.copyWith(
                                    color: Clr().clr00,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dim().d14,),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: 'read before going further.',
                              style: Sty().smallText.copyWith(
                                  fontSize: Dim().d14,
                                  fontWeight: FontWeight.w400,
                                  color: Clr().clr27),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                    style: Sty().smallText.copyWith(
                        fontSize: Dim().d14,
                        fontWeight: FontWeight.w600,
                        color: Clr().clr27)
                ),
                TextButton(
                  onPressed: () {
                    STM().redirect2page(ctx, SignIn());
                  },
                  child: Text(
                    'Sign In',
                    style: Sty().mediumText.copyWith(
                        color: Clr().clr00,
                        fontWeight: FontWeight.w700,
                        fontSize: Dim().d14),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void sendOtp() async {
    setState(() {
      _ischanged = false;
    });
    FormData body = FormData.fromMap({
      'phone': mobileCtrl2.text,
      'action': 'register',
    });
    var result = await STM().postWithoutDialog(ctx, 'otp-send', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        _ischanged = true;
      });
      STM().displayToast(message, ToastGravity.CENTER);
      STM().redirect2page(
          ctx, Verification(mobileCtrl2.text.toString(), 'register'));
    } else {
      setState(() {
        _ischanged = true;
      });
      STM().errorDialog(ctx, message);
    }
  }
}

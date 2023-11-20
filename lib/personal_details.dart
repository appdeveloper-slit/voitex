import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/otp.dart';
import 'package:voitex/sign_in.dart';
import 'kyc_details.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class PersonalDetails extends StatefulWidget {
  final mobile;

  const PersonalDetails({super.key, this.mobile});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  late BuildContext ctx;

  String? genderValue;
  List<dynamic> genderlist = ['Male', 'Female', 'Other'];
  bool isChanged = true;
  bool loading = true;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController dateofbirthCtrl = TextEditingController();
  TextEditingController referralCtrl = TextEditingController();

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dateofbirthCtrl = TextEditingController(text: s);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  int? _selectIndex;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        // STM().finishAffinity(ctx, SignIn());
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
          backgroundColor: Clr().white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Clr().white,
            elevation: 0,
            title: Text('Personal Info',
                style: Sty().mediumText.copyWith(
                    color: Clr().primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Dim().d20)),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d14, vertical: Dim().d20),
                child: Text('Step 1 of 3',
                    style: Sty().smallText.copyWith(
                        color: Clr().clr00,
                        fontSize: Dim().d12,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(Dim().d16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Dim().d12,
                      ),
                      TextFormField(
                        controller: nameCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().smallText.copyWith(
                            color: Clr().clr16,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          setState(() {
                            _selectIndex = 0;
                          });
                        },
                        decoration: Sty().textFileddarklinestyle.copyWith(
                              fillColor: Clr().white,
                              filled: true,
                              prefixIcon: Icon(
                                  nameCtrl.text.isNotEmpty
                                      ? Icons.person
                                      : Icons.person_outline_sharp,
                                  color: nameCtrl.text.isNotEmpty
                                      ? Clr().primaryColor
                                      : Clr().a4),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().a4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14,
                                  ),
                              hintText: "Enter Full Name",
                              counterText: "",
                              // prefixIcon: Icon(
                              //   Icons.call,
                              //   color: Clr().lightGrey,
                              // ),
                            ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Full name is required';
                          }
                        },
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      TextFormField(
                        controller: emailCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().smallText.copyWith(
                            color: Clr().clr16,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          setState(() {
                            _selectIndex = 1;
                          });
                        },
                        decoration: Sty().textFileddarklinestyle.copyWith(
                              fillColor: Clr().white,
                              filled: true,
                              prefixIcon: Icon(
                                  emailCtrl.text.isNotEmpty
                                      ? Icons.mail
                                      : Icons.mail_outline_sharp,
                                  color: emailCtrl.text.isNotEmpty
                                      ? Clr().primaryColor
                                      : Clr().a4),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().a4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14,
                                  ),
                              hintText: "Enter Email Address",
                              counterText: "",
                              // prefixIcon: Icon(
                              //   Icons.call,
                              //   color: Clr().lightGrey,
                              // ),
                            ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      TextFormField(
                        controller: dateofbirthCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().smallText.copyWith(
                            color: Clr().clr16,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          setState(() {
                            datePicker();
                            _selectIndex = 2;
                          });
                        },
                        decoration: Sty().textFileddarklinestyle.copyWith(
                              fillColor: Clr().white,
                              filled: true,
                              prefixIcon: Icon(
                                  dateofbirthCtrl.text.isNotEmpty
                                      ? Icons.calendar_month_sharp
                                      : Icons.calendar_month,
                                  color: dateofbirthCtrl.text.isNotEmpty
                                      ? Clr().primaryColor
                                      : Clr().a4),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().a4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14,
                                  ),
                              hintText: dateofbirthCtrl.text.isEmpty
                                  ? "Select Date Of Birth"
                                  : dateofbirthCtrl.text,
                              counterText: "",
                              // prefixIcon: Icon(
                              //   Icons.call,
                              //   color: Clr().lightGrey,
                              // ),
                            ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date of birth is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<dynamic>(
                          // value: sState,
                          validator: (value) {
                            if (value == null) {
                              return 'Gender is required';
                            }
                          },
                          onTap: () {
                            setState(() {
                              _selectIndex = 3;
                            });
                          },
                          hint: Text(
                            genderValue ?? 'Select Gender',
                            // 'Select State',
                            style: Sty().smallText.copyWith(
                                  color: genderValue != null
                                      ? Clr().clr16
                                      : Clr().a4,
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dim().d14,
                                ),
                          ),
                          decoration: Sty().textFileddarklinestyle.copyWith(
                              fillColor: Clr().white,
                              filled: true,
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Dim().d12),
                                child: SvgPicture.asset('assets/gender.svg',
                                    color: genderValue != null
                                        ? Clr().primaryColor
                                        : Clr().a4),
                              )),
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: genderValue != null
                                ? Clr().primaryColor
                                : Clr().a4,
                          ),
                          style: TextStyle(
                              color: genderValue != null
                                  ? Clr().black
                                  : Color(0xff000000)),
                          // style: TextStyle(color: Color(0xff787882)),
                          items: genderlist.map((string) {
                            return DropdownMenuItem<String>(
                              value: string.toString(),
                              // value: string['id'].toString(),
                              child: Text(
                                string,
                                // string['name'],
                                style:
                                    TextStyle(color: Clr().black, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              genderValue = v.toString();
                              // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                              // stateId = genderlist[postion]['id'].toString();
                              // cityValue = null;
                              // cityList = genderlist[postion]['city'];
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      TextFormField(
                        controller: referralCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().smallText.copyWith(
                            color: Clr().clr16,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          setState(() {
                            _selectIndex = 4;
                          });
                        },
                        decoration: Sty().textFileddarklinestyle.copyWith(
                              fillColor: Clr().white,
                              filled: true,
                              prefixIcon: Icon(
                                  referralCtrl.text.isNotEmpty
                                      ? Icons.my_library_books
                                      : Icons.my_library_books_outlined,
                                  color: referralCtrl.text.isNotEmpty
                                      ? Clr().primaryColor
                                      : Clr().a4),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().a4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14,
                                  ),
                              hintText: "Enter Referral Code",
                              counterText: "",
                              // prefixIcon: Icon(
                              //   Icons.call,
                              //   color: Clr().lightGrey,
                              // ),
                            ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Referral code is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Dim().d32,
                      ),
                    ],
                  ),
                ),
                loading
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dim().d20, vertical: Dim().d20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Clr().clr01,
                            borderRadius: BorderRadius.circular(Dim().d16),
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  personalDetails();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Colors.transparent,
                                  onSurface: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: Text(
                                'Next',
                                style: Sty().largeText.copyWith(
                                    fontSize: 16,
                                    color: Clr().f5,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      )
                    // AnimatedContainer(
                    //         duration: Duration(milliseconds: 60),
                    //         width: MediaQuery.of(context).size.width * 0.70,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //             gradient: LinearGradient(
                    //               begin: Alignment(-1.0, 0.0),
                    //               end: Alignment(1.0, 0.0),
                    //               colors: [
                    //                 Color(0xFF30B530),
                    //                 Color(0xFF36B235),
                    //                 Color(0xFF8CDE89),
                    //               ],
                    //             ),
                    //             borderRadius: isChanged
                    //                 ? BorderRadius.circular(5)
                    //                 : BorderRadius.circular(5)),
                    //         child: ElevatedButton(
                    //             onPressed: () async {
                    //               if (_formKey.currentState!.validate()) {
                    //                 personalDetails();
                    //               }
                    //             },
                    //             style: ElevatedButton.styleFrom(
                    //                 elevation: 0,
                    //                 primary: Colors.transparent,
                    //                 onSurface: Colors.transparent,
                    //                 shadowColor: Colors.transparent,
                    //                 shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(5))),
                    //             child: Text(
                    //               'Next',
                    //               style: Sty().largeText.copyWith(
                    //                   fontSize: 16,
                    //                   color: Clr().white,
                    //                   fontWeight: FontWeight.w600),
                    //             )
                    //
                    //             //     : Lottie.asset('animations/tick.json',
                    //             //     height: 100,
                    //             //     reverse: false,
                    //             //     repeat: true,
                    //             //     fit: BoxFit.cover
                    //             // ),
                    //             ),
                    //       )
                    : CircularProgressIndicator(color: Clr().primaryColor),
              ],
            ),
          )),
    );
  }

  void personalDetails() async {
    setState(() {
      loading = false;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "phone": widget.mobile,
      "name": nameCtrl.text,
      "email": emailCtrl.text,
      "dob": dateofbirthCtrl.text, // date should be Y-m-d format
      "gender": genderValue == 'Male'
          ? 'male'
          : genderValue == 'Female'
              ? 'female'
              : 'other',
      'referral_code': referralCtrl.text,
    });
    var result = await STM().postWithoutDialog(ctx, 'register', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message, ToastGravity.CENTER);
      setState(() {
        sp.setBool('personal', true);
        sp.setString('token', result['token']);
        loading = true;
      });
      STM().replacePage(ctx, KYCDetails());
    } else {
      setState(() {
        loading = true;
      });
      STM().errorDialog(ctx, message);
    }
  }
}

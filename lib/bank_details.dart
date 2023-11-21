import 'dart:convert';
import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/otp.dart';
import 'package:voitex/sign_in.dart';
import 'package:voitex/viewimage.dart';
import 'kyc_details.dart';
import 'manage/static_method.dart';
import 'my_account.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class BankDetails extends StatefulWidget {
  final type, banklist, page;
  const BankDetails({super.key, this.type, this.banklist, this.page});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late BuildContext ctx;

  var accountValue;
  List accountlist = ['Current', 'Saving'];
  String? error, error1;
  bool isChanged = true;
  File? imageFile;
  String? profile;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController bankNameCtrl = TextEditingController();
  TextEditingController acctNumCtrl = TextEditingController();
  TextEditingController ifscCodeCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? Token;
  List<String> kycDetailsList = [];
  List<String> bankDetailsList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (widget.type == 'edit') {
      setState(() {
        Token = sp.getString('token');
        nameCtrl = TextEditingController(text: widget.banklist[0]);
        bankNameCtrl = TextEditingController(text: widget.banklist[1]);
        acctNumCtrl = TextEditingController(text: widget.banklist[2]);
        ifscCodeCtrl = TextEditingController(text: widget.banklist[3]);
        accountValue = widget.banklist[4];
      });
    } else {
      setState(() {
        Token = sp.getString('token');
        kycDetailsList = sp.getStringList('kycdetailslist') == null
            ? []
            : sp.getStringList('kycdetailslist')!;
        bankDetailsList = sp.getStringList('bankdetailslist') == null
            ? []
            : sp.getStringList('bankdetailslist')!;
        nameCtrl = TextEditingController(
            text: bankDetailsList.isEmpty ? '' : bankDetailsList[0]);
        bankNameCtrl = TextEditingController(
            text: bankDetailsList.isEmpty ? '' : bankDetailsList[1]);
        acctNumCtrl = TextEditingController(
            text: bankDetailsList.isEmpty ? '' : bankDetailsList[2]);
        ifscCodeCtrl = TextEditingController(
            text: bankDetailsList.isEmpty ? '' : bankDetailsList[3]);
        accountValue = bankDetailsList.isEmpty ? null : bankDetailsList[4];
        profile = bankDetailsList.isEmpty ? null : bankDetailsList[5];
      });
    }
    print(Token);
  }

  int? _selectIndex;

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.type == 'edit'
            ? STM().replacePage(
                ctx,
                MyAccount(
                  type: widget.page,
                ))
            : STM().replacePage(ctx,  KYCDetails(type: 'bank',));
        return false;
      },
      child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Clr().black,
          appBar: AppBar(
            backgroundColor: Clr().black,
            elevation: 0,
            leading: InkWell(
                onTap: () {
                  widget.type == 'edit'
                      ? STM().replacePage(
                      ctx,
                      MyAccount(
                        type: widget.page,
                      ))
                      : STM().replacePage(ctx,  KYCDetails(type: 'bank',));
                },
                child: Icon(Icons.arrow_back_ios, size: Dim().d16,color: Clr().white)),
            actions: [
              widget.type == 'edit' ? Container() : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d14, vertical: Dim().d20),
                child: Text('Step 3 of 3',
                    style: Sty().smallText.copyWith(
                        color: Clr().white,
                        fontSize: Dim().d12,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dim().d56,
                        left: Dim().d12,
                        right: Dim().d12,
                        bottom: Dim().d100),
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
                          padding: EdgeInsets.symmetric(horizontal: Dim().d24),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Clr().white, width: 0.2),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dim().d12))),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: Dim().d20),
                                    TextFormField(
                                      controller: nameCtrl,
                                      cursorColor: Clr().white,
                                      style: Sty().smallText.copyWith(
                                          color: Clr().white,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      onTap: () {
                                        setState(() {
                                          _selectIndex = 0;
                                        });
                                      },
                                      decoration: Sty().textFieldUnderlineStyle.copyWith(
                                        hintStyle: Sty().smallText.copyWith(
                                          color: Clr().clr67,
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dim().d14,
                                        ),
                                        hintText: "Enter Name",
                                        counterText: "",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Name is required';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: '*',
                                        style: Sty().smallText.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Clr().red,
                                            fontFamily: ''),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                            ' As mentioned in your passbook or bank account  ',
                                            style: Sty().mediumText.copyWith(
                                                color: Clr().grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                fontFamily: ''),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    TextFormField(
                                      controller: bankNameCtrl,
                                      cursorColor: Clr().white,
                                      style: Sty().smallText.copyWith(
                                          color: Clr().white,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      onTap: () {
                                        setState(() {
                                          _selectIndex = 1;
                                        });
                                      },
                                      decoration: Sty().textFieldUnderlineStyle.copyWith(
                                        hintStyle: Sty().smallText.copyWith(
                                          color: Clr().clr67,
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dim().d14,
                                        ),
                                        hintText: "Enter Bank Name",
                                        counterText: "",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Bank name is required';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    TextFormField(
                                      controller: acctNumCtrl,
                                      cursorColor: Clr().white,
                                      style: Sty().smallText.copyWith(
                                          color: Clr().white,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      onTap: () {
                                        setState(() {
                                          _selectIndex = 2;
                                        });
                                      },
                                      decoration: Sty().textFieldUnderlineStyle.copyWith(
                                        hintStyle: Sty().smallText.copyWith(
                                          color: Clr().clr67,
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dim().d14,
                                        ),
                                        hintText: "Enter Account Name",
                                        counterText: "",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Account name is required';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    TextFormField(
                                      controller: ifscCodeCtrl,
                                      cursorColor: Clr().white,
                                      style: Sty().smallText.copyWith(
                                          color: Clr().white,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400),
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      onTap: () {
                                        setState(() {
                                          _selectIndex = 3;
                                        });
                                      },
                                      decoration: Sty().textFieldUnderlineStyle.copyWith(
                                        hintStyle: Sty().smallText.copyWith(
                                          color: Clr().clr67,
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dim().d14,
                                        ),
                                        hintText: "Enter IFSC Code",
                                        counterText: "",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'IFSC code is required';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Clr().white,width: 0.2)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/account.svg',
                                              color: accountValue != null
                                                  ? Clr().white
                                                  : Clr().clr67,
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: Dim().d16,
                                                ),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton(

                                                    hint: Text(accountValue ?? 'Account Type',
                                                      // 'Select State',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: accountValue != null
                                                              ? Clr().white
                                                              : Clr().clr67),
                                                    ),
                                                    isExpanded: true,
                                                    icon: Icon(Icons.arrow_drop_down,
                                                        color: accountValue != null
                                                            ? Clr().white
                                                            : Clr().clr67),
                                                    style: TextStyle(
                                                        color: accountValue != null
                                                            ? Clr().white
                                                            : Clr().clr67),
                                                    // style: TextStyle(color: Color(0xff787882)),
                                                    items: accountlist.map((string) {
                                                      return DropdownMenuItem(
                                                        value: string,
                                                        // value: string['id'].toString(),
                                                        child: Text(
                                                          string,
                                                          // string['name'],
                                                          style: TextStyle(
                                                              color: Clr().black, fontSize: 14),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (v) {
                                                      setState(() {
                                                        accountValue = v.toString();
                                                        error = null;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    error == null
                                        ? SizedBox.shrink()
                                        : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('   $error',
                                          style: Sty()
                                              .smallText
                                              .copyWith(color: Clr().errorRed)),
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Clr().background1,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(Dim().d14),
                                                    topRight: Radius.circular(Dim().d14))),
                                            builder: (index) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dim().d12,
                                                        vertical: Dim().d20),
                                                    child: Text('Profile Photo',
                                                        style: Sty().mediumBoldText),
                                                  ),
                                                  SizedBox(height: Dim().d28),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          _getProfile(ImageSource.camera);
                                                        },
                                                        child: Icon(
                                                          Icons.camera_alt_outlined,
                                                          color: Clr().primaryColor,
                                                          size: Dim().d32,
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            _getProfile(ImageSource.gallery);
                                                          },
                                                          child: Icon(
                                                            Icons.yard_outlined,
                                                            size: Dim().d32,
                                                            color: Clr().primaryColor,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(height: Dim().d40),
                                                ],
                                              );
                                            });
                                      },
                                      child: DottedBorder(
                                        color: Clr().white, //color of dotted/dash line
                                        strokeWidth: 0.5, //thickness of dash/dots
                                        dashPattern: [6, 4],
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 14),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/upload.svg',
                                                    color: profile != null
                                                        ? Clr().white
                                                        : Clr().clr67),
                                                SizedBox(
                                                  width: Dim().d20,
                                                ),
                                                Text(
                                                  profile != null
                                                      ? 'Cheque / Passbook is selected'
                                                      : 'Upload Cheque / Passbook',
                                                  style: Sty().smallText.copyWith(
                                                    color: profile != null
                                                        ? Clr().white
                                                        : Clr().clr67,
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: Dim().d8),
                                    imageFile != null
                                        ? InkWell(
                                      onTap: () {
                                        STM().redirect2page(
                                            ctx,
                                            viewImage(
                                              img: profile != null
                                                  ? imageFile
                                                  : widget.banklist[5],
                                            ));
                                      },
                                      child: SizedBox(
                                          height: Dim().d160,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(Dim().d12),
                                            child: Image.file(imageFile!,
                                                fit: BoxFit.fitWidth),
                                          )),
                                    )
                                        : widget.type == 'edit'
                                        ? InkWell(
                                      onTap: () {
                                        STM().redirect2page(
                                            ctx,
                                            viewImage(
                                              img: profile != null
                                                  ? imageFile
                                                  : widget.banklist[5],
                                            ));
                                      },
                                      child: Container(
                                        height: Dim().d160,
                                        width: Dim().d160,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Clr().grey),
                                            image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: NetworkImage(
                                                    '${widget.banklist[5]}'),
                                                fit: BoxFit.cover)),
                                      ),
                                    )
                                        : Container(),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    error1 == null
                                        ? SizedBox.shrink()
                                        : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('    $error1',
                                          style: Sty()
                                              .smallText
                                              .copyWith(color: Clr().errorRed)),
                                    ),
                                    SizedBox(
                                      height: Dim().d32,
                                    ),
                                    isChanged
                                        ? Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Clr().clr01,
                                        borderRadius: BorderRadius.circular(Dim().d16),
                                      ),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            widget.type == 'edit'
                                                ? bankDetail()
                                                : validate();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.transparent,
                                              onSurface: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5))),
                                          child: Text(
                                            'Submit',
                                            style: Sty().largeText.copyWith(
                                                fontSize: 16,
                                                color: Clr().f5,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    )
                                        : CircularProgressIndicator(color: Clr().white),
                                    // isChanged
                                    //     ? AnimatedContainer(
                                    //   duration: Duration(milliseconds: 60),
                                    //   width:
                                    //   MediaQuery.of(context).size.width * 0.70,
                                    //   height: 50,
                                    //   decoration: BoxDecoration(
                                    //       gradient: LinearGradient(
                                    //         begin: Alignment(-1.0, 0.0),
                                    //         end: Alignment(1.0, 0.0),
                                    //         colors: [
                                    //           Color(0xFF30B530),
                                    //           Color(0xFF36B235),
                                    //           Color(0xFF8CDE89),
                                    //         ],
                                    //       ),
                                    //       borderRadius: isChanged
                                    //           ? BorderRadius.circular(5)
                                    //           : BorderRadius.circular(5)),
                                    //   child: ElevatedButton(
                                    //     onPressed: () {
                                    //       widget.type == 'edit' ? bankDetail() : validate();
                                    //       // updateProfile();
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //         elevation: 0,
                                    //         primary: Colors.transparent,
                                    //         onSurface: Colors.transparent,
                                    //         shadowColor: Colors.transparent,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius:
                                    //             BorderRadius.circular(5))),
                                    //     child: Text(
                                    //       widget.type == 'edit'
                                    //           ? 'Update'
                                    //           : 'Get Started',
                                    //       style: Sty().largeText.copyWith(
                                    //           fontSize: 16,
                                    //           color: Clr().white,
                                    //           fontWeight: FontWeight.w600),
                                    //     ),
                                    //     //     : Lottie.asset('animations/tick.json',
                                    //     //     height: 100,
                                    //     //     reverse: false,
                                    //     //     repeat: true,
                                    //     //     fit: BoxFit.cover
                                    //     // ),
                                    //   ),
                                    // )
                                    //     : Align(
                                    //   alignment: Alignment.center,
                                    //   child: CircularProgressIndicator(
                                    //       color: Clr().primaryColor),
                                    // ),
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
          )),
    );
  }

  /// get profile photo for Teacher
  _getProfile(source) async {
    if (!kIsWeb) {
      final pickedFile = await ImagePicker().getImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path.toString());
          STM().back2Previous(ctx);
          var image = imageFile!.readAsBytesSync();
          profile = base64Encode(image);
        });
      }
    } else {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          profile = base64Encode(f);
          STM().back2Previous(ctx);
          print(profile);
        });
      }
    }
  }

  validate() async {
    bool valid = _formKey.currentState!.validate();
    if (accountValue == null) {
      setState(() => error = 'Account type is required');
      valid = false;
    }
    if (profile == null) {
      setState(() => error1 = "Image is required");
      valid = false;
    }
    if (valid) {
      // bankDetail();
      kycDetail();
    }
  }

  void kycDetail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      kycDetailsList[3] == '0' ? null : isChanged = false;
      sp.setStringList('bankdetailslist', [
        nameCtrl.text,
        bankNameCtrl.text,
        bankNameCtrl.text,
        acctNumCtrl.text,
        ifscCodeCtrl.text,
        accountValue == 'Current' ? 'current' : 'saving',
        profile!
      ]);
    });
    FormData body = FormData.fromMap({
      'pan': {
        'number': kycDetailsList[0],
        'pan_name': kycDetailsList[5],
        'image': kycDetailsList[1],
        'is_verify': kycDetailsList[4],
      },
      'aadhaar': {
        'number': kycDetailsList[2],
        'is_verify': kycDetailsList[3],
        'aadhar_front': kycDetailsList[6],
        'aadhar_back': kycDetailsList[7],
      },
    });
    var result = await STM()
        .postWithToken(ctx, Str().processing, 'kyc-add', body, Token);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        sp.setBool('kyc', true);
        isChanged = true;
      });
      bankDetail();
    } else {
      setState(() {
        isChanged = true;
      });
      STM().errorDialog(ctx, message);
    }
  }

  void bankDetail() async {
    setState(() {
      isChanged = false;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "name": nameCtrl.text,
      "bank_name": bankNameCtrl.text,
      "account_number": acctNumCtrl.text,
      "ifsc": ifscCodeCtrl.text,
      "type": accountValue == 'Current' ? 'current' : 'saving',
      "image": profile,
    });
    var result = await STM().postListWithoutDialog(
        ctx,
        widget.type == 'edit' ? 'bank-detail-update' : 'bank-detail-add',
        Token,
        body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.type == 'edit') {
        setState(() {
          isChanged = true;
        });
        STM().displayToast(message, ToastGravity.CENTER);
        STM().replacePage(ctx, MyAccount(type: widget.page));
      } else {
        setState(() {
          sp.setBool('login', true);
          sp.setBool('bank', true);
          isChanged = true;
        });
        STM().displayToast(message, ToastGravity.CENTER);
        STM().finishAffinity(ctx, Home());
      }
    } else {
      setState(() {
        isChanged = true;
      });
      STM().errorDialog(ctx, message);
    }
  }
}

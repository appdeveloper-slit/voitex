import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/my_orders.dart';
import 'package:voitex/paymentpage.dart';
import 'package:voitex/plsettings.dart';
import 'package:voitex/portfoilio.dart';
import 'package:voitex/sign_in.dart';
import 'package:voitex/watchlist.dart';
import 'bank_details.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'contactus.dart';
import 'kyc_details.dart';
import 'manage/static_method.dart';
import 'notification.dart';
import 'transaction_history.dart';
import 'updaate_bank_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'webview.dart';

class MyAccount extends StatefulWidget {
  final type;

  const MyAccount({super.key, this.type});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late BuildContext ctx;
  dynamic profileList;
  String? Token;
  bool? profileLoading, loading;
  TextEditingController valueCtrl = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });

    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getProfile(apiname: 'get_profile', type: 'get');
        }
      },
    );
    print(Token);
  }

  List widgetList = [
    {
      'Icon': Icon(
        Icons.person,
        color: Clr().primaryColor,
      ),
      'Text': 'Full Name',
      'name': 'Vivek Oberon',
      'subtitile': null,
    },
    {
      'Icon': Icon(
        Icons.phone,
        color: Clr().primaryColor,
      ),
      'Text': 'Mobile Number',
      'name': '+91 2389293822',
      'subtitile': null
    },
    {
      'Icon': Icon(
        Icons.mail,
        color: Clr().primaryColor,
      ),
      'Text': 'Email Address',
      'name': 'Spectrai21@gmail.com',
      'subtitile': null
    },
    {
      'Icon': Icon(
        Icons.credit_card,
        color: Clr().primaryColor,
      ),
      'Text': 'Pan Card Number',
      'name': 'ADSDH8439N',
      'subtitile': null
    },
    {
      'Icon': Icon(
        Icons.account_balance,
        color: Clr().primaryColor,
      ),
      'Text': 'Bank Details',
      'name': 'ICICI Bank Limited',
      'subtitile': '************9383',
    },
  ];

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
        widget.type == 0
            ? STM().finishAffinity(ctx, Home())
            : widget.type == 1
                ? STM().replacePage(ctx, Portfolio())
                : widget.type == 2
                    ? STM().replacePage(ctx, WatchList(type: 1))
                    : STM().replacePage(
                        ctx,
                        MyOrders(
                          type: 2,
                        ));
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 4, ''),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().white,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 0
                  ? STM().finishAffinity(ctx, Home())
                  : widget.type == 1
                      ? STM().replacePage(ctx, Portfolio())
                      : widget.type == 2
                          ? STM().replacePage(ctx, WatchList(type: 1))
                          : STM().replacePage(
                              ctx,
                              MyOrders(
                                type: 2,
                              ));
            },
            child: Padding(
              padding: EdgeInsets.only(left: Dim().d16),
              child: SvgPicture.asset('assets/back.svg'),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Account Settings',
            style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: Dim().d20),
          ),
          actions: [
            // Padding(
            //   padding: EdgeInsets.all(Dim().d16),
            //   child: InkWell(
            //       onTap: () {
            //         STM().redirect2page(ctx, Notifications());
            //       },
            //       child: SvgPicture.asset('assets/bell.svg')),
            // )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dim().d12,
              ),
              // profileLoading == true
              //     ?
              // Card(
              //   elevation: 0,
              //   color: Color(0xffF8F9F8),
              //   margin: EdgeInsets.zero,
              //   child: Padding(
              //     padding: EdgeInsets.all(
              //       Dim().d8,
              //     ),
              //     child: Column(
              //       children: [
              //         Text(
              //           '${profileList['name']}',
              //           maxLines: 3,
              //           textAlign: TextAlign.center,
              //           style: Sty().largeText.copyWith(
              //               color: Clr().textcolor,
              //               fontWeight: FontWeight.w500),
              //         ),
              //         Divider(
              //           color: Clr().grey,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              //           child: Row(
              //             children: [
              //               SvgPicture.asset('assets/profileicon.svg'),
              //               SizedBox(
              //                 width: Dim().d12,
              //               ),
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Client ID:',
              //                     style: Sty()
              //                         .microText
              //                         .copyWith(color: Clr().grey),
              //                   ),
              //                   SizedBox(
              //                     height: Dim().d4,
              //                   ),
              //                   Text(
              //                     '${profileList['client_id']}',
              //                     style: Sty()
              //                         .smallText
              //                         .copyWith(color: Clr().textcolor),
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           height: Dim().d20,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Wrap(
              //                 crossAxisAlignment: WrapCrossAlignment.center,
              //                 children: [
              //                   SvgPicture.asset('assets/call.svg'),
              //                   SizedBox(
              //                     width: Dim().d12,
              //                   ),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         'Mobile Number:',
              //                         style: Sty()
              //                             .microText
              //                             .copyWith(color: Clr().grey),
              //                       ),
              //                       SizedBox(
              //                         height: Dim().d4,
              //                       ),
              //                       Text(
              //                         '${profileList['phone']}',
              //                         style: Sty()
              //                             .smallText
              //                             .copyWith(color: Clr().textcolor),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //               // InkWell(
              //               //     onTap: () {
              //               //       STM()
              //               //           .mobileUpdate(ctx, Token)
              //               //           .then((v) {
              //               //         if (v == null) {
              //               //           print(v);
              //               //           getProfile(
              //               //               apiname: 'get_profile',
              //               //               type: 'get');
              //               //         }
              //               //       });
              //               //     },
              //               //     child: Icon(
              //               //       Icons.edit,
              //               //       color: Clr().grey,
              //               //     ))
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           height: Dim().d20,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Wrap(
              //                 crossAxisAlignment: WrapCrossAlignment.center,
              //                 children: [
              //                   SvgPicture.asset('assets/email.svg'),
              //                   SizedBox(
              //                     width: Dim().d12,
              //                   ),
              //                   SizedBox(
              //                     width: Dim().d200,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           'Email Address:',
              //                           style: Sty()
              //                               .microText
              //                               .copyWith(color: Clr().grey),
              //                         ),
              //                         SizedBox(
              //                           height: Dim().d4,
              //                         ),
              //                         Text(
              //                           '${profileList['email']}',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().textcolor),
              //                         ),
              //                       ],
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               // InkWell(
              //               //     onTap: () {
              //               //       STM().emailUpdate(ctx, Token).then((v) {
              //               //         if (v == null) {
              //               //           print(v);
              //               //           getProfile(
              //               //               apiname: 'get_profile',
              //               //               type: 'get');
              //               //         }
              //               //       });
              //               //     },
              //               //     child: Icon(
              //               //       Icons.edit,
              //               //       color: Clr().grey,
              //               //     ))
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           height: Dim().d20,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              //           child: Row(
              //             children: [
              //               SvgPicture.asset('assets/pan_card.svg'),
              //               SizedBox(
              //                 width: Dim().d12,
              //               ),
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Pan Card Number:',
              //                     style: Sty()
              //                         .microText
              //                         .copyWith(color: Clr().grey),
              //                   ),
              //                   SizedBox(
              //                     height: Dim().d4,
              //                   ),
              //                   Text(
              //                     profileList['kycs'].isEmpty
              //                         ? ''
              //                         : '${profileList['kycs'][0]['number']}',
              //                     style: Sty()
              //                         .smallText
              //                         .copyWith(color: Clr().textcolor),
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(
              //               horizontal: Dim().d4, vertical: Dim().d20),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   SvgPicture.asset('assets/bankicon.svg'),
              //                   SizedBox(
              //                     width: Dim().d12,
              //                   ),
              //                   SizedBox(
              //                     width: Dim().d250,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           'Bank Details:',
              //                           style: Sty()
              //                               .microText
              //                               .copyWith(color: Clr().grey),
              //                         ),
              //                         SizedBox(
              //                           height: Dim().d4,
              //                         ),
              //                         Text(
              //                           profileList['bank_detail'] == null
              //                               ? ''
              //                               : '${profileList['bank_detail']['bank_name']}',
              //                           style: Sty()
              //                               .microText
              //                               .copyWith(color: Clr().black),
              //                         ),
              //                         Text(
              //                           profileList['bank_detail'] == null
              //                               ? ''
              //                               : '${profileList['bank_detail']['number'].toString().replaceRange(0, profileList['bank_detail']['number'].toString().length - 4, '********')}',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().textcolor),
              //                         ),
              //                       ],
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               InkWell(
              //                   onTap: () {
              //                     STM().redirect2page(
              //                         ctx,
              //                         BankDetails(
              //                             type: 'edit',
              //                             page: widget.type,
              //                             banklist: [
              //                               profileList['bank_detail']['name'],
              //                               profileList['bank_detail']
              //                                   ['bank_name'],
              //                               profileList['bank_detail']
              //                                   ['number'],
              //                               profileList['bank_detail']['ifsc'],
              //                               profileList['bank_detail']['type'],
              //                               profileList['bank_detail']['image'],
              //                             ]));
              //                   },
              //                   child: Icon(Icons.edit, color: Clr().grey))
              //             ],
              //           ),
              //         ),
              //         // SizedBox(
              //         //   height: Dim().d20,
              //         // ),
              //         // Container(
              //         //   width: MediaQuery.of(context).size.width * 0.50,
              //         //   height: 45,
              //         //   decoration: BoxDecoration(
              //         //     gradient: LinearGradient(
              //         //       begin: Alignment(-1.0, 0.0),
              //         //       end: Alignment(1.0, 0.0),
              //         //       colors: [
              //         //         Clr().white,
              //         //         Clr().white,
              //         //       ],
              //         //     ),
              //         //     borderRadius: BorderRadius.circular(5),
              //         //   ),
              //         //   child: ElevatedButton(
              //         //       onPressed: () {
              //         //         // STM().redirect2page(
              //         //         //     ctx,
              //         //         //     Verification(
              //         //         //       mobileCtrl2.text.toString(),
              //         //         //     ));
              //         //         // buyStocklayout();
              //         //       },
              //         //       style: ElevatedButton.styleFrom(
              //         //           elevation: 1,
              //         //           backgroundColor: Colors.white,
              //         //           shadowColor: Clr().grey,
              //         //           shape: RoundedRectangleBorder(
              //         //               borderRadius: BorderRadius.circular(5))),
              //         //       child: Text(
              //         //         'Update',
              //         //         style: Sty().largeText.copyWith(
              //         //             fontSize: 16,
              //         //             color: Clr().accentColor,
              //         //             fontWeight: FontWeight.w600),
              //         //       )),
              //         // ),
              //         // SizedBox(
              //         //   height: Dim().d12,
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
              // : Center(
              //     child:
              //         CircularProgressIndicator(color: Clr().primaryColor)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: ListView.builder(
                  itemCount: widgetList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: Dim().d20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widgetList[index]['Icon'],
                          SizedBox(width: Dim().d8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widgetList[index]['Text']}',
                                    style: Sty().mediumText.copyWith(
                                        color: Clr().primaryColor,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: Dim().d6),
                                Text('${widgetList[index]['name']}',
                                    style: Sty().mediumText.copyWith(
                                        color: Clr().clr16,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: Dim().d6),
                                widgetList[index]['subtitile'] != null
                                    ? Text('${widgetList[index]['subtitile']}',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().clr16,
                                            fontSize: Dim().d14,
                                            fontWeight: FontWeight.w400))
                                    : Container(),
                              ],
                            ),
                          ),
                          if (index == 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dim().d6, horizontal: Dim().d12),
                              decoration: BoxDecoration(
                                  color: Clr().d1,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d8))),
                              child: Text('Client ID: 49343567',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().clr00,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d12)),
                            ),
                          if (index == 4)
                            InkWell(
                              onTap: () {
                                STM().redirect2page(
                                    ctx,
                                    BankDetails(
                                        type: 'edit',
                                        page: widget.type,
                                        banklist: [
                                          profileList['bank_detail']['name'],
                                          profileList['bank_detail']
                                              ['bank_name'],
                                          profileList['bank_detail']['number'],
                                          profileList['bank_detail']['ifsc'],
                                          profileList['bank_detail']['type'],
                                          profileList['bank_detail']['image'],
                                        ]));
                              },
                              child: SvgPicture.asset('assets/editicon.svg',
                                  height: Dim().d24),
                            )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Container(
                padding: EdgeInsets.all(Dim().d14),
                margin: EdgeInsets.symmetric(horizontal: Dim().d12),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Clr().a4, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(Dim().d16))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funds Available',
                      style: Sty().microText.copyWith(
                          color: Clr().primaryColor,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dim().d6),
                    if(profileList != null)
                    Text(
                      '₹ ${profileList['wallet'] != null ? profileList['wallet'].toString() : '0'}',
                      style: Sty().microText.copyWith(
                          color: Clr().clr00,
                          fontSize: Dim().d20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: Dim().d20),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              valueCtrl.clear();
                              withdrawFundlayout();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d12)),
                                  border: Border.all(
                                      color: Clr().primaryColor, width: 1.0)),
                              child: Text('Withdraw',
                                  textAlign: TextAlign.center,
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().clr0130,
                                      fontSize: Dim().d16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dim().d12,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              valueCtrl.clear();
                              addFundlayout();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d12),
                              decoration: BoxDecoration(
                                  color: Clr().clr0130,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d12)),
                                  border: Border.all(
                                      color: Clr().primaryColor, width: 1.0)),
                              child: Text('Add Funds',
                                  textAlign: TextAlign.center,
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().f5,
                                      fontSize: Dim().d16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // if (profileList != null)
              //   Padding(
              //     padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              //     child: Text(
              //       '₹ ${profileList['wallet'] != null ? profileList['wallet'].toString() : '0'}',
              //       style: Sty().largeText.copyWith(color: Clr().textcolor),
              //     ),
              //   ),
              // SizedBox(
              //   height: Dim().d20,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: SizedBox(
              //           height: 40,
              //           child: ElevatedButton(
              //               onPressed: () {
              //                 // STM().redirect2page(ctx, BuyStock());
              //                 withdrawFundlayout();
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   elevation: 0,
              //                   side: BorderSide(color: Clr().accentColor),
              //                   shadowColor: Colors.transparent,
              //                   backgroundColor: Clr().white,
              //                   shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(5))),
              //               child: Text(
              //                 'Withdraw',
              //                 style: Sty().mediumText.copyWith(
              //                     fontSize: 16,
              //                     color: Clr().accentColor,
              //                     fontWeight: FontWeight.w500),
              //               )),
              //         ),
              //       ),
              //       SizedBox(
              //         width: Dim().d16,
              //       ),
              //       Expanded(
              //         child: SizedBox(
              //           height: 40,
              //           child: ElevatedButton(
              //               onPressed: () {
              //                 // STM().redirect2page(ctx, SellStock());
              //                 addFundlayout();
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   elevation: 0,
              //                   shadowColor: Colors.transparent,
              //                   backgroundColor: Clr().accentColor,
              //                   shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(5))),
              //               child: Text(
              //                 'Add Funds',
              //                 style: Sty().mediumText.copyWith(
              //                       fontSize: 16,
              //                       color: Clr().white,
              //                       fontWeight: FontWeight.w500,
              //                     ),
              //               )),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: Dim().d20,
              ),
              Container(
                padding: EdgeInsets.all(Dim().d14),
                margin: EdgeInsets.symmetric(horizontal: Dim().d12),
                decoration: BoxDecoration(
                    border: Border.all(color: Clr().clrec, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(Dim().d16))),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, plSettings());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/pl.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'P/L Limit Settings',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, TransactionHistory());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/transactionicon.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Transaction History',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        // STM().redirect2page(ctx, TransactionHistory());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/contact.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Contact Support',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().openWeb('https://spectrai.in/about_us');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset('assets/profileicon.svg',
                                  color: Clr().clr49),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'About Us',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().openWeb('https://spectrai.in/terms&condition');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/terms.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Terms &Conditions',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().openWeb('https://spectrai.in/privacy_policy');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/privacy.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Privacy Policy',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().openWeb('https://spectrai.in/disclosure');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/disclosure.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Disclosure Policy',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        STM().openWeb('https://spectrai.in/policies&procedures');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                'assets/procedure.png',
                                width: Dim().d20,
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              Text(
                                'Procedure & Policy',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr16,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Dim().d14,
                                    ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Clr().grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.clear();
                      STM().finishAffinity(ctx, SignIn());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        side: BorderSide(color: Clr().clr0130),
                        shadowColor: Colors.transparent,
                        backgroundColor: Clr().white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dim().d12),
                      child: Text(
                        'Logout',
                        style: Sty().mediumText.copyWith(
                            fontSize: Dim().d16,
                            color: Clr().clr0130,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Account',
                              style: Sty().mediumBoldText),
                          content: Text('Are you sure want to delete account?',
                              style: Sty().mediumText),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  getProfile(
                                      apiname: 'delete_account', type: 'get');
                                },
                                child: Text('Yes',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600))),
                            TextButton(
                                onPressed: () {
                                  STM().back2Previous(ctx);
                                },
                                child: Text('No',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600))),
                          ],
                        );
                      });
                },
                child: Center(
                  child: Text(
                    'Delete my account',
                    style: Sty().microText.copyWith(
                        color: Color(0xffFF4124),
                        fontSize: Dim().d14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d40,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// awesome dialog for adding fund
  addFundlayout({value}) {
    var select;
    final _formKey = GlobalKey<FormState>();
    AwesomeDialog(
        width: double.infinity,
        isDense: true,
        context: ctx,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: Form(
            key: _formKey,
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Fund Balance:',
                    //     style: Sty().microText.copyWith(color: Clr().grey),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text:
                    //             ' ₹ 300',//${profileList['wallet'] != null ? profileList['wallet'] : '0'}',
                    //         style: Sty().smallText.copyWith(
                    //             color: Clr().textcolor,
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 12,
                    //             fontFamily: ''),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: Clr().grey,
                    // ),
                    Text(
                      'Enter Amount to be Added',
                      style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Dim().d16),
                    ),
                    SizedBox(
                      height: Dim().d28,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        TextFormField(
                          controller: valueCtrl,
                          cursorColor: Clr().primaryColor,
                          style: Sty().mediumText,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: Sty().textFieldOutlineStyle.copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: Dim().d12, horizontal: Dim().d12),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dim().d16)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dim().d16)),
                                hintStyle: Sty().smallText.copyWith(
                                      color: Clr().grey,
                                    ),
                                filled: true,
                                fillColor: Clr().white,
                                prefixText: '₹ ',
                                prefixStyle: TextStyle(color: Clr().textcolor),
                                hintText: "Rupees",
                                counterText: "",
                                // prefixIcon: Icon(
                                //   Icons.call,
                                //   color: Clr().lightGrey,
                                // ),
                              ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Str().invalidEmpty;
                            } else {
                              return null;
                            }
                          },
                        ),
                        Positioned(
                          left: 30,
                          top: -10,
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: Text(
                              'Add Amount',
                              style: TextStyle(
                                  color: Clr().clr49,
                                  fontSize: Dim().d14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  STM().back2Previous(ctx);
                                  STM().redirect2page(
                                      ctx,
                                      paymentPage(
                                        price: valueCtrl.text.toString(),
                                      ));
                                  setState(() {
                                    valueCtrl.clear();
                                    loading = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Clr().f5,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Clr().primaryColor),
                                      borderRadius:
                                          BorderRadius.circular(Dim().d12))),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Dim().d12),
                                child: Text(
                                  'Manual',
                                  style: Sty().mediumText.copyWith(
                                        fontSize: Dim().d16,
                                        color: Clr().primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              )),
                        ),
                        SizedBox(width: Dim().d12),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  STM().back2Previous(ctx);
                                  String url = 'https://spectrai.in/api/submit-payment?username=${profileList['name']}&user_id=${profileList['id']}&email_id=${profileList['email']}&mobile=${profileList['phone']}&amount=${valueCtrl.text}';
                                  STM().redirect2page(ctx, WebViewPage(url));
                                  setState(() {
                                    valueCtrl.clear();
                                    loading = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Clr().primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(Dim().d12))),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Dim().d12),
                                child: Text(
                                  'Online',
                                  style: Sty().mediumText.copyWith(
                                        fontSize: Dim().d16,
                                        color: Clr().f5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                  ],
                ),
              );
            }))).show();
  }

  /// awesome dialog for withdrawing fund
  withdrawFundlayout({value}) {
    var select;
    final _formKey = GlobalKey<FormState>();
    var transactionfee;
    var withdraAmt;
    var totalwithdrawAmt;
    AwesomeDialog(
        width: double.infinity,
        isDense: true,
        context: ctx,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: Form(
            key: _formKey,
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Amount to be Withdrawn',
                      style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Dim().d16),
                    ),
                    SizedBox(
                      height: Dim().d28,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        TextFormField(
                          controller: valueCtrl,
                          cursorColor: Clr().primaryColor,
                          style: Sty().mediumText,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onChanged: (v) {
                            try {
                              setState(() {
                                transactionfee =
                                    (2.95 / 100) * int.parse(valueCtrl.text);
                                totalwithdrawAmt =
                                    int.parse(valueCtrl.text) - transactionfee;
                                withdraAmt = int.parse(valueCtrl.text) -
                                    totalwithdrawAmt;
                              });
                            } catch (_) {
                              setState(() {
                                transactionfee =
                                    (2.95 / 100) * double.parse(valueCtrl.text);
                                totalwithdrawAmt =
                                    double.parse(valueCtrl.text) -
                                        transactionfee;
                                withdraAmt = double.parse(valueCtrl.text) -
                                    totalwithdrawAmt;
                              });
                            }
                          },
                          decoration: Sty().textFieldOutlineStyle.copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: Dim().d12, horizontal: Dim().d12),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dim().d16)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dim().d16)),
                                hintStyle: Sty().smallText.copyWith(
                                      color: Clr().grey,
                                    ),
                                filled: true,
                                fillColor: Clr().white,
                                prefixText: '₹ ',
                                prefixStyle: TextStyle(color: Clr().textcolor),
                                hintText: "Rupees",
                                counterText: "",
                                // prefixIcon: Icon(
                                //   Icons.call,
                                //   color: Clr().lightGrey,
                                // ),
                              ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Str().invalidEmpty;
                            } else {
                              return null;
                            }
                          },
                        ),
                        Positioned(
                          left: 30,
                          top: -10,
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            color: Colors.white,
                            child: Text(
                              'Withdraw Amount',
                              style: TextStyle(
                                  color: Clr().clr49,
                                  fontSize: Dim().d14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Fund Balance:',
                        style: Sty().microText.copyWith(
                            color: Clr().clr49,
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d14),
                        children: <TextSpan>[
                          TextSpan(
                            text: profileList == null
                                ? ''
                                : ' ₹${profileList['wallet']}',
                            style: Sty().smallText.copyWith(
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: ''),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Clr().clrec,
                      thickness: 1.0,
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text('Withdrawable  Fee(in %):',
                            style: Sty().microText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14)),
                        transactionfee == null
                            ? Container()
                            : Text(
                                ' ${transactionfee.toString().contains('.') ? double.parse(transactionfee.toString()).toStringAsFixed(2) : transactionfee}%',
                                // ' ${transactionfee.toString().contains('.') ? double.parse(transactionfee.toString()).toStringAsFixed(2) : transactionfee}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Row(
                      children: [
                        Text('Withdrawable  Fee(in ₹):',
                            style: Sty().microText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14)),
                        withdraAmt == null
                            ? Container()
                            : Text(
                                ' ₹ ${withdraAmt.toString().contains('.') ? double.parse(withdraAmt.toString()).toStringAsFixed(2) : withdraAmt}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                    Divider(
                        color: Clr().grey, height: Dim().d12, thickness: 1.0),
                    Row(
                      children: [
                        Text(
                          'Withdrawable  Amount:',
                          style: Sty().microText.copyWith(
                              color: Clr().clr2c,
                              fontWeight: FontWeight.w400,
                              fontSize: Dim().d14),
                        ),
                        withdraAmt == null
                            ? Container()
                            : Text(
                                ' ₹ ${totalwithdrawAmt.toString().contains('.') ? double.parse(totalwithdrawAmt.toString()).toStringAsFixed(2) : totalwithdrawAmt}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    loading == true
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Clr().primaryColor),
                          )
                        : SizedBox(
                            height: 40,
                            width: MediaQuery.of(ctx).size.height,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    getProfile(
                                        apiname: 'withdrawn',
                                        type: 'post',
                                        value: valueCtrl.text);
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(Dim().d12))),
                                child: Text(
                                  'Proceed',
                                  style: Sty().mediumText.copyWith(
                                        fontSize: Dim().d16,
                                        color: Clr().f5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                )),
                          ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                  ],
                ),
              );
            }))).show();
  }

  ///getprofile
  getProfile({apiname, type, value}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'add_fund':
        data = FormData.fromMap({
          'amount': value,
        });
        break;
      case 'withdrawn':
        data = FormData.fromMap({
          'amount': value,
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postListWithoutDialog(ctx, apiname, Token, body)
        : await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'get_profile':
        if (result['success']) {
          setState(() {
            profileList = result['data'];
            profileLoading = true;
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'add_fund':
        if (result['success']) {
          setState(() {
            loading = false;
            valueCtrl.clear();
            STM().displayToast(result['message'], ToastGravity.CENTER);
            getProfile(apiname: 'get_profile', type: 'get', value: '');
            profileLoading = false;
          });
        } else {
          setState(() {
            valueCtrl.clear();
            loading = false;
          });
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'withdrawn':
        if (result['success']) {
          setState(() {
            loading = false;
            STM().back2Previous(ctx);
            STM().displayToast(result['message'], ToastGravity.CENTER);
            valueCtrl.clear();
            getProfile(apiname: 'get_profile', type: 'get', value: '');
            profileLoading = false;
          });
        } else {
          setState(() {
            STM().back2Previous(ctx);
            valueCtrl.clear();
            loading = false;
          });
          result['data'] == null
              ? STM().errorDialog(ctx, result['message'])
              : AwesomeDialog(
                  context: context,
                  dismissOnBackKeyPress: false,
                  dismissOnTouchOutside: false,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.SCALE,
                  headerAnimationLoop: true,
                  descTextStyle:
                      Sty().mediumText.copyWith(color: Clr().errorRed),
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    child: Column(
                      children: [
                        Text('KYC Details Needed',
                            style: Sty().mediumBoldText.copyWith(
                                fontSize: Dim().d20,
                                fontWeight: FontWeight.w600,
                                color: Clr().primaryColor)),
                        SizedBox(height: Dim().d12),
                        Text('${result['message']}',
                            style: Sty()
                                .mediumText
                                .copyWith(fontWeight: FontWeight.w300)),
                        SizedBox(height: Dim().d16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    STM().redirect2page(
                                        ctx,
                                        KYCDetails(
                                            type: 'edit',
                                            data: profileList['kycs']));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dim().d12)),
                                      backgroundColor: Clr().clr0130),
                                  child: Text('Proceed',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().f5))),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                STM().back2Previous(ctx);
                              },
                              child: Text('cancle',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().clr0130,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                        SizedBox(height: Dim().d16),
                      ],
                    ),
                  )).show();
        }
        break;
      case 'delete_account':
        if (result['success']) {
          sp.clear();
          STM().successDialogWithAffinity(ctx, result['message'], SignIn());
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}

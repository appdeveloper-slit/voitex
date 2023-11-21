import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/manage/static_method.dart';
import 'package:voitex/stock_chart.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'values/strings.dart';

class BuyStock extends StatefulWidget {
  final details;

  const BuyStock({super.key, required this.details});

  @override
  State<BuyStock> createState() => _BuyStockState();
}

class _BuyStockState extends State<BuyStock> {
  late BuildContext ctx;

  String marketValue = '5x';
  dynamic profileList;
  String markettypevalue = 'Market';
  String? aa, bb;
  var totalAmount;
  List marketList = [
    '1x',
    '2x',
    '3x',
    '4x',
    '5x',
    '6x',
    '7x',
    '8x',
    '9x',
    '10x'
  ];
  List marketype = ['Market', 'Limit'];
  int isSelected = 2;
  String? Token;
  bool? loading;
  dynamic data;
  var totaloMarketValue, requiredFund, leverageAmtFund;
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController shareCtrl = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          stockfunt(apiname: 'get_profile', type: 'get', value: null);
          apitype();
          priceCtrl = TextEditingController(
              text: widget.details['last_price'].toString());
        }
      },
    );
    print(Token);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  late Stream stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await apitype());

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0, stream, b: true),
      backgroundColor: Clr().black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().black,
        leadingWidth: 40,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: Dim().d16, top: Dim().d12, bottom: Dim().d12),
            child: SvgPicture.asset('assets/back.svg',color: Clr().white,height: Dim().d20),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Stock Buy',
          style: Sty()
              .mediumText
              .copyWith(color: Clr().white, fontWeight: FontWeight.w600),
        ),
        actions: [
          // Padding(
          //   padding: EdgeInsets.all(Dim().d16),
          //   child: Row(
          //     children: [
          //       // InkWell(
          //       //     onTap: () {
          //       //       STM().redirect2page(
          //       //           ctx,
          //       //           SearchStocks(
          //       //             type: 'watch',
          //       //           ));
          //       //     },
          //       //     child: SvgPicture.asset('assets/search.svg',
          //       //         color: Clr().primaryColor)),
          //       // SizedBox(
          //       //   width: Dim().d12,
          //       // ),
          //       isLike.map((e) => e.toString()).contains(
          //           widget.type == 'watch'
          //               ? widget.details['stock_id']
          //               .toString()
          //               : widget.details['id'].toString())
          //           ? InkWell(
          //           onTap: () {
          //             apiType(
          //                 apiname: 'remove_favourite',
          //                 type: 'post',
          //                 value: widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //             if (isdislike.contains(
          //                 widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id'])) {
          //               setState(() {
          //                 isdislike.remove(
          //                     widget.type == 'watch'
          //                         ? widget.details['stock_id']
          //                         : widget.details['id']);
          //               });
          //             } else {
          //               setState(() {
          //                 isLike.remove(widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //                 isdislike.add(widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //               });
          //             }
          //           },
          //           child: SvgPicture.asset(
          //               'assets/fillstar.svg'))
          //           : InkWell(
          //           onTap: () {
          //             apiType(
          //                 apiname: 'add_favourite',
          //                 type: 'post',
          //                 value: widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //             if (isLike.contains(
          //                 widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id'])) {
          //               setState(() {
          //                 isLike.remove(widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //               });
          //             } else {
          //               setState(() {
          //                 isdislike.remove(
          //                     widget.type == 'watch'
          //                         ? widget.details['stock_id']
          //                         : widget.details['id']);
          //                 isLike.add(widget.type == 'watch'
          //                     ? widget.details['stock_id']
          //                     : widget.details['id']);
          //               });
          //             }
          //           },
          //           child: SvgPicture.asset(
          //               'assets/unfillstar.svg')),
          //
          //       // InkWell(
          //       //     onTap: () {
          //       //       STM().redirect2page(ctx, Notifications());
          //       //     },
          //       //     child: SvgPicture.asset('assets/bell.svg')),
          //     ],
          //   ),
          // )
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(
              color: Clr().white,
            ))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              data == null
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${data['symbol']}',
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().white,
                                                  fontSize: Dim().d14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            // SizedBox(
                                            //   width: Dim().d4,
                                            // ),
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(5),
                                            //     color: Clr().white,
                                            //   ),
                                            //   width: 40,
                                            //   height: 20,
                                            //   child: Center(
                                            //     child: Text(
                                            //       'NSE',
                                            //       style: Sty().microText.copyWith(
                                            //           color: Clr().textcolor, fontWeight: FontWeight.w300),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dim().d4,
                                        ),
                                        Text(
                                          '${data['company_name']}',
                                          style: Sty().microText.copyWith(
                                              color: Clr().clr67,
                                              fontSize: Dim().d12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                              data == null
                                  ? Container()
                                  : Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              data['net_change']
                                                      .toString()
                                                      .contains('-')
                                                  ? Icon(
                                                      Icons
                                                          .arrow_downward_outlined,
                                                      color: Clr().red,
                                                      size: Dim().d16)
                                                  : Icon(
                                                      Icons
                                                          .arrow_upward_outlined,
                                                      size: Dim().d16,
                                                      color: Clr().green),
                                              SizedBox(
                                                width: Dim().d8,
                                              ),
                                              Text(
                                                '${data['last_price']}',
                                                style: Sty().smallText.copyWith(
                                                    fontSize: Dim().d14,
                                                    fontWeight: FontWeight.w600,
                                                    color: data['net_change']
                                                            .toString()
                                                            .contains('-')
                                                        ? Clr().red
                                                        : Clr().green),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: Dim().d8,
                                          ),
                                          Text(
                                            '${data['net_change']} (${data['net_change_ercentage']})',
                                            style: Sty().microText.copyWith(
                                                color: Clr().clr67,
                                                fontSize: Dim().d12,
                                                fontWeight: FontWeight.w400),

                                            // style: Sty().microText.copyWith(color: Clr().grey),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                          Divider(
                            // color: Color(0xff6C6C6C),
                            thickness: 1,
                          ),
                          // SizedBox(
                          //   height: Dim().d8,
                          // ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          // AppBar(
                          //   elevation: 1,
                          //   shadowColor: Clr().lightShadow,
                          //   backgroundColor: Color(0xffF8F9F8),
                          //   leadingWidth: 40,
                          //   leading: InkWell(
                          //     onTap: () {
                          //       STM().back2Previous(ctx);
                          //     },
                          //     child: Padding(
                          //       padding: EdgeInsets.only(left: Dim().d16),
                          //       child: SvgPicture.asset('assets/back.svg'),
                          //     ),
                          //   ),
                          //   title: data == null
                          //       ? Container()
                          //       : Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Text(
                          //             '${data['symbol']}',
                          //             style: Sty().smallText.copyWith(
                          //               color: Clr().textcolor,
                          //             ),
                          //           ),
                          //           // SizedBox(
                          //           //   width: Dim().d4,
                          //           // ),
                          //           // Container(
                          //           //   decoration: BoxDecoration(
                          //           //     borderRadius: BorderRadius.circular(5),
                          //           //     color: Clr().white,
                          //           //   ),
                          //           //   width: 40,
                          //           //   height: 20,
                          //           //   child: Center(
                          //           //     child: Text(
                          //           //       'NSE',
                          //           //       style: Sty().microText.copyWith(
                          //           //           color: Clr().textcolor, fontWeight: FontWeight.w300),
                          //           //     ),
                          //           //   ),
                          //           // )
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: Dim().d4,
                          //       ),
                          //       Text(
                          //         '${data['company_name']}',
                          //         style: Sty().microText.copyWith(
                          //           color: Clr().grey,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //   actions: [
                          //     data == null
                          //         ? Container()
                          //         : Padding(
                          //       padding: EdgeInsets.only(right: Dim().d16),
                          //       child: Center(
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Wrap(
                          //               crossAxisAlignment: WrapCrossAlignment.center,
                          //               children: [
                          //                 data['net_change'].toString().contains('-')
                          //                     ? Icon(Icons.arrow_downward_outlined,
                          //                     color: Clr().red)
                          //                     : Icon(Icons.arrow_upward_outlined,
                          //                     color: Clr().green),
                          //                 SizedBox(
                          //                   width: Dim().d8,
                          //                 ),
                          //                 Text(
                          //                   '${data['last_price']}',
                          //                   style: Sty().smallText.copyWith(
                          //                       color: data['net_change']
                          //                           .toString()
                          //                           .contains('-')
                          //                           ? Clr().red
                          //                           : Clr().green),
                          //                 )
                          //               ],
                          //             ),
                          //             SizedBox(
                          //               height: Dim().d8,
                          //             ),
                          //             Text(
                          //               '${data['net_change']} (${data['net_change_ercentage']})',
                          //               style: Sty().microText.copyWith(color: Clr().grey),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          TextFormField(
                            controller: shareCtrl,
                            cursorColor: Clr().white,
                            style: Sty().mediumText.copyWith(color: Clr().white),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: Sty()
                                .textFieldUnderlineStyle
                                .copyWith(
                              hintStyle: Sty().smallText.copyWith(
                                color: Clr().clr67,
                              ),
                              // prefixText: '₹ ',
                              prefixStyle: TextStyle(
                                  color: Clr().textcolor),
                              hintText: "No. of Shares",
                              counterText: "",
                              // prefixIcon: Icon(
                              //   Icons.call,
                              //   color: Clr().lightGrey,
                              // ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter quantity';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (v) {
                              setState(() {
                                aa = v.toString();
                                marketValueAmt(
                                    shareCtrl.text.toString(),
                                    priceCtrl.text.contains('-')
                                        ? data['last_price']
                                        .toString()
                                        : priceCtrl.text.toString());
                              });
                            },
                          ),
                          // StreamBuilder(
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<dynamic> snapshot) {
                          //     return Text(
                          //       'No. of shares',
                          //       style: Sty()
                          //           .microText
                          //           .copyWith(color: Clr().textcolor),
                          //     );
                          //   },
                          // ),
                          // SizedBox(
                          //   height: Dim().d12,
                          // ),
                          // TextFormField(
                          //   controller: shareCtrl,
                          //   cursorColor: Clr().primaryColor,
                          //   style: Sty().mediumText,
                          //   autofocus: false,
                          //   keyboardType: TextInputType.number,
                          //   textInputAction: TextInputAction.done,
                          //   decoration:
                          //       Sty().textFieldOutlineStyle.copyWith(
                          //             hintStyle: Sty().smallText.copyWith(
                          //                   color: Clr().grey,
                          //                 ),
                          //             filled: true,
                          //             fillColor: Clr().white,
                          //             hintText: "0",
                          //             counterText: "",
                          //             // prefixIcon: Icon(
                          //             //   Icons.call,
                          //             //   color: Clr().lightGrey,
                          //             // ),
                          //           ),
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return Str().invalidMobile;
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          //   onChanged: (v) {
                          //     setState(() {
                          //       aa = v.toString();
                          //       marketValueAmt(
                          //           shareCtrl.text.toString(),
                          //           priceCtrl.text.contains('-')
                          //               ? data['last_price'].toString()
                          //               : priceCtrl.text.toString());
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: Dim().d32,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                controller: priceCtrl,
                                readOnly:
                                markettypevalue == 'Market'
                                    ? true
                                    : false,
                                cursorColor: Clr().white,
                                style: Sty().mediumText.copyWith(color: Clr().white),
                                keyboardType: TextInputType.number,
                                textInputAction:
                                TextInputAction.done,
                                decoration: Sty()
                                    .textFieldUnderlineStyle
                                    .copyWith(
                                  hintStyle:
                                  Sty().smallText.copyWith(
                                    color: Clr().white,
                                  ),
                                  // prefixText: '₹ ',
                                  prefixStyle: TextStyle(
                                      color: Clr().textcolor),
                                  hintText: "Price",
                                  counterText: "",
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Str().invalidMobile;
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (v) {
                                  setState(() {
                                    bb = v.toString();
                                    marketValueAmt(
                                        shareCtrl.text.toString(),
                                        priceCtrl.text.toString());
                                  });
                                },
                            ),
                              ),
                              SizedBox(width: Dim().d12),
                              Expanded(
                                child: Container(
                                  width: 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color(0xFF494949))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dim().d16),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<dynamic>(
                                        value: markettypevalue,
                                        dropdownColor: Clr().clr67,
                                        hint: Text(
                                          markettypevalue ??
                                              'Select Market',
                                          // 'Select State',
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 14,
                                            color: markettypevalue != null
                                                ? Clr().white
                                                : Color(0xff787882),
                                            // color: Color(0xff787882),
                                          ),
                                        ),
                                        isExpanded: true,
                                        icon: Icon(
                                            Icons
                                                .arrow_drop_down_outlined,
                                            color: Clr().white),
                                        style: TextStyle(
                                            color: markettypevalue != null
                                                ? Clr().black
                                                : Color(0xff000000)),
                                        // style: TextStyle(color: Color(0xff787882)),
                                        items: marketype.map((string) {
                                          return DropdownMenuItem<String>(
                                            value: string,
                                            // value: string['id'].toString(),
                                            child: Text(
                                              string,
                                              // string['name'],
                                              style: TextStyle(
                                                  color: Clr().white,
                                                  fontSize: 14),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            markettypevalue =
                                                v.toString();
                                          });
                                          if (v.toString() == 'Market') {
                                            setState(() {
                                              priceCtrl =
                                                  TextEditingController(
                                                      text: data[
                                                      'last_price']
                                                          .toString());
                                              marketValueAmt(
                                                  shareCtrl.text
                                                      .toString(),
                                                  priceCtrl.text
                                                      .toString());
                                            });
                                          } else {
                                            setState(() {
                                              priceCtrl =
                                                  TextEditingController(
                                                      text: widget
                                                          .details[
                                                      'last_price']
                                                          .toString());
                                              marketValueAmt(
                                                  shareCtrl.text
                                                      .toString(),
                                                  priceCtrl.text
                                                      .toString());
                                              // totalAmountlayut(
                                              //     lev: marketValue,
                                              //     price: widget
                                              //         .details['last_price']
                                              //         .toString());
                                            });
                                          }
                                          // setState(() {
                                          //   // genderValue = v.toString();
                                          //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                                          //   // stateId = genderlist[postion]['id'].toString();
                                          //   // cityValue = null;
                                          //   // cityList = genderlist[postion]['city'];
                                          // });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Text(
                          //   'Price',
                          //   style: Sty()
                          //       .microText
                          //       .copyWith(color: Clr().textcolor),
                          // ),
                          // SizedBox(
                          //   height: Dim().d12,
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: priceCtrl,
                          //         readOnly: markettypevalue == 'Market'
                          //             ? true
                          //             : false,
                          //         cursorColor: Clr().primaryColor,
                          //         style: Sty().mediumText,
                          //         keyboardType: TextInputType.number,
                          //         textInputAction: TextInputAction.done,
                          //         decoration: Sty()
                          //             .textFieldOutlineStyle
                          //             .copyWith(
                          //               contentPadding:
                          //                   EdgeInsets.symmetric(
                          //                       vertical: Dim().d0,
                          //                       horizontal: Dim().d8),
                          //               hintStyle:
                          //                   Sty().smallText.copyWith(
                          //                         color: Clr().grey,
                          //                       ),
                          //               filled: true,
                          //               fillColor: Clr().white,
                          //
                          //               hintText: "Price",
                          //               counterText: "",
                          //               // prefixIcon: Icon(
                          //               //   Icons.call,
                          //               //   color: Clr().lightGrey,
                          //               // ),
                          //             ),
                          //         validator: (value) {
                          //           if (value!.isEmpty) {
                          //             return Str().invalidMobile;
                          //           } else {
                          //             return null;
                          //           }
                          //         },
                          //         onChanged: (v) {
                          //           setState(() {
                          //             bb = v.toString();
                          //             marketValueAmt(
                          //                 shareCtrl.text.toString(),
                          //                 priceCtrl.text.toString());
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //     SizedBox(width: Dim().d12),
                          //     Expanded(
                          //       child: Container(
                          //         width: 60,
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //             borderRadius:
                          //                 BorderRadius.circular(5),
                          //             border: Border.all(
                          //                 color: Clr().borderColor)),
                          //         child: Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: Dim().d16),
                          //           child: DropdownButtonHideUnderline(
                          //             child: DropdownButton<dynamic>(
                          //               value: markettypevalue,
                          //               hint: Text(
                          //                 markettypevalue ??
                          //                     'Select Market',
                          //                 // 'Select State',
                          //                 style: TextStyle(
                          //                   fontSize: 14,
                          //                   color: markettypevalue != null
                          //                       ? Clr().black
                          //                       : Color(0xff787882),
                          //                   // color: Color(0xff787882),
                          //                   fontFamily: 'Inter',
                          //                 ),
                          //               ),
                          //               isExpanded: true,
                          //               icon: SvgPicture.asset(
                          //                   'assets/dropdown.svg'),
                          //               style: TextStyle(
                          //                   color: markettypevalue != null
                          //                       ? Clr().black
                          //                       : Color(0xff000000)),
                          //               // style: TextStyle(color: Color(0xff787882)),
                          //               items: marketype.map((string) {
                          //                 return DropdownMenuItem<String>(
                          //                   value: string,
                          //                   // value: string['id'].toString(),
                          //                   child: Text(
                          //                     string,
                          //                     // string['name'],
                          //                     style: TextStyle(
                          //                         color: Clr().black,
                          //                         fontSize: 14),
                          //                   ),
                          //                 );
                          //               }).toList(),
                          //               onChanged: (v) {
                          //                 setState(() {
                          //                   markettypevalue =
                          //                       v.toString();
                          //                 });
                          //                 if (v.toString() == 'Market') {
                          //                   setState(() {
                          //                     priceCtrl =
                          //                         TextEditingController(
                          //                             text: data[
                          //                                     'last_price']
                          //                                 .toString());
                          //                     marketValueAmt(
                          //                         shareCtrl.text
                          //                             .toString(),
                          //                         priceCtrl.text
                          //                             .toString());
                          //                   });
                          //                 } else {
                          //                   setState(() {
                          //                     priceCtrl =
                          //                         TextEditingController(
                          //                             text: widget
                          //                                 .details[
                          //                                     'last_price']
                          //                                 .toString());
                          //                     marketValueAmt(
                          //                         shareCtrl.text
                          //                             .toString(),
                          //                         priceCtrl.text
                          //                             .toString());
                          //                     // totalAmountlayut(
                          //                     //     lev: marketValue,
                          //                     //     price: widget
                          //                     //         .details['last_price']
                          //                     //         .toString());
                          //                   });
                          //                 }
                          //                 // setState(() {
                          //                 //   // genderValue = v.toString();
                          //                 //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                          //                 //   // stateId = genderlist[postion]['id'].toString();
                          //                 //   // cityValue = null;
                          //                 //   // cityList = genderlist[postion]['city'];
                          //                 // });
                          //               },
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: Dim().d32,
                          ),

                          Container(
                            width: 162,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(15),
                                border:
                                Border.all(color: Clr().white,width: 0.3)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d8),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<dynamic>(
                                  // value: sState,
                                  dropdownColor: Clr().clr67,
                                  hint: Text(
                                    marketValue ?? 'Leverage',
                                    // 'Select State',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: marketValue != null
                                          ? Clr().white
                                          : Color(0xff787882),
                                      // color: Color(0xff787882),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  isExpanded: true,
                                  // icon: SvgPicture.asset(
                                  //     'assets/dropdown.svg'),
                                  icon: Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: Clr().grey),
                                  style: TextStyle(
                                      color: marketValue != null
                                          ? Clr().white
                                          : Color(0xff000000)),
                                  // style: TextStyle(color: Color(0xff787882)),
                                  items: marketList.map((string) {
                                    return DropdownMenuItem<String>(
                                      value: string,
                                      // value: string['id'].toString(),
                                      child: Text(
                                        string,
                                        // string['name'],
                                        style: TextStyle(
                                            color: Clr().white,
                                            fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      marketValue = v.toString();
                                      // totalAmountlayut(
                                      //     lev: marketValue);
                                      requiredFundAmt();
                                    });
                                    // setState(() {
                                    //   // genderValue = v.toString();
                                    //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                                    //   // stateId = genderlist[postion]['id'].toString();
                                    //   // cityValue = null;
                                    //   // cityList = genderlist[postion]['city'];
                                    // });
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //
                          //     SizedBox(
                          //       width: Dim().d12,
                          //     ),
                          //     Container(
                          //       width: 60,
                          //       height: 40,
                          //       decoration: BoxDecoration(
                          //           borderRadius:
                          //               BorderRadius.circular(5),
                          //           border: Border.all(
                          //               color: Clr().borderColor)),
                          //       child: Padding(
                          //         padding: EdgeInsets.symmetric(
                          //             horizontal: Dim().d8),
                          //         child: DropdownButtonHideUnderline(
                          //           child: DropdownButton<dynamic>(
                          //             // value: sState,
                          //             hint: Text(
                          //               marketValue,
                          //               // 'Select State',
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 color: marketValue != null
                          //                     ? Clr().black
                          //                     : Color(0xff787882),
                          //                 // color: Color(0xff787882),
                          //                 fontFamily: 'Inter',
                          //               ),
                          //             ),
                          //             isExpanded: true,
                          //             icon: SvgPicture.asset(
                          //                 'assets/dropdown.svg'),
                          //             style: TextStyle(
                          //                 color: marketValue != null
                          //                     ? Clr().black
                          //                     : Color(0xff000000)),
                          //             // style: TextStyle(color: Color(0xff787882)),
                          //             items: marketList.map((string) {
                          //               return DropdownMenuItem<String>(
                          //                 value: string,
                          //                 // value: string['id'].toString(),
                          //                 child: Text(
                          //                   string,
                          //                   // string['name'],
                          //                   style: TextStyle(
                          //                       color: Clr().black,
                          //                       fontSize: 14),
                          //                 ),
                          //               );
                          //             }).toList(),
                          //             onChanged: (v) {
                          //               setState(() {
                          //                 marketValue = v.toString();
                          //                 // totalAmountlayut(
                          //                 //     lev: marketValue);
                          //                 requiredFundAmt();
                          //               });
                          //               // setState(() {
                          //               //   // genderValue = v.toString();
                          //               //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                          //               //   // stateId = genderlist[postion]['id'].toString();
                          //               //   // cityValue = null;
                          //               //   // cityList = genderlist[postion]['city'];
                          //               // });
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: Dim().d120),
                          Text(
                            'Break up',
                            style: TextStyle(
                                color: Clr().white, fontSize: 16),
                          ),
                          SizedBox(height: Dim().d4),
                          Divider(
                            color: Clr().clr67,
                            thickness: 1.2,
                          ),
                          SizedBox(height: Dim().d4),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Market Value:- ',
                                  style: Sty().microText.copyWith(
                                      color: Clr().white,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  ' ${totaloMarketValue == null ? 00 : totaloMarketValue.toString().contains('.') ? double.parse(totaloMarketValue.toString()).toStringAsFixed(2) : totaloMarketValue.toString()}',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().clr67,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: Dim().d12),
                            Row(
                              children: [
                                Text(
                                  'Leverage:- ',
                                  style: Sty().microText.copyWith(
                                      color: Clr().white,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '${marketValue}',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().clr67,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: Dim().d12),
                            Row(
                              children: [
                                Text(
                                  'Required Funds:- ',
                                  style: Sty().microText.copyWith(
                                      color: Clr().white,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '${requiredFund == null ? 00 : requiredFund.toString().contains('.') ? double.parse(requiredFund.toString()).toStringAsFixed(2) : requiredFund.toString()}',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().clr67,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: Dim().d12),
                            Row(
                              children: [
                                Text(
                                  'Leverage Amount:- ',
                                  style: Sty().microText.copyWith(
                                      color: Clr().white,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '${leverageAmtFund == null ? 00 : leverageAmtFund.toString().contains('.') ? double.parse(leverageAmtFund.toString()).toStringAsFixed(2) : leverageAmtFund.toString()}',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().clr67,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: Dim().d12),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dim().d16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 100,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-1.0, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              Clr().accentColor,
                              Clr().accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  loading = false;
                                });
                                buyStocklayout();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.transparent,
                                onSurface: Colors.transparent,
                                shadowColor: Colors.transparent,
                                backgroundColor: Color(0xFF13AB86),
                                // backgroundColor: Clr().accentColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: Text(
                              'Buy',
                              style: Sty().largeText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                    SizedBox(height: Dim().d20),
                  ],
                ),
              ),
            ),
    );
  }

  /// awsome dialog for buying status
  buyStocklayout({value}) {
    var select;
    AwesomeDialog(
        width: double.infinity,
        isDense: true,
        context: ctx,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Value : ',
                      style: Sty().microText.copyWith(
                          color: Clr().clr49,
                          fontSize: Dim().d12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ' ₹ ${totaloMarketValue.toString().contains('.') ? double.parse(totaloMarketValue.toString()).toStringAsFixed(2) : totaloMarketValue ?? 00}',
                      style: Sty().smallText.copyWith(
                          color: Clr().clr2c,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  children: [
                    Text(
                      'Quantity : ',
                      style: Sty().microText.copyWith(
                          color: Clr().clr49,
                          fontSize: Dim().d12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${shareCtrl.text.isEmpty ? '0' : shareCtrl.text}',
                      style: Sty().smallText.copyWith(
                          color: Clr().clr2c,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  children: [
                    Text(
                      'Price:',
                      style: Sty().microText.copyWith(
                          color: Clr().clr49,
                          fontSize: Dim().d12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      ' ₹ ${priceCtrl.text}',
                      style: Sty().smallText.copyWith(
                          color: Clr().clr2c,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  children: [
                    Text(
                      'Leverage : ',
                      style: Sty().microText.copyWith(
                          color: Clr().clr49,
                          fontSize: Dim().d12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${marketValue}',
                      style: Sty().smallText.copyWith(
                          color: Clr().clr2c,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  children: [
                    Text(
                      'Transaction Fees : ',
                      style: Sty().microText.copyWith(
                          color: Clr().clr49,
                          fontSize: Dim().d12,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '₹ ${double.parse((totaloMarketValue * 0.2 / 100).toString()).toStringAsFixed(2)}',
                      style: Sty().smallText.copyWith(
                          color: Clr().clr2c,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Column(
                  children: [
                    loading == true
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Clr().primaryColor))
                        : Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF013076),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  stockfunt(
                                      apiname: 'buy_stock',
                                      type: 'post',
                                      value: [
                                        widget.details['id'],
                                        priceCtrl.text,
                                        shareCtrl.text,
                                        marketValue
                                            .toString()
                                            .replaceAll(RegExp(r"\D"), "")
                                      ]);
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
                                  'Proceed',
                                  style: Sty().largeText.copyWith(
                                      fontSize: 16,
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                    // SizedBox(height: Dim().d2),
                    TextButton(
                        onPressed: () {
                          STM().back2Previous(ctx);
                        },
                        child: Text(
                          'Edit',
                          style: Sty().largeText.copyWith(
                              fontSize: 14,
                              color: Color(0xFF013076),
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                )
              ],
            ),
          );
        })).show();
  }

  // /// total amount
  // totalAmountlayut({share, price, lev}) {
  //   int bb = int.parse(shareCtrl.text.toString());
  //   var cc = priceCtrl.text.toString();
  //   int aa = int.parse(marketValue.toString().replaceAll(RegExp(r"\D"), ""));
  //   print('${aa}, ${bb}, ${cc}');
  //   priceCtrl.text.contains('.')
  //       ? setState(() {
  //           totalAmount = aa * bb * double.parse(priceCtrl.text.toString());
  //         })
  //       : setState(() {
  //           totalAmount = aa * bb * int.parse(priceCtrl.text.toString());
  //         });
  // }

  /// Market Value
  marketValueAmt(share, price) {
    int mm = int.parse(share);
    price.toString().contains('.')
        ? setState(() {
            totaloMarketValue = mm * double.parse(price);
            requiredFundAmt();
            leverageAmt();
            print(totaloMarketValue);
          })
        : setState(() {
            totaloMarketValue = mm * int.parse(price);
            requiredFundAmt();
            leverageAmt();
          });
  }

  /// required funds
  requiredFundAmt() {
    int aa = int.parse(marketValue.toString().replaceAll(RegExp(r"\D"), ""));
    setState(() {
      requiredFund = totaloMarketValue / aa;
      leverageAmt();
    });
  }

  /// leverage amount
  leverageAmt() {
    setState(() {
      leverageAmtFund = totaloMarketValue - requiredFund;
    });
  }

  stockfunt({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'buy_stock':
        data = FormData.fromMap({
          'stock_id': value[0],
          'buying_price': value[1],
          'quantity': value[2],
          'leverage': value[3],
          'type': markettypevalue,
        });
        break;
      case 'sell_stock':
        FormData.fromMap({
          'stock_trade_id': value[0],
          'selling_price': value[1],
        });
        break;
    }
    FormData body = data;
    var result = type == 'get'
        ? await STM().getWithoutDialog(ctx, apiname, Token)
        : await STM().postListWithoutDialog(ctx, apiname, Token, body);
    var success = result['success'];
    var message = result['message'];
    switch (apiname) {
      case 'get_profile':
        if (result['success']) {
          setState(() {
            profileList = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'buy_stock':
        if (result['success']) {
          setState(() {
            loading = false;
          });
          STM().successDialogWithAffinity(ctx, message, Home());
        } else {
          STM().back2Previous(ctx);
          STM().errorDialog(ctx, message);
        }
        break;
      case "sell_stock":
        if (success) {
          STM().displayToast(message, ToastGravity.CENTER);
        } else {
          STM().errorDialog(ctx, message);
        }
        break;
    }
  }

  /// api type
  apitype() async {
    FormData body = FormData.fromMap({'stock_id': widget.details['id']});
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
      });
      markettypevalue == 'Market'
          ? marketValueAmt(
              shareCtrl.text.isEmpty ? '0' : shareCtrl.text.toString(),
              data['last_price'].toString())
          : null;
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}

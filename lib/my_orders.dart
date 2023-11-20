import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/portfoilio.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/watchlist.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class MyOrders extends StatefulWidget {
  final type;

  const MyOrders({super.key, required this.type});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late BuildContext ctx;
  String? Token;
  bool? loading;
  List<dynamic> ordersList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apitype(apiname: 'my_orders', type: 'get');
          setState(() {
            loading = true;
          });
        }
      },
    );
    print(Token);
  }

  bool check = false;

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
                : STM().replacePage(ctx, WatchList(type: 1));
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 3, ''),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 0
                  ? STM().finishAffinity(ctx, Home())
                  : widget.type == 1
                      ? STM().replacePage(ctx, Portfolio())
                      : STM().replacePage(ctx, WatchList(type: 1));
            },
            child: Padding(
              padding: EdgeInsets.all(Dim().d8),
              child: SvgPicture.asset('assets/back.svg', height: Dim().d12),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Orders Pages',
            style: Sty()
                .mediumText
                .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: ordersList.isEmpty
              ? check
                  ? SizedBox(
                      height: MediaQuery.of(ctx).size.height / 1.5,
                      child: Center(
                        child: Text("No Orders,Please buy some stocks!!!!",
                            style: Sty().mediumBoldText),
                      ),
                    )
                  : Container()
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: ordersList.length,
                  itemBuilder: (ctx, index) {
                    return cardLayout(ctx, ordersList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: Dim().d12,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget cardLayout(ctx, v) {
    bool click = true;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
            border: Border.all(color: Clr().clrec, width: 1.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${v['order_id']}',
                    style: Sty().microText.copyWith(
                        color: Clr().clr49,
                        fontSize: Dim().d12,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${v['created_at']}',
                    style: Sty().microText.copyWith(
                        color: Clr().clr49,
                        fontWeight: FontWeight.w400,
                        fontSize: Dim().d12),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Divider(
                color: Clr().grey,
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${v['stock']['symbol']}',
                    style: Sty().smallText.copyWith(
                        color: Clr().clr2c,
                        fontWeight: FontWeight.w600,
                        fontSize: Dim().d16),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: v['status'].toString() == 'pending'
                            ? Clr().cornsilk
                            : v['status'].toString() == 'completed'
                                ? Clr().accentColorlight
                                : Clr().cornred,
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d8))),
                    child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('${v['status'].toString()}',
                            style: Sty().mediumText.copyWith(
                                color: v['status'].toString() == 'pending'
                                    ? Clr().ef
                                    : v['status'].toString() == 'completed'
                                        ? Clr().accentColor
                                        : Clr().red,
                                fontSize: Dim().d12,
                                fontWeight: FontWeight.w400))),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Price : ',
                        style: Sty().mediumText.copyWith(
                            color: Clr().clr49,
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d14),
                        children: [
                          TextSpan(
                              text: '₹${v['price']}',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().clr2c,
                                  fontSize: Dim().d14,
                                  fontWeight: FontWeight.w400))
                        ]),
                  ),
                  Text('${v['type_string']}',
                      style: Sty().mediumText.copyWith(
                          color: v['type_string'].toString().contains('Buy')
                              ? Clr().greenaa
                              : Clr().red,
                          fontWeight: FontWeight.w600,
                          fontSize: Dim().d16))
                ],
              ),
              SizedBox(height: Dim().d4),
              InkWell(
                onTap: () {
                  dialogLayout(v);
                },
                child: SizedBox(
                  child: RichText(
                      text: TextSpan(
                          text: 'More Details',
                          style: Sty().mediumText.copyWith(
                              color: Clr().clr00,
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400),
                          children: [
                        WidgetSpan(
                            child: Text(
                          ' >>',
                          style: Sty().mediumText.copyWith(
                              color: Clr().clr00,
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400),
                        ))
                      ])),
                ),
              )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     if (v['status'].toString() == 'pending')
              //       ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //               backgroundColor: Clr().errorRed),
              //           onPressed: () {
              //             apitype(
              //                 type: 'post',
              //                 apiname: 'cancel_order',
              //                 value: [
              //                   v['stock_trade_id'],
              //                   v['id'],
              //                   v['type_string']
              //                 ]);
              //           },
              //           child: Text(
              //             'Cancel',
              //             style: Sty().mediumText.copyWith(color: Clr().white),
              //           )),
              //     if (v['stock_trade'] != null &&
              //         v['type_string'] == 'Sell' &&
              //         v['status'].toString() == 'completed')
              //       RichText(
              //         text: TextSpan(
              //             text: 'Net P/L: ',
              //             style: Sty().smallText.copyWith(color: Clr().grey),
              //             children: [
              //               TextSpan(
              //                   text: '${v['stock_trade']['net_floating_p_l']}',
              //                   style: Sty().smallText.copyWith(
              //                       color: v['stock_trade']['net_floating_p_l']
              //                               .toString()
              //                               .contains('-')
              //                           ? Clr().red
              //                           : Clr().grey))
              //             ]),
              //       ),
              //     Text(
              //       'Qty: ${v['quantity']}',
              //       style: Sty().smallText.copyWith(
              //           color: Clr().grey, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       'Price :  ${v['price']}',
              //       style: Sty().smallText.copyWith(
              //           color: Clr().grey, fontWeight: FontWeight.w300),
              //     ),
              //   ],
              // ),
              // if (v['stock_trade'] != null &&
              //     v['type_string'] == 'Sell' &&
              //     v['status'].toString() == 'completed')
              //   SizedBox(height: Dim().d12),
              // if (v['stock_trade'] != null &&
              //     v['type_string'] == 'Sell' &&
              //     v['status'].toString() == 'completed')
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       if (v['stock_trade']['deffered_fee'] != null)
              //         RichText(
              //           text: TextSpan(
              //               text: 'Deffered Fee: ',
              //               style: Sty().smallText.copyWith(color: Clr().grey),
              //               children: [
              //                 TextSpan(
              //                     text: '${v['stock_trade']['deffered_fee']}',
              //                     style: Sty()
              //                         .smallText
              //                         .copyWith(color: Clr().grey))
              //               ]),
              //         ),
              //       SizedBox(
              //         width: Dim().d12,
              //       ),
              //       if (v['stock_trade']['leverage'] != null)
              //         RichText(
              //           text: TextSpan(
              //               text: 'Leverage: ',
              //               style: Sty().smallText.copyWith(color: Clr().grey),
              //               children: [
              //                 TextSpan(
              //                     text: '${v['stock_trade']['leverage']}x',
              //                     style: Sty()
              //                         .smallText
              //                         .copyWith(color: Clr().grey))
              //               ]),
              //         ),
              //     ],
              //   ),
              // if (v['stock_trade'] != null &&
              //     v['type_string'] == 'Sell' &&
              //     v['status'].toString() == 'completed')
              //   click
              //       ? Container()
              //       : Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['leverage_amount'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Leverage Amt: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['leverage_amount']}',
              //                                 style: Sty()
              //                                     .smallText
              //                                     .copyWith(color: Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //                 // RichText(
              //                 //   text: TextSpan(.............
              //                 //       text: 'Quantity:- ',
              //                 //       style: Sty().smallText.copyWith(color: Clr().grey),
              //                 //       children: [
              //                 //         TextSpan(
              //                 //             text: '${v['stock_trade']['quantity']}',
              //                 //             style: Sty().smallText.copyWith(color: Clr().grey))
              //                 //       ]),
              //                 // ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['transaction_fee'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Transaction Fee: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['transaction_fee']}',
              //                                 style: Sty()
              //                                     .smallText
              //                                     .copyWith(color: Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //                 // RichText(
              //                 //   text: TextSpan(
              //                 //       text: 'Additional Prepayment:- ',
              //                 //       style: Sty().smallText.copyWith(color: Clr().grey),
              //                 //       children: [
              //                 //         TextSpan(
              //                 //             text: '${v['stock_trade']['additional_prepayment']}',
              //                 //             style: Sty().smallText.copyWith(color: Clr().grey))
              //                 //       ]),
              //                 // ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['in_hand_amount'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'In Hand Amount: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['in_hand_amount']}',
              //                                 style: Sty()
              //                                     .smallText
              //                                     .copyWith(color: Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['additional_prepayment'] !=
              //                     null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Additional PreAmount: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['additional_prepayment']}',
              //                                 style: Sty()
              //                                     .smallText
              //                                     .copyWith(color: Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['wallet_amount'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'PreAmount: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['wallet_amount']}',
              //                                 style: Sty()
              //                                     .smallText
              //                                     .copyWith(color: Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['floating_p_l'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Floating P/L: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['floating_p_l']}',
              //                                 style: Sty().smallText.copyWith(
              //                                     color: v['stock_trade']
              //                                                 ['floating_p_l']
              //                                             .toString()
              //                                             .contains('-')
              //                                         ? Clr().red
              //                                         : Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']
              //                         ['stop_loss_limit_percentage'] !=
              //                     null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Stop Loss Limit : ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['stop_loss_limit_percentage']}%',
              //                                 style: Sty().smallText.copyWith(
              //                                     color: v['stock_trade'][
              //                                                 'stop_loss_limit_percentage']
              //                                             .toString()
              //                                             .contains('-')
              //                                         ? Clr().red
              //                                         : Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['stop_loss_limit'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Stop Loss Limit: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['stop_loss_limit']}',
              //                                 style: Sty().smallText.copyWith(
              //                                     color: v['stock_trade'][
              //                                                 'stop_loss_limit']
              //                                             .toString()
              //                                             .contains('-')
              //                                         ? Clr().red
              //                                         : Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['profit_limit_percentage'] !=
              //                     null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Profit Limit : ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['profit_limit_percentage']}%',
              //                                 style: Sty().smallText.copyWith(
              //                                     color: v['stock_trade'][
              //                                                 'profit_limit_percentage']
              //                                             .toString()
              //                                             .contains('-')
              //                                         ? Clr().red
              //                                         : Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 if (v['stock_trade']['profit_limit'] != null)
              //                   Padding(
              //                     padding: EdgeInsets.only(top: Dim().d12),
              //                     child: RichText(
              //                       text: TextSpan(
              //                           text: 'Profit Limit: ',
              //                           style: Sty()
              //                               .smallText
              //                               .copyWith(color: Clr().grey),
              //                           children: [
              //                             TextSpan(
              //                                 text:
              //                                     '${v['stock_trade']['profit_limit']}',
              //                                 style: Sty().smallText.copyWith(
              //                                     color: v['stock_trade']
              //                                                 ['profit_limit']
              //                                             .toString()
              //                                             .contains('-')
              //                                         ? Clr().red
              //                                         : Clr().grey))
              //                           ]),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //           ],
              //         ),
              // if (v['stock_trade'] != null &&
              //     v['type_string'] == 'Sell' &&
              //     v['status'].toString() == 'completed')
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(top: Dim().d12),
              //         child: InkWell(
              //             onTap: () {
              //               if (click == true) {
              //                 setState(() {
              //                   click = false;
              //                 });
              //               } else {
              //                 setState(() {
              //                   click = true;
              //                 });
              //               }
              //             },
              //             child: Text(
              //                 click == true ? 'More Details >>' : '<< Less',
              //                 style: Sty().microText.copyWith(
              //                     color: Colors.black26,
              //                     fontWeight: FontWeight.w600))),
              //       )
              //     ],
              //   ),
            ],
          ),
        ),
      );
    });
  }

  dialogLayout(v) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d12),
          child: Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Clr().white,
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d14))),
              child: Padding(
                padding: EdgeInsets.all(Dim().d14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Sell Price : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              v['stock_trade']['selling_price'] == null
                                  ? TextSpan()
                                  : TextSpan(
                                      text:
                                          '₹ ${v['stock_trade']['selling_price']}',
                                      //'${v['stock_trade']['net_floating_p_l']}',
                                      style: Sty().smallText.copyWith(
                                            color: Clr().clr2c,
                                            fontSize: Dim().d14,
                                            fontWeight: FontWeight.w600,
                                            // v['stock_trade']['net_floating_p_l']
                                            //     .toString()
                                            //     .contains('-')
                                            //     ? Clr().red
                                            //     : Clr().grey
                                          ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Quantity : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text: '${v['stock_trade']['quantity']}',
                                  //'${v['stock_trade']['quantity']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Leverage : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text: '${v['stock_trade']['leverage']}x',
                                  //'${v['stock_trade']['leverage']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Leverage Amount : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text:
                                      '₹ ${v['stock_trade']['leverage_amount']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Pre-payment : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text: v['stock_trade']
                                              ['additional_prepayment'] ==
                                          null
                                      ? '-'
                                      : '₹ ${v['stock_trade']['additional_prepayment']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Market Value : ',
                          style: Sty().smallText.copyWith(
                              color: Clr().clr49,
                              fontWeight: FontWeight.w400,
                              fontSize: Dim().d14),
                          children: [
                            TextSpan(
                                text: '₹ ${v['stock_trade']['market_capital']}',
                                //'${v['stock_trade']['net_floating_p_l']}',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr2c,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600,
                                      // v['stock_trade']['net_floating_p_l']
                                      //     .toString()
                                      //     .contains('-')
                                      //     ? Clr().red
                                      //     : Clr().grey
                                    ))
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Dim().d16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Clr().a4,
                              thickness: 1.5,
                              height: 5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                            child: Text('Transaction Details',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr01,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dim().d16,
                                    decoration: TextDecoration.none)),
                          ),
                          Expanded(
                            child: Divider(
                              color: Clr().a4,
                              thickness: 1.5,
                              height: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'In-Hand Amount : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text:
                                      '₹ ${v['stock_trade']['in_hand_amount']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Floating P/L : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text: '₹ ${v['stock_trade']['floating_p_l']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Transaction Fees : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text:
                                      '₹ ${v['stock_trade']['transaction_fee']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dim().d12),
                      child: RichText(
                        text: TextSpan(
                            text: 'Deferred Fees : ',
                            style: Sty().smallText.copyWith(
                                color: Clr().clr49,
                                fontWeight: FontWeight.w400,
                                fontSize: Dim().d14),
                            children: [
                              TextSpan(
                                  text: '₹ ${v['stock_trade']['deffered_fee']}',
                                  //'${v['stock_trade']['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // v['stock_trade']['net_floating_p_l']
                                        //     .toString()
                                        //     .contains('-')
                                        //     ? Clr().red
                                        //     : Clr().grey
                                      ))
                            ]),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Net Floating P/L : ',
                          style: Sty().smallText.copyWith(
                              color: Clr().clr49,
                              fontWeight: FontWeight.w400,
                              fontSize: Dim().d14),
                          children: [
                            TextSpan(
                                text:
                                    '₹ ${v['stock_trade']['net_floating_p_l']}',
                                //'${v['stock_trade']['net_floating_p_l']}',
                                style: Sty().smallText.copyWith(
                                      color: Clr().clr2c,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600,
                                      // v['stock_trade']['net_floating_p_l']
                                      //     .toString()
                                      //     .contains('-')
                                      //     ? Clr().red
                                      //     : Clr().grey
                                    ))
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Dim().d16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: Dim().d12, right: Dim().d12),
                            child: Text('Stoploss Limit',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr01,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dim().d16,
                                    decoration: TextDecoration.none)),
                          ),
                          Expanded(
                            child: Divider(
                              color: Clr().a4,
                              thickness: 1.5,
                              height: 5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: Dim().d16, left: Dim().d12),
                            child: Text('Profit Limit',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr01,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dim().d16,
                                    decoration: TextDecoration.none)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: Dim().d80,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Clr().a4, width: 1.5))),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dim().d16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Lost value :',
                                      style: Sty().mediumText.copyWith(
                                          decoration: TextDecoration.none,
                                          color: Clr().clr49,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                      v['stock_trade']['stop_loss_limit']
                                              .toString()
                                              .contains('-')
                                          ? '- ₹ ${v['stock_trade']['stop_loss_limit']} ${(v['stock_trade']['stop_loss_limit_percentage'])}%'
                                          : '₹ ${v['stock_trade']['stop_loss_limit']} (${v['stock_trade']['stop_loss_limit_percentage']}%)',
                                      style: Sty().mediumText.copyWith(
                                          decoration: TextDecoration.none,
                                          color: Clr().clr2c,
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dim().d14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dim().d20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Profit value :',
                                      style: Sty().mediumText.copyWith(
                                          decoration: TextDecoration.none,
                                          color: Clr().clr49,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400)),
                                  Text(v['stock_trade']['profit_limit']
                                      .toString()
                                      .contains('-')
                                      ? '- ₹ ${v['stock_trade']['profit_limit']} ${(v['stock_trade']['profit_limit_percentage'])}%'
                                      : '₹ ${v['stock_trade']['profit_limit']} (${v['stock_trade']['profit_limit_percentage']}%)',
                                      style: Sty().mediumText.copyWith(
                                          decoration: TextDecoration.none,
                                          color: Clr().clr2c,
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dim().d14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// api type
  apitype({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'buy_stock':
        data = FormData.fromMap({
          'stock_id': value[0],
          'buying_price': value[1],
          'quantity': value[2],
        });
        break;
      case 'sell_stock':
        data = FormData.fromMap({
          'stock_trade_id': value[0],
          'selling_price': value[1],
          'stock_id': value[2],
        });
        break;
      case 'cancel_order':
        data = FormData.fromMap({
          'stock_trade_id': value[0],
          'order_id': value[1],
          'type': value[2]
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
      case 'my_orders':
        if (result['success']) {
          setState(() {
            loading = false;
            check = true;
            ordersList = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case "sell_stock":
        if (success) {
          STM().displayToast(message, ToastGravity.CENTER);
        } else {
          STM().errorDialog(ctx, message);
        }
        break;
      case "cancel_order":
        if (success) {
          apitype(apiname: 'my_orders', type: 'get');
          STM().successDialog(ctx, message, widget);
        } else {
          STM().errorDialog(ctx, message);
        }
        break;
    }
  }
}

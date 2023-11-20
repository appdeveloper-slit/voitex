import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/search_stocks.dart';
import 'package:voitex/sellpage.dart';
import 'package:voitex/stock_chart.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'notification.dart';
import 'portfolio_stock.dart';

class Portfolio extends StatefulWidget {
  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  late BuildContext ctx;
  String? Token;
  bool? loading;
  dynamic portfolioData;
  double? currentValue, totalInvestment, totalPl, avg, percenTage;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });

    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apiprotfolio(apiname: 'get_portfolio', type: 'get');
          loading = true;
        }
      },
    );
    print(Token);
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  late Stream stream = Stream.periodic(Duration(seconds: 5)).asyncMap(
      (event) async =>
          await apiprotfolio(apiname: 'get_portfolio', type: 'get'));

  String formatAmount(amount) {
    if (amount >= 1000 && amount < 100000) {
      // Convert to "K" (thousands)
      return NumberFormat('#,##,##0.##', 'en_IN')
              .format(amount / 1000)
              .toString() +
          ' K';
      ;
    } else if (amount >= 100000) {
      // Convert to "Lakh" (hundreds of thousands) with Indian Rupee symbol (₹)
      return NumberFormat('#,##,##0.###', 'en_IN')
              .format(amount / 100000)
              .toString() +
          ' Lakh';
    } else {
      // Use regular formatting for smaller amounts
      return NumberFormat('#,##0', 'en_IN').format(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 1, stream),
        backgroundColor: Clr().white,
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 6), () {
              setState(() {
                apiprotfolio(apiname: 'get_portfolio', type: 'get');
              });
            });
          },
          color: Clr().primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: loading == true
                ? SizedBox(
                    height: MediaQuery.of(ctx).size.height / 1.3,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Clr().primaryColor)),
                  )
                : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Clr().clr01,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(Dim().d28),
                                bottomLeft: Radius.circular(Dim().d28)),
                            border:
                                Border.all(color: Clr().clr164a, width: 1.0)),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              SizedBox(height: Dim().d24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      STM().finishAffinity(ctx, Home());
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: Dim().d16),
                                      child: SvgPicture.asset(
                                        'assets/back.svg',
                                        color: Clr().white,
                                        height: Dim().d16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Portfolio',
                                    style: Sty().mediumText.copyWith(
                                        color: Clr().white,
                                        fontSize: Dim().d20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(Dim().d16),
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              STM().replacePage(ctx,
                                                  SearchStocks(type: 'port'));
                                            },
                                            child: SvgPicture.asset(
                                                'assets/search.svg',
                                                color: Clr().white)),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: Dim().d16),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d16)),
                                    border: Border.all(
                                        color: Clr().clr164a, width: 1)),
                                child: Padding(
                                  padding: EdgeInsets.all(Dim().d16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Clr().clr164a,
                                                          width: 1.0))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Current Value:',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color:
                                                                  Clr().white,
                                                              fontSize:
                                                                  Dim().d12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                  SizedBox(height: Dim().d8),
                                                  if(portfolioData != null)
                                                  Text(
                                                      '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['current_value'])}',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color:
                                                                  Clr().white,
                                                              fontSize:
                                                                  Dim().d20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dim().d12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Total Investment:',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color:
                                                                  Clr().white,
                                                              fontSize:
                                                                  Dim().d12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                  SizedBox(height: Dim().d8),
                                                  Text(
                                                      '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['investment_value'])}',
                                                      style: Sty()
                                                          .mediumText
                                                          .copyWith(
                                                              color:
                                                                  Clr().white,
                                                              fontSize:
                                                                  Dim().d20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Clr().clr164a,
                                        thickness: 1.0,
                                        height: 15,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Image.asset('assets/nifty.png',
                                                height: Dim().d20),
                                            SizedBox(width: Dim().d14),
                                            Text(
                                              'Total P/L:',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Dim().d14),
                                            ),
                                            SizedBox(width: Dim().d12),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                portfolioData['percent']
                                                        .toString()
                                                        .contains('-')
                                                    ? Image.asset(
                                                        'assets/failedarrow.png',
                                                        height: Dim().d24,
                                                        width: Dim().d16,
                                                      )
                                                    : Image.asset(
                                                        'assets/successarrow.png',
                                                        height: Dim().d24,
                                                        width: Dim().d16,
                                                      ),
                                                Text(
                                                  '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['profit_loss'])}',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                        fontSize: Dim().d16,
                                                        color: portfolioData[
                                                                    'percent']
                                                                .toString()
                                                                .contains('-')
                                                            ? Clr().red
                                                            : Clr().green,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: Dim().d24),
                                            Text(
                                              portfolioData['percent']
                                                      .toString()
                                                      .contains('-')
                                                  ? '(${portfolioData['percent']}%)'
                                                  : '(+${portfolioData['percent']}%)',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().clr56,
                                                  fontSize: Dim().d14,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Dim().d16),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dim().d20),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Clr().grey.withOpacity(0.1),
                      //         spreadRadius: 0.1,
                      //         blurRadius: 12,
                      //         offset:
                      //             Offset(0, 7), // changes position of shadow
                      //       ),
                      //     ],
                      //   ),
                      //   child: Card(
                      //     color: Color(0xffF8F9F8),
                      //     margin: EdgeInsets.zero,
                      //     elevation: 0,
                      //     shape: RoundedRectangleBorder(
                      //       // side: BorderSide(color: Clr().borderColor),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         vertical: Dim().d16,
                      //       ),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Expanded(
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'Current\nValue',
                      //                   textAlign: TextAlign.center,
                      //                   style: Sty()
                      //                       .smallText
                      //                       .copyWith(color: Clr().grey),
                      //                 ),
                      //                 SizedBox(
                      //                   height: Dim().d12,
                      //                 ),
                      //                 Text(
                      //                   // '₹ ${currentValue == null ? '000' : currentValue!.toStringAsFixed(2)}',
                      //                   '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['current_value'])}',
                      //                   style: Sty()
                      //                       .mediumText
                      //                       .copyWith(color: Clr().textcolor),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Container(
                      //             height: 100,
                      //             width: 1,
                      //             color: Clr().grey,
                      //           ),
                      //           Expanded(
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'Total\nInvestment',
                      //                   textAlign: TextAlign.center,
                      //                   style: Sty()
                      //                       .smallText
                      //                       .copyWith(color: Clr().grey),
                      //                 ),
                      //                 SizedBox(
                      //                   height: Dim().d12,
                      //                 ),
                      //                 Text(
                      //                   '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['investment_value'])}',
                      //                   style: Sty()
                      //                       .mediumText
                      //                       .copyWith(color: Clr().textcolor),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Container(
                      //             height: 100,
                      //             width: 1,
                      //             color: Clr().grey,
                      //           ),
                      //           Expanded(
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'Total\nP/L',
                      //                   textAlign: TextAlign.center,
                      //                   style: Sty()
                      //                       .smallText
                      //                       .copyWith(color: Clr().grey),
                      //                 ),
                      //                 SizedBox(
                      //                   height: Dim().d12,
                      //                 ),
                      //                 portfolioData.isEmpty
                      //                     ? Container()
                      //                     : Wrap(
                      //                         crossAxisAlignment:
                      //                             WrapCrossAlignment.center,
                      //                         children: [
                      //                           portfolioData['percent']
                      //                                   .toString()
                      //                                   .contains('-')
                      //                               ? Icon(
                      //                                   Icons
                      //                                       .arrow_downward_outlined,
                      //                                   color: Clr().red,
                      //                                   size: Dim().d20)
                      //                               : Icon(
                      //                                   Icons
                      //                                       .arrow_upward_outlined,
                      //                                   color: Clr().green,
                      //                                   size: Dim().d20),
                      //                           SizedBox(
                      //                             width: Dim().d8,
                      //                           ),
                      //                           Text(
                      //                             '₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['profit_loss'])}',
                      //                             style: Sty()
                      //                                 .mediumText
                      //                                 .copyWith(
                      //                                     color: portfolioData[
                      //                                                 'percent']
                      //                                             .toString()
                      //                                             .contains('-')
                      //                                         ? Clr().red
                      //                                         : Clr().green),
                      //                           )
                      //                         ],
                      //                       ),
                      //                 SizedBox(
                      //                   height: Dim().d8,
                      //                 ),
                      //                 portfolioData.isEmpty
                      //                     ? Container()
                      //                     : Text(
                      //                         portfolioData['percent']
                      //                                 .toString()
                      //                                 .contains('-')
                      //                             ? '(${portfolioData['percent']}%)'
                      //                             : '(+${portfolioData['percent']}%)',
                      //                         style: Sty()
                      //                             .smallText
                      //                             .copyWith(color: Clr().grey),
                      //                       ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: Dim().d20,
                      // ),
                      // portfolioData.isEmpty
                      //     ? Container(
                      //         child: Padding(
                      //           padding: EdgeInsets.all(20.0),
                      //           child: Text('You do not have any Active orders',
                      //               style: Sty().mediumText),
                      //         ),
                      //       )
                      //     :
                      // StreamBuilder(
                      //         stream: stream,
                      //         builder: (context, AsyncSnapshot snapshot) {
                      //           return ListView.separated(
                      //             padding: EdgeInsets.zero,
                      //             shrinkWrap: true,
                      //             physics: BouncingScrollPhysics(),
                      //             itemCount: 3,
                      //                 // portfolioData['stock_trades'].length,
                      //             itemBuilder: (ctx, index) {
                      //               return cardLayout(ctx, List
                      //                   // portfolioData['stock_trades'][index]
                      //               );
                      //             },
                      //             separatorBuilder: (context, index) {
                      //               return SizedBox(
                      //                 height: Dim().d8,
                      //               );
                      //             },
                      //           );
                      //         })
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: portfolioData['stock_trades'].length,
                        itemBuilder: (ctx, index) {
                          return cardLayout(
                              ctx, portfolioData['stock_trades'][index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: Dim().d8,
                          );
                        },
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget cardLayout(ctx, v) {
    return Padding(
      padding: EdgeInsets.only(left: Dim().d12, right: Dim().d12),
      child: InkWell(
        onTap: () {
          // STM().redirect2page(ctx, PortfolioStock());
          STM().redirect2page(
              ctx,
              SellPage(
                details: v,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Clr().clrec, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(Dim().d14))),
          child: Padding(
            padding: EdgeInsets.all(Dim().d12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${v['stock']['symbol']}',
                          // '${v['stock']['symbol']}',
                          style: Sty().smallText.copyWith(
                              color: Clr().clr2c,
                              fontSize: Dim().d16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: Dim().d8),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xffD1E4FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d8))),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Qty: ${v['quantity']}',
                              //'Qty: ${v['quantity']}',
                              style: Sty().microText.copyWith(
                                  color: Clr().clr00,
                                  fontSize: Dim().d12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹ ${v['buying_price']}',
                      style: Sty().mediumText.copyWith(
                          color: Clr().clr2c,
                          fontWeight: FontWeight.w600,
                          fontSize: Dim().d16),
                    )
                  ],
                ),
                Divider(
                  color: Clr().clrec,
                  thickness: 1.0,
                  height: 15,
                ),
                SizedBox(
                  height: Dim().d16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Total P/L : ',
                          style: Sty().mediumText.copyWith(
                              color: Clr().clr49,
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w400)),
                      Text(
                          ' ₹ ${v['net_floating_p_l'].toString().contains('.') ? double.parse(v['net_floating_p_l'].toString()).toStringAsFixed(2) : v['net_floating_p_l']}',
                          style: Sty().mediumText.copyWith(
                              color: v['net_floating_p_l_percent']
                                      .toString()
                                      .contains('-')
                                  ? Clr().red
                                  : Clr().greenaa,
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w600)),
                      Text(
                          v['net_floating_p_l_percent'].toString().contains('-')
                              ? ' (${v['net_floating_p_l_percent']}%)'
                              : ' (+${v['net_floating_p_l_percent']}%)',
                          style: Sty().mediumText.copyWith(
                              color: Clr().clr49,
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'TITAN',// '${v['stock']['symbol']}',
                //             style: Sty().smallText.copyWith(
                //                 color: Clr().clr2c,
                //                 fontSize: Dim().d16,
                //                 fontWeight: FontWeight.w600),
                //           ),
                //           SizedBox(
                //             height: Dim().d8,
                //           ),
                //           Text(
                //             'Qty: ${v['quantity']}',
                //             style: Sty().microText.copyWith(color: Clr().grey),
                //           ),
                //           // SizedBox(
                //           //   height: Dim().d8,
                //           // ),
                //           // Text(
                //           //   'Avg: ${v['average']}',
                //           //   style: Sty().microText.copyWith(color: Clr().grey),
                //           // ),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Text(
                //             '₹ ${v['buying_price']}',
                //             style: Sty().smallText.copyWith(),
                //           ),
                //           SizedBox(
                //             height: Dim().d8,
                //           ),
                //           RichText(
                //             text: TextSpan(
                //                 text: 'Total P/L:',
                //                 style: Sty().microText.copyWith(color: Clr().grey),
                //                 children: [
                //                   TextSpan(
                //                       text:
                //                           ' ₹ ${v['net_floating_p_l'].toString().contains('.') ? double.parse(v['net_floating_p_l'].toString()).toStringAsFixed(2) : v['net_floating_p_l']}',
                //                       style: Sty().smallText.copyWith(
                //                           color: v['net_floating_p_l_percent']
                //                                   .toString()
                //                                   .contains('-')
                //                               ? Clr().red
                //                               : Clr().green))
                //                 ]),
                //           ),
                //           SizedBox(
                //             height: Dim().d8,
                //           ),
                //           Text(
                //             v['net_floating_p_l_percent'].toString().contains('-')
                //                 ? '(${v['net_floating_p_l_percent']}%)'
                //                 : '(+${v['net_floating_p_l_percent']}%)',
                //             style: Sty().smallText.copyWith(color: Clr().grey),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///getprofile
  apiprotfolio({apiname, type, value}) async {
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
      case 'get_portfolio':
        if (result['success']) {
          setState(() {
            portfolioData = result['data'];
            loading = false;
          });
          // for (int a = 0; a < portfolioData['invested_stocks'].length; a++) {
          //   setState(() {
          //     // currentValue = int.parse(portfolioData['invested_stocks'][a]['total_quantity'].toString()) * portfolioData['invested_stocks'][a]['stock']['last_price'] as double;
          //     // totalInvestment = portfolioData['invested_stocks'][a]['final_total_buying_price'];
          //     print(int.parse(portfolioData['invested_stocks'][a]
          //                 ['total_quantity']
          //             .toString()) *
          //         int.parse(portfolioData['invested_stocks'][a]
          //                 ['total_quantity']
          //             .toString()));
          //   });
          // }
          // List data = [];
          // data = portfolioData['invested_stocks'];
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}

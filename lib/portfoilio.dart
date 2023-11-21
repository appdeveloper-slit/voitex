import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
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
          body: SizedBox(
            height: MediaQuery.of(ctx).size.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xff060D15),
                    Color(0xff131F2E),
                  ])),
              child: RefreshIndicator(
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
                                  color: Clr().white)),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dim().d36, horizontal: Dim().d16),
                          child: Column(
                            children: [
                              SizedBox(height: Dim().d28),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      STM().finishAffinity(ctx, Home());
                                    },
                                    child: Image.asset(
                                      'assets/backicon.png',
                                      height: Dim().d36,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dim().d100,
                                  ),
                                  Text(
                                    'My Portfolio',
                                    style: Sty().mediumText.copyWith(
                                        color: Clr().white,
                                        fontSize: Dim().d20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dim().d16),
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                    color: Clr().black,
                                    border: Border.all(
                                        color: Clr().white, width: 0.1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d12))),
                                child: BlurryContainer(
                                  blur: 10,
                                  width: double.infinity,
                                  color: Clr().transparent,
                                  elevation: 1.0,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d12)),
                                  child: Padding(
                                    padding: EdgeInsets.all(Dim().d4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Clr().clr67,
                                                        width: 1.0))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text('Current \nValue: ',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                color:
                                                                    Clr().clr67,
                                                                fontSize:
                                                                    Dim().d12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                    if (portfolioData != null)
                                                      Text(
                                                          ' ₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['current_value'])}',
                                                          style: Sty()
                                                              .mediumText
                                                              .copyWith(
                                                                  color: Clr()
                                                                      .white,
                                                                  fontSize:
                                                                      Dim().d16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Dim().d20,
                                                ),
                                                Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text('Total \nInvestment:',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                color:
                                                                    Clr().clr67,
                                                                fontSize:
                                                                    Dim().d12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                    Text(
                                                        ' ₹ ${portfolioData.isEmpty ? 00 : formatAmount(portfolioData['investment_value'])}',
                                                        style: Sty()
                                                            .mediumText
                                                            .copyWith(
                                                                color:
                                                                    Clr().white,
                                                                fontSize:
                                                                    Dim().d16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: Dim().d20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total P/L:',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color: Clr().clr67,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: Dim().d14),
                                                ),
                                                SizedBox(height: Dim().d8),
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
                                                                    .contains(
                                                                        '-')
                                                                ? Clr().red
                                                                : Clr().green,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: Dim().d8),
                                                Text(
                                                  portfolioData['percent']
                                                          .toString()
                                                          .contains('-')
                                                      ? '(${portfolioData['percent']}%)'
                                                      : '(+${portfolioData['percent']}%)',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color: Clr().clr67,
                                                          fontSize: Dim().d14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Dim().d16),
                              portfolioData['stock_trades'].length == 0
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white10,
                                              spreadRadius: 1,
                                            )
                                          ],
                                          color: Clr().black,
                                          border: Border.all(
                                              color: Clr().white, width: 0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Dim().d12))),
                                      child: BlurryContainer(
                                        blur: 10,
                                        width: double.infinity,
                                        color: Clr().transparent,
                                        elevation: 1.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dim().d12)),
                                        child: Padding(
                                          padding: EdgeInsets.all(Dim().d4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('My Stocks',
                                                  style:
                                                      Sty().mediumText.copyWith(
                                                            color: Clr().white,
                                                            fontSize: Dim().d24,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                              ListView.separated(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: portfolioData[
                                                        'stock_trades']
                                                    .length,
                                                itemBuilder: (ctx, index) {
                                                  return cardLayout(
                                                      ctx,
                                                      portfolioData[
                                                              'stock_trades']
                                                          [index]);
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(
                                                    height: Dim().d8,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          )),
    );
  }

  Widget cardLayout(ctx, v) {
    return InkWell(
      onTap: () {
        // STM().redirect2page(ctx, PortfolioStock());
        STM().redirect2page(
            ctx,
            SellPage(
              details: v,
            ));
      },
      child: Padding(
        padding:
            EdgeInsets.only(top: Dim().d12, right: Dim().d8),
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Clr().clrec, width: 0.1))),
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
                            color: Clr().white,
                            fontSize: Dim().d16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    '₹ ${v['buying_price']}',
                    style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,
                        fontSize: Dim().d16),
                  )
                ],
              ),
              SizedBox(height: Dim().d12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Total P/L : ',
                            style: Sty().mediumText.copyWith(
                                color: Clr().clr67,
                                fontSize: Dim().d14,
                                fontWeight: FontWeight.w400)),
                        Text(
                            ' ₹ ${v['net_floating_p_l'].toString().contains('.') ? double.parse(v['net_floating_p_l'].toString()).toStringAsFixed(2) : v['net_floating_p_l']} ',
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
                                color: Clr().clr67,
                                fontSize: Dim().d14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Text(
                    'Qty: ${v['quantity']}',
                    //'Qty: ${v['quantity']}',
                    style: Sty().microText.copyWith(
                        color: Clr().clr67,
                        fontSize: Dim().d12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: Dim().d12),
            ],
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

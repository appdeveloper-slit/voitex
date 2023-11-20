import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/portfoilio.dart';
import 'package:voitex/values/colors.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'notification.dart';
import 'search_stocks.dart';
import 'stock_chart.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class WatchList extends StatefulWidget {
  final type;

  const WatchList({super.key, required this.type});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late BuildContext ctx;
  String? Token;
  List favstockList = [];
  bool? loading;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
          (value) {
        if (value) {
          favList(apiname: 'favourite_stock_list', type: 'get');
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

  late Stream stream = Stream.periodic(Duration(seconds: 5)).asyncMap(
          (event) async =>
      await favList(apiname: 'favourite_stock_list', type: 'get'));

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.type == 0
            ? STM().finishAffinity(ctx, Home())
            : STM().replacePage(ctx, Portfolio());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 2, stream),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 0
                  ? STM().finishAffinity(ctx, Home())
                  : STM().replacePage(ctx, Portfolio());
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dim().d16, top: Dim().d12, bottom: Dim().d12),
              child: SvgPicture.asset('assets/back.svg', height: Dim().d20),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Watchlist',
            style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontSize: Dim().d20,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx,
                            SearchStocks(
                              type: 'watch',
                            ));
                      },
                      child: SvgPicture.asset('assets/search.svg',
                          color: Clr().primaryColor)),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  // InkWell(
                  //     onTap: () {
                  //       STM().redirect2page(ctx, Notifications());
                  //     },
                  //     child: SvgPicture.asset('assets/bell.svg')),
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 6), () {
              favList(apiname: 'favourite_stock_list', type: 'get');
            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:
            favstockList.isEmpty
                ? check
                ? SizedBox(
              height: MediaQuery
                  .of(ctx)
                  .size
                  .height / 1.5,
              child: Center(
                child: Text(
                    "No Favourite Stocks,Please add some stocks!!!!",
                    textAlign: TextAlign.center,
                    style: Sty().mediumBoldText),
              ),
            )
                : Container()
                : StreamBuilder(
                stream: stream,
                builder: (context, AsyncSnapshot snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(top: Dim().d12),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: favstockList.length,
                      itemBuilder: (ctx, index) {
                        return marketLayout(ctx, favstockList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: Dim().d8,
                        );
                      },
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget marketLayout(ctx, v) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
            ctx,
            StockChart(
              details: v,
              type: 'watch',
            ));
      },
      child: Container(
        padding: EdgeInsets.all(Dim().d12),
        margin: EdgeInsets.symmetric(horizontal: Dim().d12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dim().d14)),
            border: Border.all(color: Clr().clrec, width: 1.0)
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${v['stock']['symbol']}', //'${v['stock']['symbol']}',
                        style: Sty().smallText.copyWith(
                            color: Clr().clr2c,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w600),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          v['stock']['net_change'].toString().contains('-')
                              ? Icon(Icons.arrow_downward_outlined,
                                  color: Clr().red)
                              : Icon(Icons.arrow_upward_outlined,
                                  color: Clr().green),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          Text(
                        '${v['stock']['last_price']}',
                            style: Sty().smallText.copyWith(
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w600,
                            color:  v['stock']['net_change']
                                      .toString()
                                      .contains('-')
                                  ? Clr().red
                                  : Clr().green
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dim().d4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${v['stock']['company_name']}',
                        style: Sty().microText.copyWith(
                            color: Clr().clr49,
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d12),
                      ),
                      Text(
                        '${v['stock']['net_change']} (${v['stock']['net_change_ercentage']})',
                        style: Sty().microText.copyWith(
                            color: Clr().clr49,
                            fontWeight: FontWeight.w400,
                            fontSize: Dim().d12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: Dim().d12),
            InkWell(
                onTap: () {
                  favList(
                      apiname: 'remove_favourite',
                      type: 'post',
                      value: v['stock']['id']);
                },
                child: SvgPicture.asset('assets/star.svg')),
          ],
        ),
      ),
    );
  }

  /// get fav List
  favList({apiname, type, value}) async {
    setState(() {
      loading = true;
    });
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'remove_favourite':
        data = FormData.fromMap({
          'stock_id': value,
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
      case "favourite_stock_list":
        if (success) {
          setState(() {
            loading = false;
            favstockList = result['data'];
            check = true;
          });
        } else {
          setState(() {
            loading = false;
          });
          STM().errorDialog(ctx, message);
        }
        break;
      case "remove_favourite":
        setState(() {
          loading = false;
          STM().displayToast(message, ToastGravity.CENTER);
          favList(apiname: 'favourite_stock_list', type: 'get');
        });
        break;
    }
  }
}

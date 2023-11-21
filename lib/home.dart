import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/localstore.dart';
import 'package:voitex/manage/static_method.dart';
import 'package:voitex/search_stocks.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/styles.dart';
import 'package:upgrader/upgrader.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'buy_stock.dart';
import 'notification.dart';
import 'stock_chart.dart';

bool? done;

class Home extends StatefulWidget {
  final b;

  const Home({super.key, this.b});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  String? Token;
  bool? profileLoading;
  dynamic profileList;
  bool? loading, ok;
  List isLike = [];
  List isdislike = [];
  List stockList = [];
  List topCompList = [];
  List indesList = [];
  bool ignore = false;
  bool later = false;
  var result;
  List<dynamic> loaclStockList = [];
  var niftyFifty, senSexValue;

  Future<void> _addItem(stockID, symbol, companyname) async {
    await Store.createItem(stockID, symbol, companyname);
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          setState(() {
            done = true;
          });
          apiType(apiname: 'get_profile', type: 'get');
          apiType(apiname: 'stock_list', type: 'post');
          // allStocks();
        }
      },
    );
    print(Token);
  }

  Future<void> pullDownRefresh() async {
    print("Refresh Started!");
    await Timer(const Duration(milliseconds: 100), () {
      setState(() {
        apiType(apiname: 'get_profile', type: 'get');
        apiType(apiname: 'stock_list', type: 'post');
      });
      print("Working refresh...");
    });
    print("Refresh Ended!");
  }

  Map updateType = {};
  late Stream stream = Stream.periodic(Duration(seconds: 5)).asyncMap(
      (event) async => await apiType(apiname: 'stock_list', type: 'post'));
  Upgrader _upgrader = Upgrader();

  // var channel = WebSocketChannel.connect(Uri.parse('https://spectrai.in/api/stock_list'));
  // streamStockListner() async {
  //   channel.stream.listen((event) {
  //     Map data = jsonDecode(event);
  //     print(data);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    // streamStockListner();
    _upgrader.initialize();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DoubleBack(
      message: 'Please press back once again!!',
      child: Scaffold(
          bottomNavigationBar: bottomBarLayout(ctx, 0, stream),
          body: SizedBox(
            height: MediaQuery.of(ctx).size.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [
                Color(0xff060D15),
                Color(0xff131F2E),
              ])),
              child: updateType.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(ctx).size.height / 1.3,
                      child: Center(
                        child:
                            CircularProgressIndicator(color: Clr().white),
                      ),
                    )
                  : UpgradeAlert(
                      upgrader: Upgrader(
                        canDismissDialog: false,
                        dialogStyle: UpgradeDialogStyle.material,
                        durationUntilAlertAgain: Duration(seconds: 2),
                        showReleaseNotes: true,
                        onUpdate: () {
                          updateType['update_type'] == false
                              ? Future.delayed(Duration(seconds: 1), () {
                                  SystemNavigator.pop();
                                })
                              : null;
                          return true;
                        },
                        showIgnore: updateType['update_type'],
                        showLater: updateType['update_type'],
                      ),
                      child: homeLayout()),
            ),
          )),
    );
  }

  Widget homeLayout() {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 6), () {
          setState(() {
            apiType(apiname: 'get_profile', type: 'get');
            apiType(apiname: 'stock_list', type: 'post');
          });
        });
      },
      color: Clr().white,
      backgroundColor: Clr().black,
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: Dim().d16, vertical: Dim().d56),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset('assets/homelogo.png', height: Dim().d40),
                    SizedBox(width: Dim().d12),
                    Text('Hi, ${profileList == null ? '' : profileList['name']}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontSize: Dim().d20,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                InkWell(
                    onTap: () {
                      STM().replacePage(ctx, SearchStocks(type: 'home'));
                    },
                    child: SvgPicture.asset('assets/search.svg')),
              ],
            ),
            SizedBox(height: Dim().d28),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white10, spreadRadius: 1, )
                  ],
                  color: Clr().black,
                  border: Border.all(color: Clr().white, width: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d12))),
              child: BlurryContainer(
                blur: 10,
                width: double.infinity,
                color: Clr().transparent,
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                child: Padding(
                  padding: EdgeInsets.all(Dim().d14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('${indesList[0]['symbol']}  :',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dim().d14)),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  indesList[0]['net_change']
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
                                    '${indesList[0]['last_price']}',
                                    style: Sty().mediumText.copyWith(
                                          fontSize: Dim().d16,
                                          color: indesList[0]['net_change']
                                                  .toString()
                                                  .contains('-')
                                              ? Clr().red
                                              : Clr().green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Text(
                                '${indesList[0]['net_change']}',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr67,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14),
                              ),
                              Text(
                                ' (${indesList[0]['net_change_ercentage']})',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr67,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14),
                              ),
                            ],
                          )
                        ],
                      ),
                      Divider(
                        color: Clr().clr67,
                        height: Dim().d20,
                        thickness: 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('${indesList[1]['symbol']}  :',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dim().d14)),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  indesList[1]['net_change']
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
                                    '${indesList[1]['last_price']}',
                                    style: Sty().mediumText.copyWith(
                                          fontSize: Dim().d16,
                                          color: indesList[1]['net_change']
                                                  .toString()
                                                  .contains('-')
                                              ? Clr().red
                                              : Clr().green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Text(
                                '${indesList[1]['net_change']}',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr67,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14),
                              ),
                              Text(
                                ' (${indesList[1]['net_change_ercentage']})',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().clr67,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Dim().d32),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white10, spreadRadius: 1, )
                  ],
                  color: Clr().black,
                  border: Border.all(color: Clr().white, width: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d12))),
              child: BlurryContainer(
                blur: 10,
                width: double.infinity,
                color: Clr().transparent,
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d8, horizontal: Dim().d12),
                      child: Text(
                        'Market Today',
                        style: Sty().largeText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                            fontSize: Dim().d20),
                      ),
                    ),
                    StreamBuilder(
                        stream: stream,
                        builder: (context, AsyncSnapshot snapshot) {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: stockList.length,
                            // itemCount: 3,//stockList.length,
                            itemBuilder: (ctx, index) {
                              return marketLayout(ctx, index,
                                  stockList[index]); //stockList[index]
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d8,
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dim().d28,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white10, spreadRadius: 1, )
                  ],
                  color: Clr().black,
                  border: Border.all(color: Clr().white, width: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d12))),
              child: BlurryContainer(
                blur: 10,
                width: double.infinity,
                color: Clr().transparent,
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d8, horizontal: Dim().d12),
                      child: Text(
                        'Top Companies',
                        style: Sty().largeText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: topCompList.length,
                      // itemCount: 3,
                      itemBuilder: (ctx, index) {
                        return marketLayout(ctx, index, topCompList[index]);
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
          ],
        ),
      ),
    );
  }

  Widget marketLayout(ctx, index, v) {
    return InkWell(
      onTap: () {
        // STM().redirect2page(context, BuyStock(details: '',));
        print(v);
        STM().finishAffinity(
            ctx,
            StockChart(
              details: v,
              type: 'home',
            ));
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Dim().d12, vertical: Dim().d8),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Clr().clr67, width: 0.2))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 'TITAN',
                          '${v['symbol']}',
                          style: Sty().smallText.copyWith(
                              color: Clr().white,
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Text(
                          // 'Titan Company Limited',
                          '${v['company_name']}',
                          style: Sty().microText.copyWith(
                              color: Clr().clr67,
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            v['net_change'].toString().contains('-')
                                ? Icon(Icons.arrow_downward_outlined,
                                    color: Clr().red, size: Dim().d16)
                                : Icon(Icons.arrow_upward_outlined,
                                    color: Clr().green, size: Dim().d16),
                            // Icon(Icons.arrow_downward_outlined,
                            //     color: Clr().red, size: Dim().d16),
                            SizedBox(
                              width: Dim().d8,
                            ),
                            // LiveDataBuilder(
                            //     builder: (BuildContext context, value) {
                            //       return Text(
                            //         '${v['last_price']}',
                            //         style: Sty().smallText.copyWith(
                            //             fontSize: Dim().d16,
                            //             fontWeight: FontWeight.w500,
                            //             color:
                            //                 v['net_change'].toString().contains('-')
                            //                     ? Clr().red
                            //                     : Clr().green),
                            //       );
                            //     },
                            //     data: ),
                            // xData(v['last_price']),
                            Text(
                              // '212.66',
                              '${v['last_price']}',
                              style: Sty().smallText.copyWith(
                                  fontSize: Dim().d14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      v['net_change'].toString().contains('-')
                                          ? Clr().red
                                          : Clr().green),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Text(
                          // '-1.26 (-0.59%)',
                          '${v['net_change']} (${v['net_change_ercentage']})',
                          style: Sty().microText.copyWith(
                              color: Clr().clr67,
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dim().d16),
                  isLike.map((e) => e.toString()).contains(v['id'].toString())
                      ? InkWell(
                          onTap: () {
                            apiType(
                                apiname: 'remove_favourite',
                                type: 'post',
                                value: v['id']);
                            if (isdislike.contains(v['id'])) {
                              setState(() {
                                isdislike.remove(v['id']);
                              });
                            } else {
                              setState(() {
                                isLike.remove(v['id']);
                                isdislike.add(v['id']);
                              });
                            }
                          },
                          child: SvgPicture.asset('assets/star.svg'))
                      : InkWell(
                          onTap: () {
                            apiType(
                                apiname: 'add_favourite',
                                type: 'post',
                                value: v['id']);
                            if (isLike.contains(v['id'])) {
                              setState(() {
                                isLike.remove(v['id']);
                              });
                            } else {
                              setState(() {
                                isdislike.remove(v['id']);
                                isLike.add(v['id']);
                              });
                            }
                          },
                          child: SvgPicture.asset('assets/watchlisticon.svg')),
                  // SvgPicture.asset('assets/watchlisticon.svg')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///getprofile
  apiType({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'stock_list':
        setState(() {
          loading = true;
        });
        data = FormData.fromMap({});
        break;
      case 'add_favourite':
        data = FormData.fromMap({
          'stock_id': value,
        });
        break;
      case 'remove_favourite':
        data = FormData.fromMap({
          'stock_id': value,
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
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'stock_list':
        if (result['success']) {
          setState(() {
            updateType = result['data'];
            stockList = result['data']['stock_list'];
            topCompList = result['data']['top_companies'];
            indesList = result['data']['index'];
            ignore = result['data']['update_type'];
            later = result['data']['update_type'];
            for (int a = 0; a < stockList.length; a++) {
              if (stockList[a]['is_like'] == true) {
                setState(() {
                  isLike.add(stockList[a]['id']);
                });
              } else {
                setState(() {
                  isdislike.add(stockList[a]['id']);
                });
              }
            }
            for (int a = 0; a < topCompList.length; a++) {
              if (topCompList[a]['is_like'] == true) {
                setState(() {
                  isLike.add(topCompList[a]['id']);
                });
              } else {
                setState(() {
                  isdislike.add(topCompList[a]['id']);
                });
              }
            }
            loading = false;
          });
        } else {
          STM().errorDialog(ctx, result['message']);
          setState(() {
            loading = false;
          });
        }
        break;
      case 'add_favourite':
        if (result['success']) {
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
      case 'remove_favourite':
        if (result['success']) {
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }

  _updater() {
    return Upgrader(
      showLater: true,
      showIgnore: false,
      showReleaseNotes: false,
    );
  }

// allStocks() async {
//   if (widget.b == true) {
//     var result = await STM().getWithoutDialog(ctx, 'all_stocks', Token);
//     setState(() {
//       loaclStockList = result['data'];
//     });
//     loaclStockList.map((e) {
//       Store.createItem(e['id'], e['symbol'], e['company_name']);
//     }).toList();
//     print(loaclStockList.length);
//   }
// }
}

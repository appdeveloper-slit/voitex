import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  late BuildContext ctx;
  String? Token;

  // dynamic data;
  Map<String, dynamic> data = {};

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getProfile(apiname: 'wallet_history');
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

  @override
  Widget build(BuildContext context) {
    ctx = context;

    TabController _controller = TabController(length: 2, vsync: this);
    return Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0, '', b: true),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().white,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Padding(
              padding: EdgeInsets.only(left: Dim().d16),
              child: SvgPicture.asset('assets/back.svg'),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Transaction History',
            style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: Dim().d20),
          ),
          bottom: PreferredSize(
              child: Center(
                child: Container(
                  height: Dim().d32,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Clr().lightGrey))),
                  child: TabBar(
                    labelStyle: Sty()
                        .mediumText
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    indicatorWeight: 1.2,
                    controller: _controller,
                    isScrollable: false,
                    // padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    labelColor: Clr().clr00,
                    indicatorColor: Clr().clr00,
                    automaticIndicatorColorAdjustment: true,
                    unselectedLabelColor: Clr().clr0130,
                    tabs: [
                      Tab(
                        text: 'Funds Added',
                      ),
                      Tab(
                        text: 'Funds Withdrawn',
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(Dim().d48)),
        ),
        body: data.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Clr().primaryColor,
                ),
              )
            : TabBarView(
                controller: _controller,
                children: [
                  data['funds_added'].isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(ctx).size.height / 1.3,
                          child: Center(
                            child:
                                Text('No funds added', style: Sty().mediumText),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: Dim().d12),
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: data['funds_added'].length,
                            itemBuilder: (ctx, index) {
                              return cardLayout(
                                  ctx, data['funds_added'][index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d12,
                              );
                            },
                          ),
                        ),
                  data['funds_withdrawn'].isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(ctx).size.height / 1.3,
                          child: Center(
                            child: Text('No funds withdrawn',
                                style: Sty().mediumText),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: Dim().d12),
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: data['funds_withdrawn'].length,
                            itemBuilder: (ctx, index) {
                              return cardLayout(
                                  ctx, data['funds_withdrawn'][index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d12,
                              );
                            },
                          ),
                        ),
                ],
              ));
  }

  Widget cardLayout(ctx, v) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Clr().clrec, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(Dim().d14))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // '06 july 2023 / 12:04 pm',
                  '${v['created_at'].toString()}',
                  style: Sty()
                      .microText
                      .copyWith(color: Color(0xFF494949), fontSize: 12),
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: v['status'] == 0
                        ? Color(0xFFFFFADF)
                        : v['status'] == 2
                            ? const Color(0xFFFFE6E2)
                            : const Color(0xFFE9FFE8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d8, vertical: Dim().d4),
                    child: Text(
                      '${v['status'] == 2 ? 'Failed' : v['status'] == 1 ? 'Success' : 'Pending'}',
                      style: Sty().microText.copyWith(
                          color: v['status'] == 0
                              ? Color(0xFFEFC602)
                              : v['status'] == 2
                                  ? const Color(0xFFFF4124)
                                  : const Color(0xFF35B431),
                          // color: Color(0xff6C6C6C),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Divider(
              color: Clr().clrec,
              thickness: 1.0,
              height: 15,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'HDFC Bank Limited',
                    //   style: Sty().smallText.copyWith(
                    //       color: Clr().textcolor, fontWeight: FontWeight.w600),
                    // ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      '#${v['transaction_id'].toString()}',
                      style: Sty().smallText.copyWith(
                          fontSize: 16,
                          color: Color(0xFF161616),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  '₹${v['amount']}',
                  style: Sty().smallText.copyWith(
                      fontSize: 16,
                      color: Clr().textcolor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getProfile({apiname, type, value}) async {
    var result = await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'wallet_history':
        if (result['success']) {
          setState(() {
            data = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}

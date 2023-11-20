import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/manage/static_method.dart';
import 'package:voitex/paymentpage.dart';
import 'package:voitex/sellpage2.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/strings.dart';
import 'package:voitex/values/styles.dart';

import 'bottom_navigation/bottom_navigation.dart';

class SellPage extends StatefulWidget {
  final dynamic details;

  const SellPage({super.key, this.details});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  late BuildContext ctx;
  dynamic data;
  String? Token;
  TextEditingController valueCtrl = TextEditingController();
  var prepayment;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
      prepayment = widget.details['pre_payment'];
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apitype();
        }
      },
    );
    print(Token);
  }

  late Stream stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await apitype());

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 1, stream),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          STM().redirect2page(ctx, SellPageFinal(details: widget.details));
        },
        child: Container(
          width: double.infinity,
          height: Dim().d48,
          margin: EdgeInsets.symmetric(horizontal: Dim().d12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dim().d16),
            color: Clr().red,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(Dim().d12),
              child: Text('Sell / Cancel',
                  style: Sty()
                      .mediumText
                      .copyWith(color: Clr().white)),
            ),
          ),
        ),
      ),
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
        leadingWidth: 40,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: Dim().d16, top: Dim().d12, bottom: Dim().d12),
            child: SvgPicture.asset('assets/back.svg', height: Dim().d20),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Stock Details',
          style: Sty()
              .mediumText
              .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: () {
              addFundlayout();
            },
            child: Padding(
              padding: EdgeInsets.all(
                14.0,
              ),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xFFE8F1FF),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF013076)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: Clr().clr0130, size: Dim().d16),
                        SizedBox(width: Dim().d8),
                        Text('Fund',
                            style: Sty().mediumText.copyWith(
                                color: Clr().clr0130,
                                fontWeight: FontWeight.w300,
                                fontSize: Dim().d14))
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  data == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${data['symbol']}',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().clr2c,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: Dim().d8),
                                SvgPicture.asset('assets/active.svg')
                              ],
                            ),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            Text(
                              '${data['company_name']}',
                              style: Sty().microText.copyWith(
                                  color: Clr().clr49,
                                  fontSize: Dim().d12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                  data == null
                      ? Container()
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  data['net_change'].toString().contains('-')
                                      ? Icon(Icons.arrow_downward_outlined,
                                          color: Clr().red, size: Dim().d16)
                                      : Icon(Icons.arrow_upward_outlined,
                                          size: Dim().d16, color: Clr().green),
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
                                    color: Clr().clr49,
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
              SizedBox(
                height: Dim().d8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Purchased Date/Time :',
                  style: Sty().microText.copyWith(
                      color: Clr().clr49,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              StreamBuilder(
                  stream: stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.details['buy_at']))}',
                          style: Sty().smallText.copyWith(
                                color: Color(0xFF2B2B2B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: Dim().d4),
                        Text(
                          ' ${DateFormat('h:mm a').format(DateTime.parse(widget.details['buy_at']))}',
                          style: Sty().smallText.copyWith(
                                color: Color(0xFF2B2B2B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    );
                  }),
              SizedBox(height: Dim().d20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                  border: Border.all(color: Clr().a4, width: 1.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dim().d12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: Dim().d12),
                        child: RichText(
                          text: TextSpan(
                              text: 'Buy Price : ',
                              style: Sty().smallText.copyWith(
                                  color: Clr().clr49,
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dim().d14),
                              children: [
                                widget.details['buying_price'] == null
                                    ? TextSpan()
                                    : TextSpan(
                                        text:
                                            '₹ ${widget.details['buying_price']}',
                                        //'${widget.details['net_floating_p_l']}',
                                        style: Sty().smallText.copyWith(
                                              color: Clr().clr2c,
                                              fontSize: Dim().d14,
                                              fontWeight: FontWeight.w600,
                                              // widget.details['net_floating_p_l']
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
                                    text: '${widget.details['quantity']}',
                                    //'${widget.details['quantity']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                    text: '${widget.details['leverage']}x',
                                    //'${widget.details['leverage']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                        '₹ ${widget.details['leverage_amount']}',
                                    //'${widget.details['net_floating_p_l']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                    text: widget.details['pre_payment'] == null
                                        ? '-'
                                        : '₹ ${widget.details['pre_payment']}',
                                    //'${widget.details['net_floating_p_l']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                  text: '₹ ${widget.details['market_capital']}',
                                  //'${widget.details['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // widget.details['net_floating_p_l']
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d8),
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
                              text: 'Floating P/L : ',
                              style: Sty().smallText.copyWith(
                                  color: Clr().clr49,
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dim().d14),
                              children: [
                                TextSpan(
                                    text:
                                        '₹ ${widget.details['floating_p_l']} (${widget.details['floating_p_l_percent']})%',
                                    //'${widget.details['net_floating_p_l']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                        '₹ ${widget.details['transaction_fee']}',
                                    //'${widget.details['net_floating_p_l']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                    text: '₹ ${widget.details['deffered_fee']}',
                                    //'${widget.details['net_floating_p_l']}',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().clr2c,
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w600,
                                          // widget.details['net_floating_p_l']
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
                                      '₹ ${widget.details['net_floating_p_l']} (${widget.details['net_floating_p_l_percent']})%',
                                  //'${widget.details['net_floating_p_l']}',
                                  style: Sty().smallText.copyWith(
                                        color: Clr().clr2c,
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w600,
                                        // widget.details['net_floating_p_l']
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
                                        widget.details['stop_loss_limit']
                                                .toString()
                                                .contains('-')
                                            ? '- ₹ ${widget.details['stop_loss_limit']} ${(widget.details['stop_loss_limit_percentage'])}%'
                                            : '₹ ${widget.details['stop_loss_limit']} (${widget.details['stop_loss_limit_percentage']}%)',
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
                                    Text(
                                        widget.details['profit_limit']
                                                .toString()
                                                .contains('-')
                                            ? '- ₹ ${widget.details['profit_limit']} ${(widget.details['profit_limit_percentage'])}%'
                                            : '₹ ${widget.details['profit_limit']} (${widget.details['profit_limit_percentage']}%)',
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
              SizedBox(height: Dim().d100),
            ],
          ),
        ),
      ),
    );
  }

  /// api type
  apitype() async {
    FormData body = FormData.fromMap({'stock_id': widget.details['stock_id']});
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// add preamount

  addPreAmount() async {
    FormData body = FormData.fromMap(
        {'stock_trade_id': widget.details['id'], 'amount': valueCtrl.text});
    var result = await STM()
        .postListWithoutDialog(ctx, 'additional_prepayment', Token, body);
    if (result['success'] == true) {
      try {
        setState(() {
          prepayment = int.parse(widget.details['pre_payment'].toString()) +
              int.parse(valueCtrl.text.toString());
        });
      } catch (_) {
        setState(() {
          prepayment = double.parse(widget.details['pre_payment'].toString()) +
              double.parse(valueCtrl.text.toString());
        });
      }
      STM().back2Previous(ctx);
      STM().displayToast(result['message'], ToastGravity.BOTTOM);
      valueCtrl.clear();
    } else {
      STM().errorDialog(ctx, result['message']);
    }
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
                    Text(
                      'Add more pre-payment amount to this order.',
                      style: Sty().smallText.copyWith(color: Clr().primaryColor,fontSize: Dim().d16,fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        TextFormField(
                          controller: valueCtrl,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Str().invalidEmpty;
                            } else {
                              return null;
                            }
                          },
                          decoration: Sty().textFieldOutlineStyle.copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: Dim().d12,
                                  horizontal: Dim().d12),
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
                            hintText: "Enter Amount",
                            counterText: "",
                            // prefixIcon: Icon(
                            //   Icons.call,
                            //   color: Clr().lightGrey,
                            // ),
                          ),
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
                    SizedBox(
                      width: double.infinity,
                      height: Dim().d48,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addPreAmount();
                              // STM().redirect2page(ctx, paymentPage(price: valueCtrl.text,));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor: Clr().primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dim().d12))),
                          child: Text(
                            'Proceed',
                            style: Sty().mediumText.copyWith(
                                  fontSize: 16,
                                  color: Clr().f5,
                                  fontWeight: FontWeight.w500,
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
}

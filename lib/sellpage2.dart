import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voitex/home.dart';
import 'package:voitex/manage/static_method.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/strings.dart';
import 'package:voitex/values/styles.dart';
import 'my_orders.dart';

class SellPageFinal extends StatefulWidget {
  final dynamic details;
  const SellPageFinal({super.key, this.details});

  @override
  State<SellPageFinal> createState() => _SellPageFinalState();
}

class _SellPageFinalState extends State<SellPageFinal> {
  late BuildContext ctx;
  dynamic data;
  String? Token;
  TextEditingController priceCtrl = TextEditingController();
  String markettypevalue = 'Market';
  List marketype = ['Market', 'Limit'];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
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
      backgroundColor: Clr().white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              dialogBackgroundColor: Clr().white,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Are you sure about selling/ cancelling this stock / order?',
                      textAlign: TextAlign.center,
                      style: Sty()
                          .mediumText
                          .copyWith(fontWeight: FontWeight.w400,color: Clr().primaryColor,fontSize: Dim().d16)),
                  SizedBox(height: Dim().d20),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Dim().d12),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                STM().back2Previous(ctx);
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Clr().transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                                    side: BorderSide(color: Clr().primaryColor)
                                  ),
                                  backgroundColor: Clr().white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Dim().d12),
                                child: Center(
                                  child: Text('No',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().primaryColor)),
                                ),
                              )),
                        ),
                        SizedBox(width: Dim().d12),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                sellStockapi();
                              },
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Clr().transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(Dim().d12)),
                                      side: BorderSide(color: Clr().primaryColor)
                                  ),
                                  backgroundColor: Clr().primaryColor),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Dim().d12),
                                child: Center(
                                  child: Text('Yes',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().white)),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dim().d12),
                ],
              )).show();
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
              child: Text('Sell',
                  style: Sty()
                      .mediumText
                      .copyWith(color: Clr().white)),
            ),
          ),
        ),
      ),
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
            padding: EdgeInsets.only(left: Dim().d12),
            child: SvgPicture.asset('assets/back.svg'),
          ),
        ),
        title: Text('Stock Sell',style: Sty().mediumText.copyWith(color: Clr().clr0130,fontWeight: FontWeight.w600,fontSize: Dim().d16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dim().d12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dim().d20),
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
            SizedBox(height: Dim().d4),
            Text('No. of shares', style: Sty().mediumText),
            SizedBox(height: Dim().d4),
            Text('${widget.details['quantity']}', style: Sty().mediumText),
            SizedBox(height: Dim().d20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                TextFormField(
                  controller: priceCtrl,
                  readOnly: markettypevalue == 'Market' ? true : false,
                  cursorColor: Clr().primaryColor,
                  style: Sty().mediumText,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
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
                    hintText: "Enter Price",
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
                      'Price',
                      style: TextStyle(
                          color: Clr().clr49,
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dim().d20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dim().d16),
                  border: Border.all(color: Clr().primaryColor)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    value: markettypevalue,
                    isDense: true,
                    hint: Text(
                      markettypevalue ?? 'Select Market',
                      // 'Select State',
                      style: TextStyle(
                        fontSize: 14,
                        color: markettypevalue != null
                            ? Clr().black
                            : Color(0xff787882),
                        // color: Color(0xff787882),
                        fontFamily: 'Inter',
                      ),
                    ),
                    isExpanded: true,
                    icon: SvgPicture.asset('assets/dropdown.svg',color: Clr().primaryColor),
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
                          style:
                          TextStyle(color: Clr().black, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        markettypevalue = v.toString();
                      });
                      if (markettypevalue == 'Market') {
                        setState(() {
                          priceCtrl = TextEditingController(
                              text: data['last_price']);
                        });
                      } else {
                        setState(() {
                          priceCtrl = TextEditingController(
                              text: data['last_price'].toString());
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
            SizedBox(height: Dim().d28),
          ],
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
        priceCtrl = TextEditingController(text: data['last_price'].toString());
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }


  sellStockapi() async {
    STM().back2Previous(ctx);
    FormData body = FormData.fromMap({
      'stock_trade_id': widget.details['id'],
      'selling_price': priceCtrl.text,
      'market_value': data['last_price'],
      'type': markettypevalue,
      'stock_id': widget.details['stock_id'],
      'quantity': widget.details['quantity']
    });
    var result = await STM().postWithToken(ctx, Str().processing,'sell_stock',body,Token);
    if (result['success'] == true) {
      STM().successDialogWithAffinity(ctx, result['message'], MyOrders(type: 0,));
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}

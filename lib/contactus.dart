import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:voitex/values/colors.dart';
import 'package:voitex/values/dimens.dart';
import 'package:voitex/values/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manage/static_method.dart';

class contactUs extends StatefulWidget {
  const contactUs({super.key});

  @override
  State<contactUs> createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF8F9F8),
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Icon(Icons.arrow_back, color: Clr().black),
          ),
        ),
        title: Text('Contact Us',
            style: Sty().mediumText.copyWith(color: Clr().black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            Image.asset('assets/contact_banner.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Contact Information',
              style: Sty()
                  .largeText
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
            ),
            SizedBox(
              height: 4,
            ),
            Text('Have any query contact us',
                style: Sty().microText.copyWith(
                      fontWeight: FontWeight.w400,
                    )),
            SizedBox(height: 20),
            SvgPicture.asset('assets/phone.svg'),
            SizedBox(
              height: 4,
            ),
            InkWell(
                onTap: () {
                  STM().openDialer('1800 203 1218');
                },
                child: Text('1800 203 1218')),
            SizedBox(height: 20),
            SvgPicture.asset('assets/mail.svg'),
            InkWell(
                onTap: () async {
                  await launch('mailto:support@storak.in');
                },
                child: Text('support@storak.in')),
            InkWell(
                onTap: () async {
                  await launch('mailto:grievance@storak.in');
                },
                child: Text('grievance@storak.in')),
            SizedBox(height: 20),
            // SvgPicture.asset('assets/mail.svg'),
            // InkWell(
            //     onTap: () async {
            //       await launch('mailto:grienvances@storak.in');
            //     },
            //     child: Text('grienvances@storak.in')),
            // SizedBox(height: 20),
            Icon(Icons.maps_home_work, color: Clr().lightGrey),
            InkWell(
              onTap: () {
                MapsLauncher.launchQuery(
                    'Vaishnava Tech Park, 3rd & 4th Floor Sarjapur Main Road, Bellandur Bengaluru – 560103');
              },
              child: Text(
                  'Vaishnava Tech Park, 3rd & 4th Floor Sarjapur Main Road, Bellandur Bengaluru – 560103',
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:voitex/values/dimens.dart';

class viewImage extends StatefulWidget {
  final img;

  const viewImage({super.key, this.img});

  @override
  State<viewImage> createState() => _viewImageState();
}

class _viewImageState extends State<viewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: widget.img.toString().contains('https')
                  ? Image.network(widget.img)
                  : Image.file(widget.img),
            ),
          ),
        ],
      ),
    );
  }
}

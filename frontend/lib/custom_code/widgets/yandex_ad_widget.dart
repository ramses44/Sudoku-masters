// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:yandex_mobileads/mobile_ads.dart';

class YandexAdWidget extends StatefulWidget {
  const YandexAdWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<YandexAdWidget> createState() => _YandexAdWidgetState();
}

class _YandexAdWidgetState extends State<YandexAdWidget> {
  @override
  void initState() {
    MobileAds.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AdWidget(
          bannerAd: BannerAd(
            adUnitId: 'R-M-8368877-1',
            // Flex-size
            //adSize: AdSize.flexible(
            //width: MediaQuery.of(context).size.width.toInt(), height: 50),
            // Sticky-size
            adSize:
                AdSize.sticky(width: MediaQuery.of(context).size.width.toInt()),
            adRequest: const AdRequest(),
            onAdLoaded: () {
              print("YANDEX INIT");
            },
            onAdFailedToLoad: (error) {
              print("YANDEX FAILED");
            },
          ),
        ));
  }
}

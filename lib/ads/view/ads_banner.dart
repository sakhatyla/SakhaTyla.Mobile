import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/ads/ads.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class AdsBanner extends StatelessWidget {
  final int width;
  final int maxHeight;
  const AdsBanner({
    super.key,
    required this.width,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AdsBloc>(context).add(LoadBanner());
    return BlocBuilder<AdsBloc, AdsState>(builder: (context, state) {
      final adUnitId = state.adUnitId;
      final bannerId = state.bannerId;
      if (adUnitId != null &&
          adUnitId.isNotEmpty &&
          bannerId != null &&
          bannerId > 0) {
        return AdWidget(
          key: Key("Banner$bannerId"),
          bannerAd: BannerAd(
            adUnitId: adUnitId,
            adSize: BannerAdSize.inline(
              width: width,
              maxHeight: maxHeight,
            ),
            adRequest: const AdRequest(),
            onAdLoaded: () {
              // The ad was loaded successfully. Now it will be shown.
            },
            onAdFailedToLoad: (error) {
              // Ad failed to load with AdRequestError.
              // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
            },
            onAdClicked: () {
              // Called when a click is recorded for an ad.
            },
            onLeftApplication: () {
              // Called when user is about to leave application (e.g., to go to the browser), as a result of clicking on the ad.
            },
            onReturnedToApplication: () {
              // Called when user returned to application after click.
            },
            onImpression: (impressionData) {
              // Called when an impression is recorded for an ad.
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

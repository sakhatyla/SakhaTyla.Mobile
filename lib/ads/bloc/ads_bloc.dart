import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/services/api/api.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final ApiClient apiClient;
  static const Duration _bannerDuration = Duration(minutes: 1);

  AdsBloc({
    required this.apiClient,
  }) : super(const AdsState()) {
    on<LoadBanner>((event, emit) async {
      var adUnitId = state.adUnitId;
      if (adUnitId == null) {
        var config = await apiClient
            .getMobileConfig('${Platform.operatingSystem}AdUnitId');
        adUnitId = config.value;
      }
      final bannerLoadedAt = state.bannerLoadedAt;
      if (bannerLoadedAt == null ||
          bannerLoadedAt.add(_bannerDuration).isBefore(DateTime.now())) {
        var bannerId = state.bannerId ?? 0;
        emit(AdsState(
          adUnitId: adUnitId,
          bannerId: bannerId + 1,
          bannerLoadedAt: DateTime.now(),
        ));
      }
    });
  }
}

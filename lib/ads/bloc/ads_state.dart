part of 'ads_bloc.dart';

class AdsState extends Equatable {
  final String? adUnitId;
  final int? bannerId;
  final DateTime? bannerLoadedAt;

  const AdsState({this.adUnitId, this.bannerId, this.bannerLoadedAt});

  @override
  List<Object?> get props => [adUnitId, bannerId, bannerLoadedAt];
}

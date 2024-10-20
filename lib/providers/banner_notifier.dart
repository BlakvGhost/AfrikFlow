import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/models/banner.dart' as home_banner;
import 'package:afrik_flow/services/common_api_service.dart';

class BannerNotifier extends StateNotifier<List<home_banner.Banner>> {
  BannerNotifier() : super([]);

  Future<void> fetchBanners() async {
    if (state.isEmpty) {
      final banners = await ApiService().fetchBanners();
      state = banners;
    }
  }
}

final bannerProvider =
    StateNotifierProvider<BannerNotifier, List<home_banner.Banner>>((ref) {
  return BannerNotifier();
});

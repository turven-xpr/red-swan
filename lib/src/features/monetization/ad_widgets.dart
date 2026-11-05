import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_service.dart';

/// Thin banner ad strip embedded above the bottom nav.  We use an
/// adaptive AdSize so the visual footprint matches the device width.
class AdsStrip extends ConsumerStatefulWidget {
  const AdsStrip({super.key});

  @override
  ConsumerState<AdsStrip> createState() => _AdsStripState();
}

class _AdsStripState extends ConsumerState<AdsStrip> {
  BannerAd? _banner;
  double? _height;
  double? _width;

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb || _loaded) return; // Skip AdMob entirely on web
    _loaded = true;
    final width = MediaQuery.sizeOf(context).width;
    final orientation = MediaQuery.orientationOf(context);
    final svc = ref.read(adServiceProvider);
    svc
        .buildAdaptiveBanner(
      orientation: orientation,
      fixWidth: width > 0 ? width : 320,
    )
        .then((ad) {
      if (!mounted) return;
      setState(() {
        _banner = ad;
        _height = ad.size.height.toDouble();
        _width = ad.size.width.toDouble();
      });
    }).catchError((_) {
      if (!mounted) return;
      setState(() {
        _banner = null;
        _height = 0;
        _width = 0;
      });
    });
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (banner == null || _height == null || _width == null ||
        _height! <= 0 || _width! <= 0) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _height,
      width: _width,
      child: AdWidget(ad: banner),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Centraliza a inicialização do AdMob (com IDs de TESTE), o consentimento
/// via UMP e o carregamento/exibição de intersticial e recompensado.
///
/// Trocar os IDs de teste abaixo pelos IDs reais é uma tarefa da Fase 6/7
/// (publicação), nunca antes disso.
class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  static const int gameOversPerInterstitial = 3;

  String get bannerAdUnitId => defaultTargetPlatform == TargetPlatform.iOS
      ? 'ca-app-pub-3940256099942544/2934735716'
      : 'ca-app-pub-3940256099942544/6300978111';

  String get interstitialAdUnitId => defaultTargetPlatform == TargetPlatform.iOS
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-3940256099942544/1033173712';

  String get rewardedAdUnitId => defaultTargetPlatform == TargetPlatform.iOS
      ? 'ca-app-pub-3940256099942544/1712485313'
      : 'ca-app-pub-3940256099942544/5224354917';

  int _gameOverCount = 0;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  /// Solicita o consentimento de anúncios (UMP) e, em seguida, inicializa
  /// o Google Mobile Ads SDK. Deve ser chamado uma vez, antes de exibir
  /// qualquer anúncio.
  Future<void> initialize() async {
    final consentResolved = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await ConsentForm.loadAndShowConsentFormIfRequired((formError) {});
        }
        if (!consentResolved.isCompleted) consentResolved.complete();
      },
      (formError) {
        // Falha ao obter consentimento: segue sem bloquear o app.
        if (!consentResolved.isCompleted) consentResolved.complete();
      },
    );

    // Aguarda o resultado do UMP antes de inicializar o SDK de anúncios,
    // já que o consentimento deve ser resolvido primeiro.
    await consentResolved.future;

    await MobileAds.instance.initialize();
    _preloadInterstitial();
    _preloadRewarded();
  }

  void _preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _preloadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  /// Deve ser chamado a cada game over. Exibe um intersticial a cada
  /// [gameOversPerInterstitial] partidas, nunca durante o gameplay ativo.
  Future<void> maybeShowInterstitialOnGameOver() async {
    _gameOverCount++;
    if (_gameOverCount % gameOversPerInterstitial != 0) return;

    final ad = _interstitialAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _preloadInterstitial();
      },
    );
    _interstitialAd = null;
    await ad.show();
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  /// Exibe o anúncio recompensado (ex.: "continuar" após morrer). Invoca
  /// [onReward] apenas se o usuário assistir ao anúncio até o fim.
  Future<void> showRewardedAd({required VoidCallback onReward}) async {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _preloadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _preloadRewarded();
      },
    );
    _rewardedAd = null;
    await ad.show(onUserEarnedReward: (ad, reward) => onReward());
  }
}

import 'package:flutter/services.dart';

class AATKitBinding {
  static const channel = MethodChannel("com.addapttr.aatkit/flutter_binding");
  static const initMethodName = "init";

  static const createBannerCacheMethodName = "createBannerCache";
  static const destroyBannerCacheMethodName = "destroyBannerCache";

  static const createFullscreenPlacementMethodName =
      "createFullscreenPlacement";
  static const startAutoReloadFullscreenPlacementMethodName =
      "startAutoReloadFullscreenPlacement";
  static const stopAutoReloadFullscreenPlacementMethodName =
      "stopAutoReloadFullscreenPlacement";
  static const showFullscreenPlacementMethodName = "showFullscreenPlacement";

  static const createRewardedPlacementMethodName = "createRewardedPlacement";
  static const startAutoReloadRewardedPlacementMethodName =
      "startAutoReloadRewardedPlacement";
  static const stopAutoReloadRewardedPlacementMethodName =
      "stopAutoReloadRewardedPlacement";
  static const showRewardedPlacementMethodName = "showRewardedPlacement";

  static const createAppOpenAdPlacementMethodName = "createAppOpenAdPlacement";
  static const startAutoReloadAppOpenAdPlacementMethodName =
      "startAutoReloadAppOpenAdPlacement";
  static const stopAutoReloadAppOpenAdPlacementMethodName =
      "stopAutoReloadAppOpenAdPlacement";
  static const showAppOpenAdPlacementMethodName = "showAppOpenAdPlacement";

  static const showConsentIfNeededMethodName = "showConsentIfNeeded";
  static const editConsentMethodName = "editConsent";
  static const reloadConsentMethodName = "reloadConsent";
  static const isConsentOptInMethodName = "isConsentOptIn";

  ///Notifies that placement has finished loading an ad successfully.
  Function(String)? onHaveAd;

  ///Notifies that placement has failed to load an ad.
  Function(String)? onNoAd;

  ///Notifies that ad went fullscreen and that application should pause.
  Function(String)? onPauseForAd;

  ///Notifies that ad came back from fullscreen and that application should resume.
  Function(String)? onResumeAfterAd;

  //Notifies that placement has earned incentive (by rewarded ads).
  Function(AATKitReward)? onUserEarnedIncentive;

  //Notifies that the used CMP failed to load.
  Function(String)? managedConsentCMPFailedToLoad;

  //Notifies that the used CMP failed to show.
  Function(String)? managedConsentCMPFailedToShow;

  //Notifies that Managed Consent needs to show a consent dialog.
  Function()? managedConsentNeedsUserInterface;

  //Notifies that the used CMP has finished updating consent.
  Function(AATKitConsentState)? managedConsentCMPFinished;

  //Notifies that the first banner gets loaded for the cache. Only called once.
  Function()? firstBannerLoaded;

  /// Initializes the AATKit library. Should be called once during application
  /// initialization before any other calls to AATKit.
  Future<void> initAATKit() async {
    channel.setMethodCallHandler(_onChannelCallback);
    try {
      await channel.invokeMethod(initMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  Future<dynamic> _onChannelCallback(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "onHaveAd":
        if (onHaveAd != null) {
          onHaveAd!(methodCall.arguments);
        }
        break;
      case "onNoAd":
        if (onNoAd != null) {
          onNoAd!(methodCall.arguments);
        }
        break;
      case "onPauseForAd":
        if (onPauseForAd != null) {
          onPauseForAd!(methodCall.arguments);
        }
        break;
      case "onResumeAfterAd":
        if (onResumeAfterAd != null) {
          onResumeAfterAd!(methodCall.arguments);
        }
        break;
      case "onUserEarnedIncentive":
        if (onUserEarnedIncentive != null) {
          final reward = _createReward(methodCall.arguments);
          onUserEarnedIncentive!(reward);
        }
        break;
      case "managedConsentCMPFailedToLoad":
        if (managedConsentCMPFailedToLoad != null) {
          managedConsentCMPFailedToLoad!(methodCall.arguments);
        }
        break;
      case "managedConsentCMPFailedToShow":
        if (managedConsentCMPFailedToShow != null) {
          managedConsentCMPFailedToShow!(methodCall.arguments);
        }
        break;
      case "managedConsentCMPFinished":
        if (managedConsentCMPFinished != null) {
          AATKitConsentState consentState =
              _createConsentState(methodCall.arguments);
          managedConsentCMPFinished!(consentState);
        }
        break;
      case "managedConsentNeedsUserInterface":
        if (managedConsentNeedsUserInterface != null) {
          managedConsentNeedsUserInterface!();
        }
        break;
      case "firstBannerLoaded":
        if (firstBannerLoaded != null) {
          firstBannerLoaded!();
        }
        break;
    }
  }

  AATKitReward _createReward(dynamic arguments) {
    if (arguments is! Map) {
      return AATKitReward(placementName: "", rewardName: "", rewardValue: "");
    }

    final rewardMap = Map.castFrom(arguments);
    final reward = AATKitReward(
      placementName: rewardMap["placementName"],
      rewardName: rewardMap["rewardName"],
      rewardValue: rewardMap["rewardValue"],
    );
    return reward;
  }

  AATKitConsentState _createConsentState(String rawState) {
    switch (rawState) {
      case "WITHHELD":
        return AATKitConsentState.withheld;
      case "CUSTOM":
        return AATKitConsentState.custom;
      case "OBTAINED":
        return AATKitConsentState.obtained;
      default:
        return AATKitConsentState.unknown;
    }
  }

  ///Creates fullscreen placement.
  Future<void> createFullscreenPlacement() async {
    try {
      await channel.invokeMethod(createFullscreenPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Enables automatic reloading of fullscreen placement. Autoreloader will use
  ///reload time configured on addapptr.com account or fallback to default 30 seconds.
  Future<void> startFullscreenAutoReload() async {
    try {
      await channel.invokeMethod(startAutoReloadFullscreenPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Disables automatic reloading of fullscreen placement.
  Future<void> stopFullscreenAutoReload() async {
    try {
      await channel.invokeMethod(stopAutoReloadFullscreenPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Shows fullscreen if ad is ready.
  Future<void> showFullscreen() async {
    try {
      await channel.invokeMethod(showFullscreenPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  /// Creates rewarded ad placement.
  Future<void> createRewardedPlacement() async {
    try {
      await channel.invokeMethod(createRewardedPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Enables automatic reloading of rewarded ad placement. Autoreloader will use
  ///reload time configured on addapptr.com account or fallback to default 30 seconds.
  Future<void> startRewardedAutoReload() async {
    try {
      await channel.invokeMethod(startAutoReloadRewardedPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Disables automatic reloading of rewarded ad placement.
  Future<void> stopRewardedAutoReload() async {
    try {
      await channel.invokeMethod(stopAutoReloadRewardedPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Shows rewarded ad if it's ready.
  Future<void> showRewarded() async {
    try {
      await channel.invokeMethod(showRewardedPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Creates app open ad placement.
  Future<void> createAppOpenAdPlacement() async {
    try {
      await channel.invokeMethod(createAppOpenAdPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Enables automatic reloading of app open ad placement. Autoreloader will use
  ///reload time configured on addapptr.com account or fallback to default 30 seconds.
  Future<void> startAppOpenAdAutoReload() async {
    try {
      await channel.invokeMethod(startAutoReloadAppOpenAdPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Disables automatic reloading of app open ad placement.
  Future<void> stopAppOpenAdAutoReload() async {
    try {
      await channel.invokeMethod(stopAutoReloadAppOpenAdPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Shows app open ad if it's ready.
  Future<void> showAppOpenAd() async {
    try {
      await channel.invokeMethod(showAppOpenAdPlacementMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Creates app open ad placement.
  Future<void> createBannerCache() async {
    try {
      await channel.invokeMethod(createBannerCacheMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  Future<void> destroyBannerCache() async {
    try {
      await channel.invokeMethod(destroyBannerCacheMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Presents the consent screen only if it is required by the used CMP
  ///(for example if no user consent has been set yet).
  Future<void> showConsentIfNeeded() async {
    try {
      await channel.invokeMethod(showConsentIfNeededMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Presents the consent screen, allowing the user to change consent settings.
  Future<void> editConsent() async {
    try {
      await channel.invokeMethod(editConsentMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Tells the CMP to reload. Does not need to be used unless some error occurs.
  Future<void> reloadConsent() async {
    try {
      await channel.invokeMethod(reloadConsentMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
    }
  }

  ///Returns "consent opt-in status" returned by our server rules.
  ///Only returns meaningful information after the rules are downloaded.
  Future<bool> isConsentOptIn() async {
    try {
      return await channel.invokeMethod(isConsentOptInMethodName);
    } on PlatformException catch (e) {
      print("PlatformException, error: $e");
      return false;
    }
  }
}

class AATKitReward {
  final String placementName;
  final String rewardName;
  final String rewardValue;

  AATKitReward({
    required this.placementName,
    required this.rewardName,
    required this.rewardValue,
  });
}

///Possible states of consent given by the user.
enum AATKitConsentState {
  ///No information about the consent state.
  unknown,

  ///Consent has been declined by the user.
  withheld,

  ///Partial consent has been granted by the user - at least some purposes
  ///and some vendors were given consent.
  custom,

  ///Full consent has been granted by the user.
  obtained
}

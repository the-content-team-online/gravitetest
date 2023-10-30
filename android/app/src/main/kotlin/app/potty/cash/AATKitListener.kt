package com.addapttr.flutter_binding

import com.intentsoftware.addapptr.*
import io.flutter.plugin.common.MethodChannel

class AATKitListener(private val methodChannel: MethodChannel) : StickyBannerPlacementListener,
    FullscreenPlacementListener, RewardedVideoPlacementListener, AppOpenPlacementListener {
    override fun onHaveAd(placement: Placement) {
        methodChannel.invokeMethod("onHaveAd", placement.name)
    }

    override fun onNoAd(placement: Placement) {
        methodChannel.invokeMethod("onNoAd", placement.name)
    }

    override fun onPauseForAd(placement: Placement) {
        methodChannel.invokeMethod("onPauseForAd", placement.name)
    }

    override fun onResumeAfterAd(placement: Placement) {
        methodChannel.invokeMethod("onResumeAfterAd", placement.name)
    }

    override fun onUserEarnedIncentive(placement: Placement, aatKitReward: AATKitReward?) {
        val reward = mapOf(
            "placementName" to placement.name,
            "rewardName" to (aatKitReward?.name ?: ""),
            "rewardValue" to (aatKitReward?.value ?: "")
        )
        methodChannel.invokeMethod("onUserEarnedIncentive", reward)
    }
}
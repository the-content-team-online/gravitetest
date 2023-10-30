package com.addapttr.flutter_binding

import com.intentsoftware.addapptr.BannerCache
import io.flutter.plugin.common.MethodChannel

class AATKitBannerCacheListener(private val methodChannel: MethodChannel) :
    BannerCache.CacheDelegate {
    override fun firstBannerLoaded() {
        methodChannel.invokeMethod("firstBannerLoaded", null)
    }
}
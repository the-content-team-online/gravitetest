package app.potty.cash

import android.content.Context
import android.view.View
import com.intentsoftware.addapptr.AATKit
import com.intentsoftware.addapptr.BannerPlacementSize
import com.intentsoftware.addapptr.StickyBannerPlacement
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

internal class NativeBannerView(val context: Context, methodChannel: MethodChannel) : PlatformView {
    //Change banner placement name if needed
    private val placementName = "BannerPlacement"

    //Change banner placement size if needed
    private val placementSize = BannerPlacementSize.Banner320x53

    private var stickyBannerPlacement: StickyBannerPlacement? = null

    init {
        stickyBannerPlacement = AATKit.createStickyBannerPlacement(placementName, placementSize)
        stickyBannerPlacement?.startAutoReload()
        stickyBannerPlacement?.listener = AATKitListener(methodChannel)
    }

    override fun getView(): View {
        return stickyBannerPlacement?.getPlacementView() ?: View(context)
    }

    override fun dispose() {
        stickyBannerPlacement?.stopAutoReload()
    }
}
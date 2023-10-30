package com.addapttr.flutter_binding

import android.content.Context
import android.view.View
import android.view.ViewTreeObserver
import android.widget.FrameLayout
import androidx.core.view.size
import com.intentsoftware.addapptr.BannerPlacementLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

internal class NativeCachedBannerView(
    private val context: Context,
    binaryMessenger: BinaryMessenger,
    id: String
) : PlatformView {
    companion object {
        const val methodChannelName = "net.gravite.aatkit/cached-banner";
        const val sizeMethodName = "onSizeChanged";
    }

    private var bannerView: BannerPlacementLayout? = null

    private var parentView: FrameLayout? = null

    private val methodChannel: MethodChannel =
        MethodChannel(binaryMessenger, "$methodChannelName-$id");

    override fun getView(): View? {
        if (parentView != null) {
            return parentView;
        }
        bannerView = AATKitBinding.bannerCache?.consume()
        updateBannerSize()
        createParentView()
        return parentView ?: View(context)
    }

    private fun updateBannerSize() {
        val bannerView = bannerView ?: return
        bannerView.viewTreeObserver?.addOnGlobalLayoutListener(object :
            ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                val displayMetrics = context.resources.displayMetrics
                val density = displayMetrics.density
                bannerView.viewTreeObserver.removeOnGlobalLayoutListener(this)
                methodChannel.invokeMethod(
                    sizeMethodName,
                    listOf(bannerView.width / density, bannerView.height / density)
                )
            }
        })
    }

    private fun createParentView() {
        if(bannerView == null) {
            return
        }
        parentView = FrameLayout(context)
        val layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        )
        parentView?.layoutParams = layoutParams
        parentView?.addView(bannerView)
    }

    override fun dispose() {
        bannerView?.destroy()
    }
}
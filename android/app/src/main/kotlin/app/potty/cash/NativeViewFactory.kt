package app.potty.cash

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(
    private val methodChannel: MethodChannel,
    private val binaryMessenger: BinaryMessenger
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        if (args is java.util.ArrayList<*>) {
            return NativeCachedBannerView(context, binaryMessenger, args[1] as String)
        }

        return NativeBannerView(context, methodChannel)
    }
}
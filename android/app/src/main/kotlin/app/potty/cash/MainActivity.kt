package com.addapttr.flutter_binding

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        const val BANNER_VIEW_TYPE = "<aatkit-banner-view>"
    }

    var aatKitBinding: AATKitBinding? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //Add code below to your configureFlutterEngine to allow calling AATKitBinding methods from
        //dart code.
        aatKitBinding = AATKitBinding(application, this)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        val methodChannel = MethodChannel(
            binaryMessenger,
            AATKitBinding.AATKIT_CHANNEL
        )
        aatKitBinding?.handleMethodChannelCalls(methodChannel)

        //Add code below to your configureFlutterEngine to allow creating banner widget
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                BANNER_VIEW_TYPE,
                NativeViewFactory(methodChannel, binaryMessenger)
            )
    }

    override fun onResume() {
        super.onResume()
        aatKitBinding?.onActivityResume()
    }

    override fun onPause() {
        super.onPause()
        aatKitBinding?.onActivityPause()
    }
}

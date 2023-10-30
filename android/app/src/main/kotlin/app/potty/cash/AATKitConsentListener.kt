package app.potty.cash

import com.intentsoftware.addapptr.ManagedConsent
import io.flutter.plugin.common.MethodChannel

class AATKitConsentListener(private val methodChannel: MethodChannel) : ManagedConsent.ManagedConsentDelegate {
    override fun managedConsentCMPFailedToLoad(managedConsent: ManagedConsent, error: String?) {
        methodChannel.invokeMethod("managedConsentCMPFailedToLoad", error)
    }

    override fun managedConsentCMPFailedToShow(managedConsent: ManagedConsent, error: String?) {
        methodChannel.invokeMethod("managedConsentCMPFailedToShow", error)
    }

    override fun managedConsentCMPFinished(state: ManagedConsent.ManagedConsentState) {
        methodChannel.invokeMethod("managedConsentCMPFinished", state.toString())
    }

    override fun managedConsentNeedsUserInterface(managedConsent: ManagedConsent) {
        methodChannel.invokeMethod("managedConsentNeedsUserInterface", null)
    }
}
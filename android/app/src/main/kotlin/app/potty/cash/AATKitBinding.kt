package app.potty.cash

import android.app.Activity
import android.app.Application
import com.intentsoftware.addapptr.*
import com.intentsoftware.addapptr.consent.CMP
import com.intentsoftware.addapptr.consent.CMPGoogle
import com.intentsoftware.addapptr.consent.CMPOgury
import com.intentsoftware.addapptr.consent.CMPSourcePoint
import io.flutter.plugin.common.MethodChannel

class AATKitBinding(val application: Application, val activity: Activity) {
    companion object {
        const val AATKIT_CHANNEL = "com.addapttr.aatkit/flutter_binding"

        var bannerCache: BannerCache? = null

        private const val INIT_METHOD_NAME = "init"
        private const val CREATE_BANNER_CACHE = "createBannerCache"
        private const val DESTROY_BANNER_CACHE = "destroyBannerCache"
        private const val CREATE_FULLSCREEN_PLACEMENT = "createFullscreenPlacement"
        private const val START_AUTO_RELOAD_FULLSCREEN_PLACEMENT =
            "startAutoReloadFullscreenPlacement"
        private const val STOP_AUTO_RELOAD_FULLSCREEN_PLACEMENT =
            "stopAutoReloadFullscreenPlacement"
        private const val SHOW_FULLSCREEN_PLACEMENT = "showFullscreenPlacement"
        private const val CREATE_REWARDED_PLACEMENT = "createRewardedPlacement"
        private const val START_AUTO_RELOAD_REWARDED_PLACEMENT = "startAutoReloadRewardedPlacement"
        private const val STOP_AUTO_RELOAD_REWARDED_PLACEMENT = "stopAutoReloadRewardedPlacement"
        private const val SHOW_REWARDED_PLACEMENT = "showRewardedPlacement"
        private const val CREATE_APP_OPEN_AD_PLACEMENT = "createAppOpenAdPlacement"
        private const val START_AUTO_RELOAD_APP_OPEN_AD_PLACEMENT =
            "startAutoReloadAppOpenAdPlacement"
        private const val STOP_AUTO_RELOAD_APP_OPEN_AD_PLACEMENT =
            "stopAutoReloadAppOpenAdPlacement"
        private const val SHOW_APP_OPEN_AD_PLACEMENT = "showAppOpenAdPlacement"
        private const val SHOW_CONSENT_IF_NEEDED = "showConsentIfNeeded"
        private const val EDIT_CONSENT = "editConsent"
        private const val RELOAD_CONSENT = "reloadConsent"
        private const val IS_CONSENT_OPT_IN = "isConsentOptIn"
    }

    private lateinit var listener: AATKitListener
    private lateinit var consentListener: AATKitConsentListener
    private lateinit var bannerCacheListener: AATKitBannerCacheListener
    private var consent: ManagedConsent? = null

    //Change banner cache configuration if needed
    private val bannerCachePlacementName = "bannerCachePlacement"
    private val bannerCacheSize = 2

    //Change placement name if needed
    private val fullscreenPlacementName = "fullscreenPlacement"
    private var fullscreenPlacement: FullscreenPlacement? = null

    //Change placement name if needed
    private val rewardedPlacementName = "rewardedPlacement"
    private var rewardedPlacement: RewardedVideoPlacement? = null

    //Change placement name is needed
    private val appOpenAdPlacementName = "appOpenAdPlacement"
    private var appOpenAdPlacement: AppOpenAdPlacement? = null

    private var initialized = false

    fun handleMethodChannelCalls(methodChannel: MethodChannel) {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                INIT_METHOD_NAME -> result.success(initAATKit())
                CREATE_BANNER_CACHE -> result.success(createBannerCache())
                DESTROY_BANNER_CACHE -> result.success(destroyBannerCache())
                CREATE_FULLSCREEN_PLACEMENT -> result.success(createFullscreenPlacement())
                START_AUTO_RELOAD_FULLSCREEN_PLACEMENT -> result.success(startAutoReloadFullscreenPlacement())
                STOP_AUTO_RELOAD_FULLSCREEN_PLACEMENT -> result.success(stopAutoReloadFullscreenPlacement())
                SHOW_FULLSCREEN_PLACEMENT -> result.success(showFullscreenPlacement())
                CREATE_REWARDED_PLACEMENT -> result.success(createRewardedPlacement())
                START_AUTO_RELOAD_REWARDED_PLACEMENT -> result.success(startAutoReloadRewardedPlacement())
                STOP_AUTO_RELOAD_REWARDED_PLACEMENT -> result.success(stopAutoReloadRewardedPlacement())
                SHOW_REWARDED_PLACEMENT -> result.success(showRewardedPlacement())
                CREATE_APP_OPEN_AD_PLACEMENT -> result.success(createAppOpenAdPlacement())
                START_AUTO_RELOAD_APP_OPEN_AD_PLACEMENT -> result.success(startAutoReloadAppOpenAdPlacement())
                STOP_AUTO_RELOAD_APP_OPEN_AD_PLACEMENT -> result.success(stopAutoReloadAppOpenAdPlacement())
                SHOW_APP_OPEN_AD_PLACEMENT -> result.success(showAppOpenAdPlacement())
                SHOW_CONSENT_IF_NEEDED -> result.success(showConsentIfNeeded())
                EDIT_CONSENT -> result.success(editConsent())
                RELOAD_CONSENT -> result.success(reloadConsent())
                IS_CONSENT_OPT_IN -> result.success(isConsentOptIn())
            }
        }
        listener = AATKitListener(methodChannel)
        consentListener = AATKitConsentListener(methodChannel)
        bannerCacheListener = AATKitBannerCacheListener(methodChannel)
    }

    fun onActivityResume() {
        if (initialized) {
            AATKit.onActivityResume(activity)
        }
    }

    fun onActivityPause() {
        if (initialized) {
            AATKit.onActivityPause(activity)
        }
    }

    // Adjust AATKit configuration to your needs
    private fun initAATKit(): Any? {
        val configuration = AATKitConfiguration(application)

        // configuration.setTestModeAccountId(74);

        //Comment out the bellow line if Google CMP is needed
        // configureGoogleCMP(configuration)

        //Comment out the bellow line if Ogury CMP is needed
        //configureOguryCMP(configuration, "your-asset-key")

        //Comment out the bellow line if Source Point CMP is needed
        //configureSourcePointCMP(configuration,<your-sccount-id>, <your-property-id>, "your-property-name", "your-pm-id")

        AATKit.init(configuration)

        initialized = true
        onActivityResume()
        return null
    }

    private fun configureGoogleCMP(configuration: AATKitConfiguration) {
        val cmp = CMPGoogle(activity)
        configureCMP(cmp, configuration)
    }

    private fun configureOguryCMP(configuration: AATKitConfiguration, assetKey: String) {
        val cmp = CMPOgury(application, assetKey)
        configureCMP(cmp, configuration)
    }

    private fun configureSourcePointCMP(
        configuration: AATKitConfiguration,
        accountId: Int,
        propertyId: Int,
        propertyName: String,
        pmId: String
    ) {
        val cmp = CMPSourcePoint(activity, accountId, propertyId, propertyName, pmId)
        configureCMP(cmp, configuration)
    }

    private fun configureCMP(cmp: CMP, configuration: AATKitConfiguration) {
        val context = application.applicationContext
        consent = ManagedConsent(cmp, context, consentListener)
        configuration.consent = consent
    }

    private fun createBannerCache(): Any? {
        //Set more parameters of BannerCacheConfiguration if needed
        val configuration = BannerCacheConfiguration(bannerCachePlacementName, bannerCacheSize)
        configuration.delegate = bannerCacheListener
        bannerCache = AATKit.createBannerCache(configuration)
        return null
    }

    private fun destroyBannerCache(): Any? {
        bannerCache?.destroy()
        bannerCache = null
        return null
    }

    private fun createFullscreenPlacement(): Any? {
        fullscreenPlacement = AATKit.createFullscreenPlacement(fullscreenPlacementName)
        fullscreenPlacement?.listener = listener
        return null
    }

    private fun startAutoReloadFullscreenPlacement(): Any? {
        fullscreenPlacement?.startAutoReload()
        return null
    }

    private fun stopAutoReloadFullscreenPlacement(): Any? {
        fullscreenPlacement?.stopAutoReload()
        return null
    }

    private fun showFullscreenPlacement(): Any? {
        fullscreenPlacement?.show()
        return null
    }

    private fun createRewardedPlacement(): Any? {
        rewardedPlacement = AATKit.createRewardedVideoPlacement(rewardedPlacementName)
        rewardedPlacement?.listener = listener
        return null
    }

    private fun startAutoReloadRewardedPlacement(): Any? {
        rewardedPlacement?.startAutoReload()
        return null
    }

    private fun stopAutoReloadRewardedPlacement(): Any? {
        rewardedPlacement?.stopAutoReload()
        return null
    }

    private fun showRewardedPlacement(): Any? {
        rewardedPlacement?.show()
        return null
    }

    private fun createAppOpenAdPlacement(): Any? {
        appOpenAdPlacement = AATKit.createAppOpenAdPlacement(appOpenAdPlacementName)
        appOpenAdPlacement?.listener = listener
        return null
    }

    private fun startAutoReloadAppOpenAdPlacement(): Any? {
        appOpenAdPlacement?.startAutoReload()
        return null
    }

    private fun stopAutoReloadAppOpenAdPlacement(): Any? {
        appOpenAdPlacement?.stopAutoReload()
        return null
    }

    private fun showAppOpenAdPlacement(): Any? {
        appOpenAdPlacement?.show()
        return null
    }

    private fun showConsentIfNeeded(): Any? {
        consent?.showIfNeeded(activity)
        return null
    }

    private fun editConsent(): Any? {
        consent?.editConsent(activity)
        return null
    }

    private fun reloadConsent(): Any? {
        consent?.reload(activity)
        return null
    }

    private fun isConsentOptIn(): Boolean {
        return AATKit.isConsentOptIn()
    }
}
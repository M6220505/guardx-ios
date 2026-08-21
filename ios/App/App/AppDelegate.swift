import UIKit
import Capacitor
import WebKit

/// GuardX intentionally uses first-party email/password authentication in the
/// iOS app. The website also exposes Google OAuth, but that browser-based flow
/// is not supported inside the native WebView. Hiding it here prevents users
/// and App Review from entering a sign-in path that cannot complete on iOS.
class GuardXBridgeViewController: CAPBridgeViewController {
    override func webViewConfiguration(for instanceConfiguration: InstanceConfiguration) -> WKWebViewConfiguration {
        let configuration = super.webViewConfiguration(for: instanceConfiguration)

        let hideUnsupportedGoogleLogin = WKUserScript(
            source: """
            (() => {
              const hideGoogleLogin = root => {
                root.querySelectorAll?.('.wk-google-wrap').forEach(element => {
                  element.setAttribute('hidden', '');
                  element.setAttribute('aria-hidden', 'true');
                  element.style.setProperty('display', 'none', 'important');
                });
              };

              hideGoogleLogin(document);

              const originalAttachShadow = Element.prototype.attachShadow;
              Element.prototype.attachShadow = function(init) {
                const root = originalAttachShadow.call(this, init);
                const observer = new MutationObserver(() => hideGoogleLogin(root));
                observer.observe(root, { childList: true, subtree: true });
                queueMicrotask(() => hideGoogleLogin(root));
                return root;
              };

              const documentObserver = new MutationObserver(() => hideGoogleLogin(document));
              documentObserver.observe(document.documentElement, { childList: true, subtree: true });
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        configuration.userContentController.addUserScript(hideUnsupportedGoogleLogin)
        return configuration
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration",
                                          sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

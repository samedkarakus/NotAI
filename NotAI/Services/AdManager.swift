import GoogleMobileAds
import UIKit

class AdManager: NSObject, GADFullScreenContentDelegate {
    
    private var interstitial: GADInterstitialAd?

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        Task {
            do {
                interstitial = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
                interstitial?.fullScreenContentDelegate = self
            } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
        }
    }

    func showAd(from viewController: UIViewController) {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: viewController)
            loadAd()
        } else {
            print("Ad wasn't ready.")
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}

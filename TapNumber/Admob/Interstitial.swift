import GoogleMobileAds

class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {
    @Published var interstitialAdLoaded: Bool = false

    var interstitialAd: GADInterstitialAd?

    override init() {
        super.init()
    }

    // リワード広告の読み込み
    func loadInterstitial() {
        GADInterstitialAd.load(
            withAdUnitID: Bundle.main.object(
                forInfoDictionaryKey: "GADAdInterID") as? String ?? "",
            request: GADRequest()
        ) { (ad, error) in
            if error != nil {
                print("😭: 読み込みに失敗しました")
                self.interstitialAdLoaded = false
                return
            }
            print("😍: 読み込みに成功しました")
            self.interstitialAdLoaded = true
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    // インタースティシャル広告の表示
    func presentInterstitial() {
        let root = UIApplication.shared.windows.first?.rootViewController
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root!)
            self.interstitialAdLoaded = false
        } else {
            print("😭: 広告の準備ができていませんでした")
            self.interstitialAdLoaded = false
            self.loadInterstitial()
        }
    }
    // 失敗通知
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("インタースティシャル広告の表示に失敗しました")
        self.interstitialAdLoaded = false
        self.loadInterstitial()
    }

    // 表示通知
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("インタースティシャル広告を表示しました")
        self.interstitialAdLoaded = false
    }

    // クローズ通知
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("インタースティシャル広告を閉じました")
        self.interstitialAdLoaded = false
    }
}


import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    private let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADBannerAdUnitID") as? String ?? ""
    private let adSize: GADAdSize
    
    init(_ adSize: GADAdSize) {
        self.adSize = adSize
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        // coordinatorを設定する
        bannerViewController.delegate = context.coordinator

        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }

        // Request a banner ad with the updated viewWidth.
        bannerView.adSize = adSize
        bannerView.load(GADRequest())
    }
    func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       class Coordinator: NSObject, BannerViewControllerWidthDelegate {
           let parent: BannerView
    
          init(_ parent: BannerView) {
              self.parent = parent
           }
    
          // MARK: - BannerViewControllerWidthDelegate methods
           func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
               // Pass the viewWidth from Coordinator to BannerView.
               parent.viewWidth = width
           }
       }
}

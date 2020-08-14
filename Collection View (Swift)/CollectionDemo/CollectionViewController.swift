//
//  CollectionViewController.swift
//  CollectionDemo
//
//  Copyright © 2019 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

private let reuseIdentifier = "Cell"
private let sectionUrl = "publisher.com/home"


class CollectionViewController: UICollectionViewController {
    
    var feedImgCache = Dictionary<URL, UIImage>()
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = CGSize(width: 342.0, height: 300.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NativoSDK.enableDevLogs()
        NativoSDK.enableTestAdvertisements()
        NativoSDK.setSectionDelegate(self, forSection: sectionUrl)
        NativoSDK.registerReuseId(reuseIdentifier, for: .native) // reuseIdentifier "Cell" comes from Main.storyboard dynamic prototype cell
        NativoSDK.register(UINib(nibName: "NativoVideoViewCell", bundle: nil), for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        self.collectionView.prefetchDataSource = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        // Get the cell
        let cell = NativoSDK.dequeueCellWithAd(from: collectionView, usingReuseIdentifierIfNoAd: reuseIdentifier, forSection: sectionUrl, atPlacementIndex: indexPath) as UICollectionViewCell
        
        // Setup normal news cell - not Nativo
        if let articleCell: CollectionViewCell = cell as? CollectionViewCell{
            articleCell.titleLabel.text = "Lorum Ipsom"
            articleCell.authorNameLabel.text = "John"
            articleCell.previewTextLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
            let imgUrl = URL.init(string: "https://images.unsplash.com/photo-1527664557558-a2b352fcf203?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=4341976025ae49162643ccdb47a72a4d&w=1000&q=80")
            let authorUrl = URL.init(string: "https://www.logolynx.com/images/logolynx/6a/6aa959dca0e6c62f593e94e02332a67f.jpeg")
            getAsyncImage(forUrl: imgUrl!) { (img) in
                articleCell.adImageView.image = img
            }
            getAsyncImage(forUrl: authorUrl!) { (authorimg) in
                articleCell.authorImageView.image = authorimg
            }
        }
        
        
        if let featureCell: CollectionViewCell = cell as? CollectionViewCell{
            // add cell title and image url
        }
        
        // set cell width
        if let widthcell = cell as? NtvCollectionViewCellMaxWidthDelegate {
            let contentInset = collectionView.contentInset.left + collectionView.contentInset.right
            let sectionInset = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
            let maxWidth = collectionView.frame.size.width - contentInset - sectionInset
            widthcell.setMaxWidth(maxWidth);
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleViewController = ArticleViewController()
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func getAsyncImage(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).sync {
            if let image = self.feedImgCache[url]  {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            if let imgData = try? Data.init(contentsOf: url) {
                let image = UIImage.init(data: imgData)
                if (image != nil) {
                    self.feedImgCache[url] = image
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

}

extension CollectionViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, needsReloadDatasourceAtLocationIdentifier identifier: Any, forReason reason: String) {
        self.collectionView?.reloadData()
    }
    
    func section(_ sectionUrl: String, shouldPlaceAdAtIndex index: IndexPath) -> Bool {
        let adStartRow = 1
        let adIntervalRow = 5
        if index.row % adIntervalRow == adStartRow {
            return true
        }
        return false
    }
    
    func section(_ sectionUrl: String, needsDisplayLandingPage sponsoredLandingPageViewController: (UIViewController & NtvLandingPageInterface)?) {
        if let landingPage = sponsoredLandingPageViewController {
            self.navigationController?.pushViewController(landingPage, animated: true)
        }
    }
    
    func section(_ sectionUrl: String, needsDisplayClickoutURL url: URL) {
        let clickoutAdVC = UIViewController()
        let webView = WKWebView(frame: clickoutAdVC.view.frame)
        let clickoutReq = URLRequest(url: url)
        webView.load(clickoutReq)
        self.navigationController?.pushViewController(clickoutAdVC, animated: true)
        clickoutAdVC.view.addSubview(webView)
    }
}

extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Prefetch Nativo SDK ads at specified index paths
        for indexPath in indexPaths {
            let isNativoAdPlacement: Bool = section(sectionUrl, shouldPlaceAdAtIndex: indexPath)
            if isNativoAdPlacement {
                NativoSDK.prefetchAd(forSection: sectionUrl, atLocationIdentifier: indexPath, options: nil)
            }
        }
    }

}


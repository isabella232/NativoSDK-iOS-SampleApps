//
//  ViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2019 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var articlesDataSource  = Array<Dictionary<String, Any>>()
    var feedImgCache = Dictionary<URL, UIImage>()
    let dateFormatter = DateFormatter()
    let ArticleCellIdentifier = "articlecell"
    let VideoCellIdentifier = "videocell"
    let NativoSectionUrl = "http://www.publisher.com/test"
    let NativoAdRow1 = 3
    let NativoAdRow2 = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NativoSDK.enableDevLogs()
        NativoSDK.enableTestAdvertisements(with: NtvTestAdType.native)
        
        NativoSDK.setSectionDelegate(self, forSection: NativoSectionUrl)
        NativoSDK.registerReuseId(ArticleCellIdentifier, for: .native) // These identifiers correlate to the dynamic prototype cells set in Main.storyboard
        NativoSDK.registerReuseId(VideoCellIdentifier, for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        
        // Register blank cell to be used as container for Nativo ads
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "nativocell")
        self.tableView.prefetchDataSource = self;
        
        startArticleFeed()
    }
}

extension ArticleListViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, needsReloadDatasourceAtLocationIdentifier identifier: Any, forReason reason: String) {
        self.tableView.reloadData()
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


extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numAds = NativoSDK.getNumberOfAds(inSection: NativoSectionUrl, inTableOrCollectionSection: section, forNumberOfItemsInDatasource: self.articlesDataSource.count)
        let totalRows = self.articlesDataSource.count + numAds
        print("-- Total Rows: \(totalRows)")
        return totalRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isNativoAdPlacement: Bool = indexPath.row == NativoAdRow1 || indexPath.row == NativoAdRow2
        var didGetNativoAdFill: Bool = false
        var cell: UITableViewCell! // Will always be initialized in this control flow so we can safely declare as implicitley unwrapped optional
        if isNativoAdPlacement {
            let nativoReuseId = "nativocell" // use seperate reuse id for Nativo ads
            
            // Using NativoSDK View API to inject ad into cell. The response will let you know if ad placement was filled.
            cell = tableView.dequeueReusableCell(withIdentifier: nativoReuseId, for: indexPath)
            didGetNativoAdFill = NativoSDK.placeAd(in: cell, atLocationIdentifier: indexPath, inContainer: tableView, forSection: NativoSectionUrl)
        }
        
        if !didGetNativoAdFill {
            let articleCell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: ArticleCellIdentifier, for: indexPath) as! ArticleCell
            
            // Get the adjusted index path so we account for possible ad displacement in datasource
            let custom : IndexPath = NativoSDK.getAdjustedIndexPath(indexPath, forAdsInjectedInSection: NativoSectionUrl)
            let row = custom.row
            let data = self.articlesDataSource[row]
            self.injectCell(articleCell, withData: data)
            cell = articleCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adAdjustedIndexPath : IndexPath = NativoSDK.getAdjustedIndexPath(indexPath, forAdsInjectedInSection: NativoSectionUrl)
        if adAdjustedIndexPath.row < self.articlesDataSource.count {
            let articleItem = self.articlesDataSource[adAdjustedIndexPath.row]
            let articleUrlStr = "https://www.nativo.com\(articleItem["fullUrl"]!)"
            let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
            articleViewController.articleURL = URL(string: articleUrlStr)
            self.navigationController?.pushViewController(articleViewController, animated: true)
        }
    }
}

extension ArticleListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Prefetch Nativo SDK ads at specified index paths
        for indexPath in indexPaths {
            let isNativoAdPlacement = indexPath.row == NativoAdRow1 || indexPath.row == NativoAdRow2
            if isNativoAdPlacement {
                NativoSDK.prefetchAd(forSection: NativoSectionUrl, atLocationIdentifier: indexPath, options: nil)
            }
        }
    }
}

extension ArticleListViewController {
    
    func setupView() {
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
    }
    
    func startArticleFeed() {
        let filePath = Bundle.main.path(forResource: "nativoblog", ofType: "json")
        let feedData = try! Data.init(contentsOf: URL(fileURLWithPath: filePath!))
        let feed = try! JSONSerialization.jsonObject(with: feedData) as! Dictionary<String, Any>
        let feedItems = feed["items"] as! Array<Dictionary<String, Any>>
        self.articlesDataSource.append(contentsOf: feedItems)
    }
    
    func injectCell(_ cell: ArticleCell, withData data: Dictionary<String, Any> ) {
        cell.titleLabel.text = data["title"] as? String
        cell.authorNameLabel.text = data["author"] as? String
        cell.previewTextLabel.text = data["excerpt"] as? String
        cell.dateLabel.text = DateFormatter.localizedString(from: Date.init(), dateStyle: .medium, timeStyle: .short)
        let imgUrl = data["assetUrl"] as! String
        self.getAsyncImage(forUrl: URL.init(string: imgUrl)!) { (img) in
            if let articleImg = img {
                if cell.titleLabel.text == data["title"] as? String {
                    cell.adImageView.image = articleImg
                }
            }
        }
    }
    
    func getAsyncImage(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let image = self.feedImgCache[url]  {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            if let imgData = try? Data.init(contentsOf: url) {
                let image = UIImage.init(data: imgData)
//                if (image != nil) {
//                    self.feedImgCache[url] = image
//                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}


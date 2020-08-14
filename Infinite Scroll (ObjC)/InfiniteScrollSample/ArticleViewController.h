//
//  ArticleViewController.h
//  NativoInfiniteScrollSample
//
//  Copyright (c) 2019 Nativo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Full page view of the article selected. Uses WebView for display, and bottom of article Nativo ad placement.
 */
@interface ArticleViewController : UIViewController

@property (nonatomic) NSURL *articleURL;

@end

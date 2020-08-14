//
//  ArticleCell.h
//  NativoInfiniteScrollSample
//
//  Copyright (c) 2019 Nativo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import NativoSDK;

/** 
 Cell used in Main.storyboard for displaying each article's healine, image and brief summary.
 Also used for Nativo native & display ads.
 
 */
@interface ArticleCell : UITableViewCell <NtvAdInterface>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *previewTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *adImageView;
@property (nonatomic, weak) IBOutlet UILabel *sponsoredLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sponsoredIndicator;

@end

//
//  SponsoredLandingPageViewController.h
//  NativoInfiniteScrollSample
//
//  Copyright (c) 2019 Nativo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@import NativoSDK;


@interface SponsoredLandingPageViewController : UIViewController  <NtvLandingPageInterface, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *previewTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *authorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property (nonatomic, weak) IBOutlet NtvContentWebView *nativoWebView;
@property (nonatomic) NSString *shareUrl;
@property (nonatomic) TrackDidShareBlock trackDidShare;

@end

//
//  NativoStandardDisplayView.h
//

#import <UIKit/UIKit.h>

@import NativoSDK;

NS_ASSUME_NONNULL_BEGIN

@interface NativoStandardDisplayView : UIView <NtvStandardDisplayAdInterface>

@property (nonatomic) NtvContentWebView *contentWebView;

@end

NS_ASSUME_NONNULL_END

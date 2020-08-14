
#import "ArticleCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ArticleCell()
@end

@implementation ArticleCell

- (void)prepareForReuse {
    self.adImageView.image = nil;
    [super prepareForReuse];
}

- (void)displaySponsoredIndicators:(BOOL)isSponsored {
    if (isSponsored) {
        [self.sponsoredLabel setHidden:NO];
        [self.sponsoredIndicator setHidden:NO];
        [self.contentView setBackgroundColor:[UIColor colorWithRed:230/255.0 green:235/255.0 blue:242/255.0 alpha:1]];
    } else {
        [self.sponsoredLabel setHidden:YES];
        [self.sponsoredIndicator setHidden:YES];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

@end

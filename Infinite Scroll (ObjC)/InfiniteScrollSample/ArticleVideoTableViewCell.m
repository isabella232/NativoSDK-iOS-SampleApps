//
//  ArticleVideoTableViewCell.m
//  NativoInfiniteScrollSample
//
//  Created by Matthew Murray on 8/19/19.
//  Copyright © 2019 Nativo. All rights reserved.
//

#import "ArticleVideoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation ArticleVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)videoFillMode {
    return AVLayerVideoGravityResizeAspect;
}

@end

//
//  HomeFeedLayout.m
//
//  Created by admin on 29/12/14.
//

#import "HomeFeedGridLayout.h"
#import "SmallFeedCell.h"

@implementation HomeFeedGridLayout

-(CGFloat)cellHeight{
    return (CGRectGetWidth(self.collectionView.frame) / [self.collectionView numberOfSections]);
}

@end

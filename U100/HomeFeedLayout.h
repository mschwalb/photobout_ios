//
//  HomeFeedLayout.h
//
//  Created by admin on 06/03/15.
//

#import <UIKit/UIKit.h>

@interface HomeFeedLayout : UICollectionViewLayout{
@private
    NSMutableDictionary *layoutInfo;
    float totalHeight;
}

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat separator;

-(CGFloat)cellHeight;

@end

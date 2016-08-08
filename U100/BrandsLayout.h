//
//  BrandsLayout.h
//
//  Created by admin on 02/03/15.
//

#import <UIKit/UIKit.h>

@interface BrandsLayout : UICollectionViewLayout{
    @private
    NSMutableDictionary *layoutInfo;
    float totalHeight;
    float separator;
}

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;


@end

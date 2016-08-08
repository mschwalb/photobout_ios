//
//  CategoriesFeedLayout.m
//  U100
//
//  Created by admin on 31/12/14.
//  Copyright (c) 2014 Gauss Development. All rights reserved.
//

#import "CategoriesFeedLayout.h"

@implementation CategoriesFeedLayout

#pragma mark - Layout
- (void)prepareLayout{
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCellAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    layoutInfo = cellLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *allAttributes = [[NSMutableArray alloc] init];
    
    [layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                    UICollectionViewLayoutAttributes *attributes,
                                                    BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return layoutInfo[indexPath];
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.bounds.size.width, totalHeight);
}


-(CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath{
    id<UICollectionViewDataSource> ds = [self.collectionView dataSource];
    [ds collectionView:nil cellForItemAtIndexPath:indexPath];
    float width = CGRectGetWidth(self.collectionView.frame);
    float height = 0.6 * width;
    float x = 0.0;
    float y = indexPath.row * height;
    if ((y+height) > totalHeight)
        totalHeight = y + height;
    return CGRectMake(x, y, width, height);
}
#pragma mark -

@end

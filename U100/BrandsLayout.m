//
//  BrandsLayout.m
//
//  Created by admin on 02/03/15.
//

#import "BrandsLayout.h"

@implementation BrandsLayout

#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self)
        [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
        [self setup];
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 3;
}
#pragma mark -

#pragma mark - Layout
- (void)prepareLayout{
    totalHeight = 0.0;
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
    float x, y, width, height;
    separator = 0.0;
    width = [self getWidth];
    height = width;
    x = width * indexPath.section + separator;
    y = (indexPath.row * height) + (separator * 2);
    if ((y+height) > totalHeight)
        totalHeight = y + height;
    return CGRectMake(x, y, width, height);
}

-(float)getWidth{
    return (CGRectGetWidth(self.collectionView.frame) / 3.0) - separator;
}
#pragma mark -

@end

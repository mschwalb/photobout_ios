//
//  BrandsCellContainer.h
//
//  Created by admin on 03/03/15.
//

#import <Foundation/Foundation.h>

@protocol BrandDetailsContainer <NSObject>

-(void)showProductsFor:(NSString *)brandName;
-(void)brandsScreenClosed;

@end

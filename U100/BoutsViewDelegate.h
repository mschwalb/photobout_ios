//
//  FavoritesViewDelegate.h
//
//  Created by admin on 12/03/15.
//

#import <Foundation/Foundation.h>

@protocol BoutsViewDelegate <NSObject>

-(void)boutsDataLoaded:(int)count;
-(void)showInFullScreen:(NSDictionary *)productDetails;
-(void)showAddNewListView;
-(void)showListProducts:(NSDictionary *)listID;

@end
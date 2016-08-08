//
//  LeftMenuItemFactory.h
//
//  Created by admin on 12/01/15.
//

#import <Foundation/Foundation.h>
#import "MenuDelegate.h"
#import "MainTabController.h"

@interface LeftMenuItemFactory : NSObject{
    @private
    NSDictionary *labelToController;
}

-(MainTabController *)controllerForItemWithLabel:(NSString *)label;
-(void)instantiateControllers:(id<MenuDelegate>)menuDelegate;

@end

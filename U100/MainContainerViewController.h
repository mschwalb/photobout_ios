//
//  MainContainerViewController.h
//
//  Created by admin on 12/01/15.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"
#import "LeftMenuDelegate.h"
#import "LeftMenuItemFactory.h"
#import "LeftMenuController.h"
#import "GestureViewDelegate.h"
#import "MainTabController.h"

@interface MainContainerViewController : UIViewController<MenuDelegate, LeftMenuDelegate, GestureViewDelegate>{
    @private
    LeftMenuController *leftMenu;
    MainTabController *currMainScreen;
    BOOL isMenuShown;
    LeftMenuItemFactory *itemFactory;
}

@end

//
//  MainTabController.h
//
//  Created by admin on 11/02/15.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface MainTabController : UIViewController

@property (nonatomic, strong) id<MenuDelegate> delegate;

-(IBAction)showMenu:(id)sender;
-(void)viewPresented;

@end

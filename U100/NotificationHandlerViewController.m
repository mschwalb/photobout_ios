//
//  NotificationHandlerViewController.m
//
//  Created by admin on 25/05/15.
//

#import "NotificationHandlerViewController.h"
#import "SingleProductView.h"
#import "Util.h"

@interface NotificationHandlerViewController ()

@end

@implementation NotificationHandlerViewController

-(void)viewWillAppear:(BOOL)animated{
    SingleProductView *pv = (SingleProductView *) [Util loadViewWithNibName:@"SingleProductView"
                                                                    andType:[SingleProductView class]];
    [Util showView:pv
            inside:self.view];
    [pv layoutSubviews];
    [pv setDelegate:self];
    [pv populateWithID:_boutID];
}

#pragma mark SingleProductViewDelegate
-(void)singleProductViewClosed{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

-(void)userProfileClicked:(NSObject *)uid{
    
}

-(void)updateBoutWith:(NSDictionary *)boutDetails
                  for:(NSObject *)boutID{
    
}
#pragma mark -

@end

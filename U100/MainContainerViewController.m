//
//  MainContainerViewController.m
//
//  Created by admin on 12/01/15.
//

#import "MainContainerViewController.h"
#import "FeedContainerViewContoller.h"
#import "Util.h"
#import "GestureView.h"
#import "NotificationHandlerViewController.h"
#import "AppDelegate.h"

@interface MainContainerViewController ()

@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isMenuShown = false;
    [self addChildControllers];
    [self populate];
    isMenuShown = true;
    [self menuItemSelected:@"FEED"
             searchUpdated:false
                   trigger:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (ad.notifBoutID) {
        [self performSegueWithIdentifier:@"notificationHandlerViewController"
                                  sender:ad.notifBoutID];
        ad.notifBoutID = nil;
    }
}

-(void)addChildControllers{
    leftMenu = (LeftMenuController *) [Util loadViewController:@"LeftMenu"];
    itemFactory = [[LeftMenuItemFactory alloc] init];
    [leftMenu setDelegate:self];
    [itemFactory instantiateControllers:self];
}

-(void)populateFromController:(UIViewController *)controller
                    aboveView:(UIView *)view{
    UIView *toView = controller.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = [self.view bounds];
    
    if (view)
        [self.view insertSubview:controller.view
                    belowSubview:view];
    else
        [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

-(void)populate{
    [self populateFromController:leftMenu
                       aboveView:nil];
    [self populateFromController:currMainScreen
                       aboveView:leftMenu.view];
}

#pragma mark FeedContainerDelegate
-(void)toggleMenuVisibility{
    float newXPos = -CGRectGetWidth(leftMenu.view.frame);
    if (!isMenuShown){
        newXPos = newXPos + CGRectGetWidth(leftMenu.container.frame);
        [self addGestureView];
        isMenuShown = true;
        [leftMenu menuShown];
    }
    else
        isMenuShown = false;
    [self moveLeftMenuTo:newXPos];
}
#pragma mark -

-(void)addGestureView{
    GestureView *gestureView = [[GestureView alloc] init];
    [gestureView initialize];
    [gestureView setDelegate:self];
    [self.view insertSubview:gestureView
                belowSubview:leftMenu.view];
    [gestureView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(gestureView);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[gestureView]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [self.view addConstraints:vertConstraints];
    [self.view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[gestureView]|"
                          options:0
                          metrics:nil
                          views:bindings]];
}

-(void)moveLeftMenuTo:(float)xPos{
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         UIView *leftView = leftMenu.view;
                         CGRect frame = leftView.frame;
                         frame.origin = CGPointMake(xPos, CGRectGetMinY(frame));
                         leftView.frame = frame;
                     }];
}

#pragma mark LeftMeuDelegate
-(void)menuItemSelected:(NSString *)itemLabel
          searchUpdated:(BOOL)status
                trigger:(NSString *)trigger{
    [self toggleMenuVisibility];
    [self removeCurrentScreen];
    [self updateCurrentScreen:itemLabel];
    [self loadCurrentScreenView];
    if (status) {
        NSString *newLabel = @"FEED";
        FeedContainerViewContoller *feed = (FeedContainerViewContoller *) [itemFactory controllerForItemWithLabel:newLabel];
        [feed updateFeed:trigger];
    }
}
#pragma mark -

#pragma mark MenuDelegate
-(void)searchParamsChanged:(NSString *)trigger{
    [self toggleMenuVisibility];
    [self menuItemSelected:@"FEED"
             searchUpdated:true
                   trigger:trigger];
}

-(void)reloadActivityCounter{

}

-(void)boutSuccessfullyCreated{
    [self toggleMenuVisibility];
    [self menuItemSelected:@"FEED"
             searchUpdated:true
                   trigger:nil];
}
#pragma mark -

#pragma mark GestureViewDelegate
-(void)viewDismissed{
    [self toggleMenuVisibility];
}
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"notificationHandlerViewController"]) {
        NotificationHandlerViewController *nvc = (NotificationHandlerViewController *) segue.destinationViewController;
        [nvc setBoutID:sender];
    }
}

-(void)removeCurrentScreen{
    [currMainScreen willMoveToParentViewController:nil];
    [currMainScreen.view removeFromSuperview];
    [currMainScreen removeFromParentViewController];
}

-(void)updateCurrentScreen:(NSString *)label{
    currMainScreen = [itemFactory controllerForItemWithLabel:label];
    if ([currMainScreen isKindOfClass:[FeedContainerViewContoller class]])
        [(FeedContainerViewContoller *)currMainScreen setDelegate:self];
}

-(void)loadCurrentScreenView{
    [self populateFromController:currMainScreen
                       aboveView:leftMenu.view];
    [currMainScreen viewPresented];
}

@end

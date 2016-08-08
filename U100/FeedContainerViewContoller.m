//
//  MainContainerViewContoller.m
//
//  Created by admin on 11/01/15.
//

#import "FeedContainerViewContoller.h"
#import "Util.h"
#import "SingleProductView.h"
#import "ProfileViewController.h"

@interface FeedContainerViewContoller ()

@end

@implementation FeedContainerViewContoller
-(void)viewDidLoad{
    [super viewDidLoad];
    [self addChildControllers];
    [self populateContainerWith:fullScreenFeed];
    currentFeed = fullScreenFeed;
    viewsToHide = @[_gridButton, _menuButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL guidanceShown = [[userDefaults objectForKey:@"guidance_shown"] boolValue];
    if (!guidanceShown) {
        UIView *guidance = [Util loadViewWithNibName:@"GuidanceView"
                                             andType:[UIView class]];
        [Util showView:guidance
                inside:self.view];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"guidance_shown"];
        [userDefaults synchronize];
    }
}

-(void)updateFeed:(NSString *)trigger{
    if ([trigger isEqualToString:@"SORT_SELECTED"]){
        if (currentFeed == gridFeed)
            [self showGrid:nil];
    }
    else if ([trigger isEqualToString:@"CAT_SELECTED"]){
        if (currentFeed == fullScreenFeed)
            [self showGrid:nil];
    }
    else if ([trigger isEqualToString:@"BRAND_SELECTED"]){
        if (currentFeed == gridFeed)
            [self showGrid:nil];
    }
    [fullScreenFeed populateProductScroller];
    [gridFeed populateHomeFeed];
}

-(void)addChildControllers{
    fullScreenFeed = (HomeFeedFullScreen *) [Util loadViewController:@"HomeFeedFullScreen"];
    [fullScreenFeed setDelegate:self];
    gridFeed = (HomeFeedGrid *) [Util loadViewController:@"HomeFeedGrid"];
    [gridFeed setDelegate:self];
    [self addChildViewController:fullScreenFeed];
    [self addChildViewController:gridFeed];
}

-(void)populateContainerWith:(UIViewController *)controller{
    UIView *toView = controller.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = [_containerView bounds];

    [_containerView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

-(void)reloadFullScreenFeedIfRequired{
    if (currentFeed == fullScreenFeed && gridFeed.hasCategoryChanged){
        [fullScreenFeed populateProductScroller];
        gridFeed.hasCategoryChanged = false;
    }
}

-(IBAction)showGrid:(id)sender{
    [_gridButton setUserInteractionEnabled:false];
    [self removeCurrentFeed];
    [self toggleCurrentFeed];
    [self populateContainerWith:currentFeed];
    [self toggleFeedImage];
    [self reloadFullScreenFeedIfRequired];
    [_gridButton setUserInteractionEnabled:true];
}

-(void)toggleFeedImage{
    NSString *imageName = @"grid";
    if (currentFeed == gridFeed)
        imageName = @"full_screen";
    UIImage *backGrnd = [UIImage imageNamed:imageName];
    [_gridButton setImage:backGrnd
                 forState:UIControlStateNormal];
}

-(void)toggleCurrentFeed{
    if (currentFeed == fullScreenFeed){
        NSDictionary *currBout = [fullScreenFeed currBout];
        [gridFeed setCurrFullScreenBout:currBout];
        currentFeed = gridFeed;
    }
    else
        currentFeed = fullScreenFeed;
}

-(void)removeCurrentFeed{
    [currentFeed willMoveToParentViewController:nil];
    [currentFeed.view removeFromSuperview];
    [currentFeed removeFromParentViewController];
}

#pragma mark FullScreenFeedDelegate
-(void)showCommentsClicked{
    [self enableFullScreenScroller:false];
    [self toggleViewsToHide:true];
}

-(void)closeCommentsClicked{
    [self enableFullScreenScroller:true];
    [self toggleViewsToHide:false];
}

-(void)showMoreInfoClicked{
    [self enableFullScreenScroller:false];
    [self toggleViewsToHide:true];
}

-(void)closeMoreInfoClicked{
    [self enableFullScreenScroller:true];
    [self toggleViewsToHide:false];
}

-(void)toggleViewsToHide:(BOOL)isHidden{
    for (UIView *viewToHide in viewsToHide)
        [viewToHide setHidden:isHidden];
}

-(void)updateVoteTo:(NSObject *)count{
    [_voteLabel setText:[NSString stringWithFormat:@"%@", count]];
}
#pragma mark -

-(void)enableFullScreenScroller:(BOOL)isEnabled{
    if (currentFeed == fullScreenFeed)
        [fullScreenFeed enableScroller:isEnabled];
}

#pragma mark GridFeedDelegate
-(void)showSingleProductView:(UIView *)pv{
    [pv setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view insertSubview:pv
                aboveSubview:_gridButton];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(pv);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[pv]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [self.view addConstraints:vertConstraints];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[pv]|"
                               options:0
                               metrics:nil
                               views:bindings]];
}
#pragma mark -
@end

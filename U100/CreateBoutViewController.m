//
//  CreateBoutViewController.m
//
//  Created by admin on 08/04/15.
//

#import "CreateBoutViewController.h"
#import "NameBoutView.h"
#import "AddPhotoToBoutView.h"
#import "Util.h"

@interface CreateBoutViewController ()

@end

@implementation CreateBoutViewController

-(void)viewPresented{
    currBoutID = nil;
    nbv = (NameBoutView *) [Util loadViewWithNibName:@"NameBoutView"
                                             andType:[NameBoutView class]];
    [nbv setDelegate:self];
    AddPhotoToBoutView *apv = (AddPhotoToBoutView *) [Util loadViewWithNibName:@"AddPhotoToBoutView"
                                                                       andType:[AddPhotoToBoutView class]];
    [apv setDelegate:self];
    ifv = (InviteFriendsView *) [Util loadViewWithNibName:@"InviteFriendsView"
                                                                     andType:[InviteFriendsView class]];
    [ifv populate];
    [ifv setDelegate:self];
    flow = @[nbv, apv, ifv];
    currIdx = 0;
    [self loadViewAtIdx:currIdx];
}

-(void)loadViewAtIdx:(int)idx{
    if (idx >= [flow count] || (idx == 2 && !isCurrBoutPrivate)) {
        [[super delegate] boutSuccessfullyCreated];
        currBoutID = nil;
        currIdx = 0;
        [self loadViewAtIdx:0];
    }
    else{
        UIView *view = [flow objectAtIndex:idx];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view insertSubview:view
                    belowSubview:_menu];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
        NSArray *vertConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|[view]|"
                                    options:0
                                    metrics:nil
                                    views:bindings];
        [self.view addConstraints:vertConstraints];
        [self.view addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|[view]|"
                                    options:0
                                    metrics:nil
                                    views:bindings]];
        if (idx == 1){
            isCurrBoutPrivate = [nbv isBoutPrivate];
            [(AddPhotoToBoutView *)view addPhoto:nil];
        }
    }
}

#pragma mark CreateBoutDelegate
-(void)viewFinishedLoading{
    [_logo setHidden:true];
    [_logoLbl setHidden:true];
}

-(void)moveToNextView:(NSObject *)boutID{
    currIdx += 1;
    if (boutID){
        currBoutID = boutID;
        
    }
    [self loadViewAtIdx:currIdx];
}

-(void)presentController:(UIViewController *)controller{
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

-(NSObject *)getBoutID{
    return currBoutID;
}
#pragma mark -
@end

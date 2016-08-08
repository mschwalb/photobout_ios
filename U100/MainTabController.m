//
//  MainTabController.m
//
//  Created by admin on 11/02/15.
//

#import "MainTabController.h"

@interface MainTabController ()

@end

@implementation MainTabController

-(IBAction)showMenu:(id)sender{
    [self.delegate toggleMenuVisibility];
}

-(void)viewPresented{
    
}

@end

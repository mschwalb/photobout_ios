//
//  SingleProductView.m
//
//  Created by admin on 18/02/15.
//

#import "SingleProductView.h"
#import "BoutView.h"
#import "Util.h"
#import "AFHTTPClient.h"

@implementation SingleProductView
-(void)populateWithID:(NSObject *)prodID{
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"bout_id":prodID};
    [httpClient getPath:@"/bouts/get"
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSArray *resp = [NSJSONSerialization
                                     JSONObjectWithData: responseObject
                                     options: NSJSONReadingMutableContainers
                                     error: nil];
                    [self populateWith:[resp objectAtIndex:0]];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
}

-(void)populateWith:(NSDictionary *)productDetails{
    bv = (BoutView *) [Util loadViewWithNibName:@"BoutView"
                                                        andType:[BoutView class]];
    [bv setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self insertSubview:bv belowSubview:_close];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(bv);
    NSArray *vertConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[bv]|"
                                options:0
                                metrics:nil
                                views:bindings];
    [self addConstraints:vertConstraints];
    [self addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|[bv]|"
                                options:0
                                metrics:nil
                                views:bindings]];
    
    [self layoutSubviews];
    [bv layoutSubviews];
    [bv setDetails:productDetails];
    [bv setDelegate:self];
    [bv populate];
}

-(IBAction)closePressed:(id)sender{
    [bv containerClosing];
    [_delegate singleProductViewClosed];
    [self removeFromSuperview];
}

-(void)hideForOverlay:(BOOL)hidden{
    [_close setHidden:hidden];
}

-(void)showCommentsClicked{
    [self hideForOverlay:true];
}

-(void)closeCommentsClicked{
    [self hideForOverlay:false];
}

-(void)showMoreInfoClicked{
    [self hideForOverlay:true];
}

-(void)closeMoreInfoClicked{
    [self hideForOverlay:false];
}

-(void)userProfileClicked:(NSObject *)uid{
    [_delegate userProfileClicked:uid];
}

-(void)brandClicked:(NSString *)brand{
    
}

-(void)presentController:(UIViewController *)controller{
    [_delegate presentController:controller];
}

-(void)updateBoutWith:(NSDictionary *)boutDetails
                  for:(NSObject *)boutID{
    [_delegate updateBoutWith:boutDetails
                          for:boutID];
}

@end

//
//  NameBoutView.m
//
//  Created by admin on 08/04/15.
//

#import "NameBoutView.h"
#import "Util.h"
#import "AFHTTPClient.h"

@implementation NameBoutView

#pragma mark KeyboardHandlers
-(void)didMoveToWindow{
    if (self.window) {
        origBottomConstraint = _bottomContraint.constant;
        origBoutDurationConstraint = _boutDurationConstraint.constant;
        origBoutAccessConstraint = _boutAccessConstraint.constant;
        access = @"Public";
        [self addKeyboardNotifListeners];
        [self addTapGesture];
        [self beautifyBtns];
        [self populateDeets];
    }
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    if (newWindow == nil) {
        [self removeKeyboardNotifListeners];
    }
}

-(void)addKeyboardNotifListeners{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardShown:)
                   name:UIKeyboardDidShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keyboardHidden:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

-(void)removeKeyboardNotifListeners{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:UIKeyboardDidShowNotification
                    object:nil];
    [center removeObserver:self
                      name:UIKeyboardWillHideNotification
                    object:nil];
}

-(void)keyboardShown:(NSNotification *)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [self cacheConstraint:_bottomContraint
                andEditTo:CGRectGetHeight(keyboardFrameBeginRect)
                 withTemp:origBottomConstraint];
}

-(void)keyboardHidden:(NSNotification *)notification{
    _bottomContraint.constant = origBottomConstraint;
    _boutDurationConstraint.constant = origBoutDurationConstraint;
    _boutAccessConstraint.constant = origBoutAccessConstraint;
}
#pragma mark -

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self removeCustomViews];
    return YES;
}

-(void)cacheConstraint:(NSLayoutConstraint *)constraint
             andEditTo:(float)newVal
              withTemp:(float)temp{
     temp = constraint.constant;
    constraint.constant = newVal + temp;
}

-(void)beautifyBtns{
    NSArray *btns = @[_durationBtn, _accessBtn];
    for (UIButton *btn in btns) {
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.layer.cornerRadius = 5.0f;
    }
}

-(void)addTapGesture{
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(dismiss:)];
    [self addGestureRecognizer:tap];
}

-(void)dismiss:(UITapGestureRecognizer *)_tap{
    [_name resignFirstResponder];
    [_boutDesc resignFirstResponder];
    [tap setEnabled:true];
    [self removeCustomViews];
}

-(void)removeCustomViews{
    if (bdv) {
        [bdv removeFromSuperview];
        bdv = nil;
        [self keyboardHidden:nil];
        [_durationChevron setImage:[UIImage imageNamed:@"down_chevron"]];
    }
    if (bav) {
        [bav removeFromSuperview];
        bav = nil;
        [self keyboardHidden:nil];
        [_accessChevron setImage:[UIImage imageNamed:@"down_chevron"]];
    }
}

-(void)populateDeets{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_profilePic populateProfilePicForLoggedInUser];
    [_userName setText:[defaults valueForKey:@"firstname"]];
}

-(IBAction)setBoutAccess:(id)sender{
    if (!bav) {
        [self dismiss:nil];
        [_accessChevron setImage:[UIImage imageNamed:@"up_chevron"]];
        [self cacheConstraint:_boutAccessConstraint
                    andEditTo:100
                     withTemp:origBoutAccessConstraint];
        [tap setEnabled:false];
        bav = (BoutAccessView *)[Util loadViewWithNibName:@"BoutAccessView"
                                                    andType:[BoutAccessView class]];
        [bav setDelegate:self];
        [bav setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:bav];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(bav, _sep);
        NSArray *vertConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[bav(100)]-(0)-[_sep]"
                                    options:0
                                    metrics:nil
                                    views:bindings];
        [self addConstraints:vertConstraints];
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|[bav]|"
                              options:0
                              metrics:nil
                              views:bindings]];
    }
    else{
        [self dismiss:nil];
        [_accessChevron setImage:[UIImage imageNamed:@"down_chevron"]];
    }
}

-(IBAction)createBout:(id)sender{
    NSString *name = [_name text];
    NSString *desc = [_boutDesc text];
    if (name == nil || [name length] == 0){
        [Util showMessage:@"Please enter a valid name for your bout"
                withTitle:@"Error"];
        return;
    }
    if (desc == nil || [desc length] == 0) {
        [Util showMessage:@"Please enter a valid description for your bout"
                withTitle:@"Error"];
        return;
    }
    if (!duration) {
        [Util showMessage:@"Please set a duration for your bout"
                withTitle:@"Error"];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    [btn setUserInteractionEnabled:false];
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSString *accessParam = @"1";
    if ([access isEqualToString:@"Private"]) {
        accessParam = @"2";
    }
    NSDictionary *params = @{@"name":name,
                             @"description":desc,
                             @"period":duration,
                             @"permission":accessParam};
    [httpClient postPath:@"/bouts/create"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *resp = [NSJSONSerialization
                                           JSONObjectWithData: responseObject
                                           options: NSJSONReadingMutableContainers
                                           error: nil];
                     [_delegate moveToNextView:[resp objectForKey:@"id"]];
                     [self resetTextFields];
                     [self removeFromSuperview];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [btn setUserInteractionEnabled:true];
                     [Util showMessage:[error localizedDescription]
                             withTitle:@"Error"];
                 }];

}

-(IBAction)setBoutDuration:(id)sender{
    if (!bdv) {
        [self dismiss:nil];
        [_durationChevron setImage:[UIImage imageNamed:@"up_chevron"]];
        [self cacheConstraint:_boutDurationConstraint
                    andEditTo:150
                     withTemp:origBoutDurationConstraint];
        [tap setEnabled:false];
        bdv = (BoutDurationView *)[Util loadViewWithNibName:@"BoutDurationView"
                                                    andType:[BoutDurationView class]];
        [bdv setDelegate:self];
        [bdv setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:bdv];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(bdv, _accessBtn);
        NSArray *vertConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[bdv(150)]-(0)-[_accessBtn]"
                                    options:0
                                    metrics:nil
                                    views:bindings];
        [self addConstraints:vertConstraints];
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|[bdv]|"
                              options:0
                              metrics:nil
                              views:bindings]];
    }
    else{
        [self dismiss:nil];
        [_durationChevron setImage:[UIImage imageNamed:@"down_chevron"]];
    }
}

-(void)resetTextFields{
    [self dismiss:nil];
    NSArray *textFields = @[_name, _boutDesc];
    for (UITextField *tf in textFields)
        [tf setText:nil];
}

-(BOOL)isBoutPrivate{
    return ([access isEqualToString:@"Private"]);
}

#pragma mark BoutAccessDelegate
-(void)accessSetTo:(NSString *)_access{
    [self dismiss:nil];
    access = _access;
    [_accessBtn setTitle:[NSString stringWithFormat:@"Access control: %@", access]
                  forState:UIControlStateNormal];
}
#pragma mark -

#pragma mark BoutDurationDelegate
-(void)durationSetTo:(NSObject *)_duration{
    [self dismiss:nil];
    duration = _duration;
    [_durationBtn setTitle:[NSString stringWithFormat:@"Duration set to: %@ d", duration]
                  forState:UIControlStateNormal];
}
#pragma mark -
@end

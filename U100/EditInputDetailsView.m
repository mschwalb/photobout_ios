//
//  EditInputDetailsView.m
//
//  Created by admin on 09/03/15.
//

#import "EditInputDetailsView.h"

@implementation EditInputDetailsView

-(void)populateFor:(NSString *)title{
    [_input setPlaceholder:[self getPlaceholderFor:title]];
    [_input becomeFirstResponder];
}

-(NSString *)getPlaceholderFor:(NSString *)title{
    if ([title isEqualToString:@"FIRST NAME"]){
        paramKey = @"first_name";
        return @"Enter first name here";
    }
    else if ([title isEqualToString:@"LAST NAME"]){
        paramKey = @"last_name";
        return @"Enter last name here";
    }
    return @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [textField setUserInteractionEnabled:NO];
    [_delegate valueEntered:[textField text]
                     forKey:paramKey];
    return NO;
}

@end

//
//  RoundedBorderedTextField.m
//
//  Created by admin on 14/04/15.
//

#import "RoundedBorderedTextField.h"

@implementation RoundedBorderedTextField

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.cornerRadius = 5;
}

@end

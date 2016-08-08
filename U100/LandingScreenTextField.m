//
//  LandingScreenTextField.m
//
//  Created by admin on 27/04/15.
//

#import "LandingScreenTextField.h"

@implementation LandingScreenTextField

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIColor *color = [UIColor whiteColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
}


@end

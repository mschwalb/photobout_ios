//
//  IndentedTextField.m
//
//  Created by admin on 03/02/15.
//

#import "IndentedTextField.h"

@implementation IndentedTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end

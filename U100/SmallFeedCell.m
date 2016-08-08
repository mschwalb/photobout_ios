//
//  SmallFeedCell.m
//
//  Created by admin on 29/12/14.
//

#import "SmallFeedCell.h"
#import "Util.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking/AFImageRequestOperation.h"

@implementation SmallFeedCell

-(void)setDetails:(NSDictionary *)_productDetails{
    boutsDetails = _productDetails;
}

-(void)populate{
    [self loadImage];
    [self loadName];
    [self loadIcon];
    [self setCount];
    [self highlightWinner];
}

-(void)highlightWinner{
    int ended = [[boutsDetails objectForKey:@"ended"] intValue];
    if (ended) {
        if (!_userID) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _userID = [defaults valueForKey:@"user_email"];
        }
        NSString *email = _userID;
        NSArray *winners = [boutsDetails objectForKey:@"winners"];
        for (NSString *winner in winners) {
            if ([email isEqualToString:winner]) {
                [_winnerBookmark setHidden:false];
            }
        }
    }
}

-(void)setCount{
    NSString *text = nil;
    if (_isBout) {
        NSArray *photos = [boutsDetails objectForKey:@"photos"];
        text = [NSString stringWithFormat:@"%lu", [photos count]];
    }
    else
        text = [NSString stringWithFormat:@"%@", [boutsDetails objectForKey:@"num_votes"]];
    [_countLabel setText:text];
    [self adjustCountLblWidth];
}

-(void)adjustCountLblWidth{
    CGSize labelSize = [_countLabel.text sizeWithAttributes:@{NSFontAttributeName:_countLabel.font}];
    _widthConstraint.constant = labelSize.width;
}

-(void)clearView{
    [_photo setImage:nil];
    [_name setText:@""];
    [_countLabel setText:@""];
}

-(void)loadName{
    if (_isBout)
        [_name setText:[boutsDetails valueForKey:@"name"]];
    else
        [_name setText:[boutsDetails valueForKey:@"owner_first_name"]];
}

-(void)loadImage{
    [_photo setImage:nil];
    [_photo setContentMode:UIViewContentModeScaleAspectFill];
    NSString *relativeURL = nil;
    NSString *imgUrl = nil;
    if (_isBout) {
        NSArray *photos = [boutsDetails objectForKey:@"photos"];
        if (photos && [photos count] > 0) {
            relativeURL = [[boutsDetails[@"photos"] objectAtIndex:0] valueForKey:@"image"];
            imgUrl = [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", relativeURL];
        }
    }
    else{
        relativeURL = [boutsDetails valueForKey:@"image"];
        imgUrl = [NSString stringWithFormat:@"http://photobout-test.appspot.com%@", relativeURL];
    }
    [_photo setImageWithURL:[NSURL URLWithString:imgUrl]];
}

-(void)loadIcon{
    if (_isBout) {
        [_icon setImage:[UIImage imageNamed:@"share_icon"]];
    }
    else{
        [_icon setImage:[UIImage imageNamed:@"logo_white"]];
    }
}

-(NSDictionary *)getProductDetails{
    return boutsDetails;
}

-(void)prepareForReuse{
    [_photo setImage:nil];
    [_winnerBookmark setHidden:true];
}

@end

//
//  CommentsView.m
//
//  Created by admin on 09/02/15.
//

#import "CommentsView.h"
#import "Util.h"
#import "CommentCell.h"
#import "AFHTTPClient.h"

@implementation CommentsView
#pragma mark KeyboardHandlers
-(void)didMoveToWindow{
    if (self.window) {
        [self addKeyboardNotifListeners];
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
    
    origConstraint = _bottomConstraint.constant;
    _bottomConstraint.constant = CGRectGetHeight(keyboardFrameBeginRect) + origConstraint;
}

-(void)keyboardHidden:(NSNotification *)notification{
    _bottomConstraint.constant = origConstraint;
}
#pragma mark -

-(void)populateComments:(NSDictionary *)_productDetails
                    for:(int)idx{
    [Util addBlurViewFor:self
                   above:nil];
    int boutEnded = [[_productDetails objectForKey:@"ended"] intValue];
    if (boutEnded){
        [_commentBtn setEnabled:false];
        [_commentInput setEnabled:false];
    }
    else{
        [_commentBtn setEnabled:true];
        [_commentInput setEnabled:true];
    }
    UIColor *color = [UIColor whiteColor];
    _commentInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_commentInput.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    productDetails = _productDetails;
    photoIdx = idx;
    [self reloadComments];
    [self addGestureRecognizerToSelf];
}

-(void)addGestureRecognizerToSelf{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    [self addGestureRecognizer:tap];
}

-(void)dismissKeyboard:(UITapGestureRecognizer *)gesture{
    [_commentInput resignFirstResponder];
}

-(void)reloadComments{
    comments = [[NSMutableArray alloc] init];
    [_commentsTable reloadData];
    [self pullComments];
}

-(void)pullComments{
    NSArray *photos = [productDetails objectForKey:@"photos"];
    if (!photos || [photos count] <= 0)
        return;
    NSDictionary *currPhoto = [photos objectAtIndex:photoIdx];
    
    NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = @{@"bout_id":[productDetails objectForKey:@"id"],
                             @"owner_email":[currPhoto valueForKey:@"owner_email"]};
    if (next) {
        params = @{@"bout_id":[productDetails objectForKey:@"id"],
                   @"owner_email":[currPhoto valueForKey:@"owner_email"],
                   @"next":next};
    }
    NSLog(@"Pulling for: %@", next);
    [httpClient getPath:@"/bouts/comments/get"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *resp = [NSJSONSerialization
                                      JSONObjectWithData: responseObject
                                      options: NSJSONReadingMutableContainers
                                      error: nil];
                     NSArray *comms = [resp objectForKey:@"data"];
                     NSObject *nextCursor = [resp objectForKey:@"next"];
                     if ([nextCursor isKindOfClass:[NSString class]])
                         next = (NSString *) nextCursor;
                     else
                         next = nil;
                     if (comms && [comms count] > 0) {
                         [comments addObjectsFromArray:comms];
                         [_delegate updateCommentsCountTo:(int)[comments count]
                                                      for:photoIdx];
                         [_commentsTable reloadData];
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [Util showMessage:[error localizedDescription]
                             withTitle:@"Error"];
                 }];
}

-(IBAction)close:(id)sender{
    [_delegate closePressed];
    [self removeFromSuperview];
}

-(IBAction)postComment:(id)sender{
    NSString *text = [_commentInput text];
    if (text && [text length] > 0) {
        UIButton *btn = (UIButton *)sender;
        [btn setUserInteractionEnabled:false];
        
        NSArray *photos = [productDetails objectForKey:@"photos"];
        if (!photos || [photos count] <= 0)
            return;
        NSDictionary *currPhoto = [photos objectAtIndex:photoIdx];
        
        NSURL *url = [NSURL URLWithString:@"http://photobout-test.appspot.com"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        NSDictionary *params = @{@"bout_id":[productDetails objectForKey:@"id"],
                                 @"message":text,
                                 @"owner_email":[currPhoto valueForKey:@"owner_email"]};
        [httpClient postPath:@"/bouts/comments/add"
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [btn setUserInteractionEnabled:true];
                         [_commentInput setText:@""];
                         [_commentInput resignFirstResponder];
                         [self reloadComments];
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [btn setUserInteractionEnabled:true];
                         [_commentInput resignFirstResponder];
                         [Util showMessage:[error localizedDescription]
                                 withTitle:@"Error"];
                     }];
    }
    else
        [Util showMessage:@"Please enter a valid comment"
                withTitle:@"Error"];
}

#pragma mark CommentCellDelegate
-(void)showUserProfile:(NSObject *)uid{
    [_delegate showCommentUser:uid];
}
#pragma mark -

#pragma mark UITableMethods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return [comments count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *) [Util loadViewWithNibName:@"CommentCell"
                                                          andType:[CommentCell class]];
    [cell setDelegate:self];
    [cell populateWith:[comments objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -

#pragma UIScrollView Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int tempPage = scrollView.contentOffset.y / scrollView.frame.size.height;
    int totalPages = scrollView.contentSize.height / scrollView.frame.size.height;
    if (tempPage >= totalPages - 1 && next) {
        [self pullComments];
    }
}
#pragma mark -
@end


//  FirstViewController.m
//  U100
//
//  Created by Marko Bulaić on 21/08/14.
//  Copyright (c) 2014 Gauss Development. All rights reserved.
//
#import "UITabBarController+hidable.h"
#import "TMPostDetailViewController.h"
#import "Reachability.h"
#import "FTWCache.h"
#import "AFNetworking.h"
#import "ItemData.h"
#import "ProductDetailedViewController.h"
#import "HomeViewController.h"
#import "AddToListViewController.h"
#import "TransitionDelegate.h"
#import "HomeTableViewCell.h"
#import "UIViewController+AMSlideMenu.h"
#import "Magento.h"
#import "ShareProductViewController.h"
#import "UIImageView+Network.h"
#import "FTWCache.h"
#import "UserProfileViewController.h"
#import "WebViewController.h"






@interface HomeViewController () <TableCellDelegate,UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (strong,nonatomic) NSMutableArray *homeTabItems;
@property (strong,nonatomic) NSMutableArray *homeTabItemsIndexes;
@property (strong,nonatomic) NSMutableArray *usersIds;
@property (strong,nonatomic) NSMutableArray *productsInCart;
@property (strong,nonatomic) NSMutableArray *sortedArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBUtton;
@property (nonatomic, strong) TransitionDelegate *transitionController;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *indexarray;
@property (nonatomic, strong) NSMutableArray *selectedBrandsArray;

@property (strong,nonatomic) NSMutableDictionary *likedItems;
@property  (strong,nonatomic) NSMutableArray *likedList;
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
@property (strong, nonatomic) NSMutableData *oldData;
@property (strong, nonatomic) NSMutableDictionary *oldDataArray;

@property  NSInteger highIndex;
//@property  NSInteger lowIndex;
@property  NSInteger currentPage;
@property  BOOL brands;
@property  BOOL categories;
@property (nonatomic, strong) WebViewController *wvvc;

@end



@implementation HomeViewController{

    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
    UIRefreshControl *refreshControl;
}

@synthesize transitionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshControl = [[UIRefreshControl alloc]init];
    self.indexarray =[[NSMutableArray alloc] init];
    [self.homeTableProducst setScrollsToTop:YES];
    [self.homeTableProducst addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"imageReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotificationWithArray:) name:@"arrayReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataWithCategoryId2:) name:@"selectedGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataWithBrand2:) name:@"selectedBrands" object:nil];

    

    
    
    self.addedToCartView.alpha = 0.0;
    self.addedToCartView.layer.borderWidth=1.0;
    self.addedToCartView.layer.borderColor=[[UIColor colorWithRed:88.0/255.0 green:94.0/255.0 blue:98.0/255.0 alpha:1.0] CGColor];
    self.transitionController = [[TransitionDelegate alloc] init];
    self.addedToCartView.layer.masksToBounds = NO;
    self.addedToCartView.layer.shadowOffset = CGSizeMake(-2, 2);
    self.addedToCartView.layer.shadowRadius = 2;
    self.addedToCartView.layer.shadowOpacity = 0.7;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Under100 full logo.png"]];
    UIImage *notSelected = [UIImage imageNamed:@"Home.png"];
    UIImage *selected = [UIImage imageNamed:@"Home selected.png"];
    
    notSelected = [notSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selected = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:notSelected selectedImage:selected];
   self.navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, -1, -6, 1);
    
      
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"Shop"];
    UIImage *selectedImage = [UIImage imageNamed:@"Shop selected.png"];
    
    [tabBarItem setImage: [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage: selectedImage];
    
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:2];
    
    UIImage *unselectedImage3 = [UIImage imageNamed:@"add post.png"];
    UIImage *selectedImage3 = [UIImage imageNamed:@"Add post selected.png"];
    
    [tabBarItem3 setImage: [unselectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage: selectedImage3];

    UITabBarItem *tabBarItem4 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    UIImage *unselectedImage4 = [UIImage imageNamed:@"Cart"];
    UIImage *selectedImage4 = [UIImage imageNamed:@"Cart selected.png"];
    
    [tabBarItem4 setImage: [unselectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem4 setSelectedImage: selectedImage4];

    UITabBarItem *tabBarItem5 = [self.tabBarController.tabBar.items objectAtIndex:4];
    
    UIImage *unselectedImage5 = [UIImage imageNamed:@"Profile"];
    UIImage *selectedImage5 = [UIImage imageNamed:@"Profile selected.png"];
    
    [tabBarItem5 setImage: [unselectedImage5 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem5 setSelectedImage: selectedImage5];
    
    
    
    
    
    
    self.backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    self.currentPage=1;

    
    
    self.homeTabItems=[[NSMutableArray alloc]init];
    self.homeTabItemsIndexes=[[NSMutableArray alloc]init];
    [self downloadData2];
    
    
    

 }



- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    self.productsInCart = [[NSMutableArray alloc]init];

    if([[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"]){
        
    [Magento call:@[@"cart.info", [[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"], @"1"                    ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            if ([responseObject objectForKey:@"items"]){
                for(int i=0;i<[[responseObject objectForKey:@"items"] count];i++) {
                    
                    [self.productsInCart addObject:[[[responseObject objectForKey:@"items"] objectAtIndex:i]valueForKey:@"product_id" ]];
                }
                [self.homeTableProducst reloadData];
                [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[responseObject objectForKey:@"items_count"]];
            }}
        [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"items_count"] forKey:@"cartQuantity"];}
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD dismiss];
          }];}

    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"cartQuantity"]];

    self.tabBarController.tabBar.hidden=NO;
    [self loadUserData];
    [self.homeTableProducst reloadData];
  }
-(void)viewWillDisappear:(BOOL)animated {
}

- (IBAction)addItemToList:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddToListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddToListView"];
    vc.item=[self.homeTabItems objectAtIndex:[button tag]-1];
    [vc setTransitioningDelegate:transitionController];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (IBAction)shareProduct:(UIButton *)sender
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareProductViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShareProductView"];
   
    [vc setTransitioningDelegate:transitionController];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    vc.itemToShare = [self.homeTabItems objectAtIndex:sender.tag-1];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==([self.homeTabItems count]-1))
    return 504;
   
    else return 430;}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.homeTabItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    ItemData *item= [self.homeTabItems objectAtIndex:indexPath.row];
    cell.commentButton.selected=NO;
    cell.addToCartButton.tag=indexPath.row+1;
    [cell.addToCartButton setTitle:[NSString stringWithFormat:@"$%@" ,item.price] forState:UIControlStateNormal];
    cell.name.text=item.name;
    cell.addTolistButton.tag=indexPath.row+1;
    cell.likeButton.tag=indexPath.row+1;
    cell.commentButton.tag=indexPath.row+1;
    cell.moreButton.tag=indexPath.row+1;
    cell.shareButton.tag=indexPath.row+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    cell.numberOfLikes.text=[NSString stringWithFormat:@"%ld", (long)item.likeCount];
    cell.numberOfcomments.text=[NSString stringWithFormat:@"%ld", (long)item.commentCount];

            cell.postedBy.text=[NSString stringWithFormat:@"Posted by %@",item.postedBy];
            [cell.goToUserProfileButton setTitle:item.postedByID forState:UIControlStateNormal];
            cell.goToUserProfileButton.tag=indexPath.row+1;
    
    NSURL *ownerImageUrl = [NSURL URLWithString:item.postedByImage];
    [cell.postedByImageView loadImageFromURL1:ownerImageUrl placeholderImage:nil cachingKey:item.postedBy];
    NSString *tempUrl=[NSString stringWithFormat:@"%@%@",@"http://www.theunder100.com/restxml/index/getimage/img/",item.productID];
    NSURL *URL = [NSURL URLWithString:tempUrl];
    NSString *key = [NSString stringWithFormat:@"%@",item.productID];
    
    UIImage* image = [UIImage imageNamed:@"image.jpg"];
    UIImageView *imageVIew=[[UIImageView alloc]init];
    //[imageVIew setImageWithURL:[NSURL URLWithString:[item.gallery objectAtIndex:0]]];
   [imageVIew loadImageFromURL:URL placeholderImage:image cachingKey:key index:indexPath];
    UIImage *image1 = imageVIew.image;
    NSMutableArray *slikice=[[NSMutableArray alloc]init];
    if([self.productsInCart containsObject:item.productID])
        cell.addToCartButton.selected=YES;
    else cell.addToCartButton.selected=NO;

    NSString *key2 = [NSString stringWithFormat:@"5-%@",key];
    NSData *cachedData = [FTWCache objectForKey:key2];
    if (cachedData) {
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:cachedData];
        cell.images=array;
        if([item.productImages count]<1)
        [item.productImages addObject:[array objectAtIndex:0]];

        
    }
    else {
    if(image1)  [slikice addObject:image1];
    item.productImages=slikice;
    cell.images = slikice;
    }

    
    
   if(item.like ==YES) cell.likeButton.selected=YES;
 else cell.likeButton.selected=NO;
    
    if(item.is_comented ==YES) cell.commentButton.selected=YES;
    else cell.commentButton.selected=NO;

    [cell refreshGUI];
    
    if((indexPath.row+1==self.highIndex)&&self.highIndex>19)
  {
      
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
      if(self.categories==YES) [self downloadCategories];
     else if(self.brands==YES) [self downloadBrands];

      else
      [self downloadData2];
  }
    
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ProductNavController"];
    
    ProductDetailedViewController *viewController = [navigationController.viewControllers firstObject];
  
    ItemData *item= [self.homeTabItems objectAtIndex:indexPath.row];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.images = [NSMutableArray arrayWithArray:item.productImages];
    viewController.item=item;
    
    if(item.like==YES)viewController.likeSelected=YES;
    else viewController.likeSelected=NO;
    
    [self.navigationController pushViewController:viewController animated:YES];
}



- (IBAction)menuButton:(id)sender {
    [self.mainSlideMenu openLeftMenuAnimated:YES];

}
- (IBAction)searchButton:(id)sender {
    
   
        if(self.navigationItem.titleView.hidden==NO){
            _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 230, 42)];
            [self.searchBUtton setImage:nil];
            [self.searchBUtton setTitle:@"Cancel"];
           
            _searchBar.delegate = self;
            self.searchBar.layer.borderWidth=1.0;
            self.searchBar.layer.cornerRadius=5.0;
            self.searchBar.layer.backgroundColor=[[UIColor clearColor ] CGColor];
            self.searchBar.layer.borderColor=[[UIColor clearColor] CGColor];

            self.tempArray = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [_tempArray addObject:[[UIBarButtonItem alloc] initWithCustomView:_searchBar]];
            self.navigationItem.leftBarButtonItem = _tempArray[1];
            self.navigationItem.titleView.hidden=YES;
            [_searchBar becomeFirstResponder];
            
        }
        else {
            [self.searchBUtton setImage:[UIImage imageNamed:@"Search icon"]];
            [self.searchBUtton setTitle:nil];

            _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,0, 40)];
            _searchBar.tintColor = self.navigationController.navigationBar.tintColor;
            _searchBar.delegate = self;
            self.navigationItem.leftBarButtonItem = self.tempArray[0];
            self.navigationItem.titleView.hidden=NO;
        }

}

- (IBAction)likeButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    ItemData *item= [self.homeTabItems objectAtIndex:[button tag]-1];
    HomeTableViewCell *swipedCell  = [self.homeTableProducst cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag]-1 inSection:0] ];

    [[NSUserDefaults standardUserDefaults] setObject:@"YES"  forKey:@"newItemLiked"];
    if(item.like) {
        item.like=NO;
        button.selected=NO;
        [self.likedList removeObject:item.productID];
        swipedCell.numberOfLikes.text=[NSString stringWithFormat:@"%ld",[swipedCell.numberOfLikes.text integerValue]-1];

       
        
    } else {
    
        item.like=YES;
        button.selected=YES;
        [self.likedList addObject:item.productID];
        swipedCell.numberOfLikes.text=[NSString stringWithFormat:@"%ld",[swipedCell.numberOfLikes.text integerValue]+1];

    }

    [self saveJsonWithData];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [Magento call:@[@"like_api.likeproduct",@{
                            @"productID":item.productID,
                            @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]
                            }
                        
                        ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Magento.service.customerID = responseObject;
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        }];
    });
}

- (IBAction)commentButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ProductNavController"];
    
    ProductDetailedViewController *viewController = [navigationController.viewControllers firstObject];
    
    ItemData *item= [self.homeTabItems objectAtIndex:[button tag]-1];
    
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.images = [NSMutableArray arrayWithArray:item.productImages];
    viewController.item=item;
    viewController.offsetNeeded=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"vigLink"]) {
        [self contract];
        _wvvc = segue.destinationViewController;
        _wvvc.addItemHidden=YES     ;
        _wvvc.url=self.url;
    }
    
   }
- (IBAction)addToCart:(id)sender {
    UIButton *button = (UIButton *)sender;
    HomeTableViewCell *cell  = [self.homeTableProducst cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag]-1 inSection:0] ];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    ItemData *item= [self.homeTabItems objectAtIndex:[button tag]-1];
    if(item.is_verified==NO){
           NSString *URLWITHSTRING=[NSString stringWithFormat:@"http://redirect.viglink.com?u=%@&key=1507a657fb951e5ad5dfb7be2cc13adf", item.product_origin];
        self.url = [[NSURL alloc] initWithString:URLWITHSTRING];

[self performSegueWithIdentifier:@"vigLink" sender:self];
    }
    else {


    if([[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"]){

        [Magento call:@[@"cart_product.add", [[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"], @[@{
                                                                                                                  @"product_id":item.productID,
                                                                                                                  @"qty":@"1"
                                                                                                                  }], @"1"                    ] success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                                                                                                      self.addedToCartImage.image=[item.productImages objectAtIndex:0];
                                                                                                                      self.addedToCartName.text=item.name;
                                                                                                                      
                                                                                                                     
                                                                                                                      
                                                                                                                      
                                                                                                                      self.addedTOCartPrice.text=[NSString stringWithFormat:@"$%@",item.price];
                                                                                                                      [UIView animateWithDuration:1 animations:^() {
                                                                                                                          self.addedToCartView.alpha = 1;
                                                                                                                      }];
                                                                                                                      [self performSelector:@selector(removeView) withObject:self afterDelay:3.0 ];
                                                                                                                      
                                                                                                                      cell.addToCartButton.selected=YES;

                                                                                                                      [SVProgressHUD dismiss];
    
                                                                                                                      
                                                                                                                  }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [SVProgressHUD dismiss];

              }];
    }
    
    
    
    else {
        [Magento call:@[@"cart.create",@"1"                    ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"cartID"];
            [Magento call:@[@"cart_customer.set", [[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"],
                            @{                         @"mode":@"customer",
                                                       @"customer_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],
                                                       
                                                       
                                                       }, @"1"                                ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                           
[Magento call:@[@"cart_product.add", [[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"], @[
                    @{
                        @"product_id":item.productID,
                        @"qty":@"1"
                        }], @"1"]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          
          self.addedToCartImage.image=[item.productImages objectAtIndex:0];
          self.addedToCartName.text=item.name;
          self.addedTOCartPrice.text=[NSString stringWithFormat:@"$%@",item.price];
          
          [UIView animateWithDuration:1 animations:^() {
              self.addedToCartView.alpha = 1;
          }];
          
          cell.addToCartButton.selected=YES;

          [self performSelector:@selector(removeView) withObject:self afterDelay:3.0 ];
          [SVProgressHUD dismiss];
          }
 
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [SVProgressHUD dismiss];
          
      }];
                                                                                                                                                   
                                                                                                                                                   
                                                                                                                                                   
                                                                                                                                                   
                                                                                                                                               }
failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [SVProgressHUD dismiss];
                      
                  }];
            
}
         
failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [SVProgressHUD dismiss];

              }];
        
        
        
        
    }
    }}


-(void)removeView{
    [Magento call:@[@"cart.info", [[NSUserDefaults standardUserDefaults]objectForKey:@"cartID"], @"1"                    ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject){
            if ([responseObject objectForKey:@"items"]){
                [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"items_count"] forKey:@"cartQuantity"];

                [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[responseObject objectForKey:@"items_count"]];
            }}
    }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];

    [UIView animateWithDuration:1 animations:^() {
        self.addedToCartView.alpha = 0.0;
    }];

}
- (void) incomingNotification:(NSNotification *)notification{
      id index=[notification object];
    [self.homeTableProducst reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];

}- (void) incomingNotificationWithArray:(NSNotification *)notification{
    id index=[notification object];
     [self.homeTableProducst reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
    
}



-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self.tabBarController setTabBarHidden:YES
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    [self.tabBarController setTabBarHidden:NO
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self expand];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self contract];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self contract];
    return YES;
}
- (void)refreshTable {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismiss];
        
       [refreshControl endRefreshing];

    }

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    
    [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],   @"0", @"0", @"3000",            @{ @"name":@{@"like":[NSString stringWithFormat:@"%%%@%%", searchBar.text]},
                                                             @"status":@1
                    
                       },
                    
                    
                    
                    @"1"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if([responseObject count]>0){
                        [self.homeTabItems removeAllObjects];

                     
                            for (id object in responseObject) {
                                
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                                
                                ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                                
                                [  self.homeTabItems addObject:item1];
                                
                            }
                           
                            
                            [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],   @"0", @"0", @"3000",              @{ @"brand":@{@"like":[NSString stringWithFormat:@"%%%@%%", searchBar.text]},
                                                                                     @"status":@1
                                                                                     
                                                                                     },
                                            
                                            
                                            
                                            @"1"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                if([responseObject count]>0){
                                                    
                                                    
                                                    for (id object in responseObject) {
                                                        
                                                        
                                                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                                                        
                                                        ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                                                        
                                                        [  self.homeTabItems addObject:item1];
                                                        
                                                    }
                                                   

                                                }
                                                 [self searchButton:self];
                                               [self.searchBar resignFirstResponder];

                                                [self.homeTableProducst reloadData];
                                                [SVProgressHUD dismiss];


                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                [self.homeTableProducst reloadData];

                                                [SVProgressHUD dismiss];

                                            }];

                                                }
                        else {
                            
                            [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],   @"0", @"0", @"3000",             @{ @"brand":@{@"like":[NSString stringWithFormat:@"%%%@%%", searchBar.text]},
                                                                                     @"status":@1
                                                                                     
                                                                                     },
                                            
                                            
                                            
                                            @"1"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                if([responseObject count]>0){
                                                    [self.homeTabItems removeAllObjects];
                                                    
                                                    for (id object in responseObject) {
                                                        
                                                        
                                                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                                                        
                                                        ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                                                        
                                                        [  self.homeTabItems addObject:item1];
                                                        
                                                    }
                                                    self.highIndex=self.homeTabItems.count;
                                                    //[self fillProducts];
                                                    [self.searchBar resignFirstResponder];
                                                    [self searchButton:self];
                                                    [self.homeTableProducst reloadData];
                                                    [SVProgressHUD dismiss];

                                                }
                                                else {
                                                    [SVProgressHUD dismiss];
                                                    [self.searchBar resignFirstResponder];
                                                    [self searchButton:self];

                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No search results"
                                                                                                    message:nil
                                                                                                   delegate:self
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles:nil];
                                                    [alert show];
                                                    
                                                    
                                                    
                                                }
                                                [SVProgressHUD dismiss];

                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                [SVProgressHUD dismiss];

                                            }];

                        
                        
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD dismiss];

                    }];
    
    

}
-(void)loadUserData{
    self.likedList=[[NSMutableArray alloc]init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *jsonPath=[documentsDirectory stringByAppendingFormat:@"/userData.json"];
    
    NSError *error;
    self.oldData=[NSMutableData dataWithContentsOfFile:jsonPath];
    
    self.oldDataArray = [NSMutableData dataWithData:[NSJSONSerialization JSONObjectWithData:self.oldData options:NSJSONWritingPrettyPrinted error:&error]];
    
    self.likedList=[self.oldDataArray valueForKeyPath:@"LikedProducts"];
        NSLog(@" all keys %@", self.likedList);




}
-(void)saveJsonWithData{
[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* jsonPath = [documentsDirectory stringByAppendingPathComponent:
                          @"userData.json"];
    NSError *error;

    self.oldData = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:self.oldDataArray options:NSJSONWritingPrettyPrinted error:&error]];
    
    [self.oldData writeToFile:jsonPath atomically:YES];
    
    
    self.oldData=[NSMutableData dataWithContentsOfFile:jsonPath];
    
    self.oldDataArray = [NSMutableData dataWithData:[NSJSONSerialization JSONObjectWithData:self.oldData options:NSJSONWritingPrettyPrinted error:&error]];
    
    self.likedList=[self.oldDataArray valueForKeyPath:@"LikedProducts"];
    [SVProgressHUD dismiss];
    
}
- (IBAction)goToUserProfileButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfileView"];
    
    UserProfileViewController *viewController = [navigationController.viewControllers firstObject];
    
      viewController.hidesBottomBarWhenPushed = YES;
    HomeTableViewCell *cell = [self.homeTableProducst cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[button tag]-1 inSection:0] ];
    viewController.userID=button.titleLabel.text;

    viewController.usernameString=cell.postedBy.text;
    [self presentViewController:navigationController animated:YES completion:nil];


}
- (void)openSelectedProduct:(UITableViewCell *)cell{
    [self contract];
        //CGPoint location = [self.tapToOpen locationInView:self.homeTableProducst];
        NSIndexPath *swipedIndexPath = [self.homeTableProducst indexPathForCell:cell];
    
        ItemData *item= [self.homeTabItems objectAtIndex:swipedIndexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ProductNavController"];
    
        ProductDetailedViewController *viewController = [navigationController.viewControllers firstObject];
    
    
    HomeTableViewCell *swipedCell  = [self.homeTableProducst cellForRowAtIndexPath:swipedIndexPath];
    if(swipedCell.addToCartButton.selected==YES) viewController.addtoCartSelected=YES;
    if(swipedCell.commentButton.selected==YES) viewController.commentSelected=YES;

        viewController.hidesBottomBarWhenPushed = YES;
        viewController.images = [NSMutableArray arrayWithArray:item.productImages];
        viewController.item=item;
        if(item.like==YES)viewController.likeSelected=YES;
        else viewController.likeSelected=NO;
    [self.navigationController pushViewController:viewController animated:YES];

    
}
- (void)likeSelectedProduct:(UITableViewCell *)cell{
       NSIndexPath *swipedIndexPath = [self.homeTableProducst indexPathForCell:cell];
    HomeTableViewCell *swipedCell  = [self.homeTableProducst cellForRowAtIndexPath:swipedIndexPath];
    
    ItemData *item= [self.homeTabItems objectAtIndex:swipedIndexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES"  forKey:@"newItemLiked"];
    if(item.like) {
        item.like=NO;
        swipedCell.likeButton.selected=NO;
        [self.likedList removeObject:item.productID];
        swipedCell.numberOfLikes.text=[NSString stringWithFormat:@"%ld",[swipedCell.numberOfLikes.text integerValue]-1];

        
    } else {
       
        item.like=YES;
        swipedCell.likeButton.selected=YES;
        [self.likedList addObject:item.productID];
        swipedCell.numberOfLikes.text=[NSString stringWithFormat:@"%ld",[swipedCell.numberOfLikes.text integerValue]+1];

    }
    [self saveJsonWithData];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [Magento call:@[@"like_api.likeproduct",@{
                            @"productID":item.productID,
                            @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"]
                            }
                        
                        ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Magento.service.customerID = responseObject;
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        }];
    });
    


}
-(void) downloadData2{
    [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"], self.indexarray, [NSNumber numberWithInt:self.currentPage],
         ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
                        for (id object in responseObject) {
                            
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                            
                                ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                            
                            [  self.homeTabItems addObject:item1];
                            
                        }
                            self.currentPage++;
                            self.highIndex=self.homeTabItems.count;
                            [self.homeTableProducst reloadData];
             [SVProgressHUD dismiss];
             
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD dismiss];

                    }];



}
- (void)downloadDataWithBrand2:(NSNotification *)notification{
    self.categories=NO;
    self.brands=YES;
    self.highIndex=0;
    [self.homeTabItems removeAllObjects];
    self.currentPage=1;


    self.selectedBrandsArray =[[NSMutableArray alloc] initWithArray:[[notification userInfo] valueForKey:@"brands"]];
    self.sortedArray=[[NSMutableArray alloc] init];
    if(self.selectedBrandsArray.count>0){
        for(int i=0;i<self.selectedBrandsArray.count;i++){
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:[self.selectedBrandsArray objectAtIndex:i] forKey:@"like"];
            [self.sortedArray addObject:dict];
        }
            }
    
    [self downloadBrands];
}
-(void)downloadBrands{
    self.categories=NO;
    self.brands=YES;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"],   @"0", [NSNumber numberWithInt:self.currentPage],  @"20",           @{ @"brand": self.sortedArray,
                                                                                                                                                 @"status":@1
                                                                                                                                                 
                                                                                                                                                 },
                    
                    
                    
                    @"1"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if([responseObject count]>0){
                            for (id object in responseObject) {
                                
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                                
                                ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                                
                                [  self.homeTabItems addObject:item1];
                                
                            }

                            [self.homeTableProducst reloadData];
                            self.currentPage++;
                            self.highIndex=self.homeTabItems.count;
                            [self resignFirstResponder];
                            [SVProgressHUD dismiss];
                            
                        }
                        else {
                            [SVProgressHUD dismiss];
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No search results"
                                                                            message:nil
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            
                            
                            
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"ispis errora %@", error);
                        [SVProgressHUD dismiss];
                        
                    }];

}
- (void)downloadDataWithCategoryId2:(NSNotification *)notification
{
    self.highIndex=0;
[self.homeTabItems removeAllObjects];
    self.currentPage=1;

    self.indexarray =[[NSMutableArray alloc] initWithArray:[[notification userInfo] valueForKey:@"index"]];
    if(self.indexarray.count==1&&[[self.indexarray objectAtIndex:0] isEqualToString:@"2"]){
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        self.categories=NO;
        
        [self downloadData2];
        return;
    }
    
    [self downloadCategories];
    
}
-(void)downloadCategories{
    self.categories=YES;
    self.brands=NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [Magento call:@[@"under.homefeed",  [[NSUserDefaults standardUserDefaults]objectForKey:@"customer_id"], self.indexarray, [NSNumber numberWithInteger:self.currentPage],
                    ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if([responseObject count]){
                            
                            
                            for (id object in responseObject) {
                                
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:object];
                                
                                ItemData *item1=[[ItemData alloc]initWithDictionary:dict];
                                
                                [  self.homeTabItems addObject:item1];
                                
                            }

                            self.currentPage++;
                            self.highIndex=self.homeTabItems.count;
                            [self.homeTableProducst reloadData];
                            
                        }
                        [SVProgressHUD dismiss];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD dismiss];
                    }];
    


}

@end

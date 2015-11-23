//
//  LeftViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/20.
//  Copyright © 2015年 姜超. All rights reserved.
//
#import <Social/Social.h>
#import "UMSocial.h"

#import "LeftViewController.h"
#import "UIViewController+RESideMenu.h"
#import "ListTableViewController.h"
#import "TopicTopicTableViewController.h"
#import "AAAViewController.h"
#import "TopicTableViewController.h"



@interface LeftViewController ()<UMSocialUIDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

//
@property (nonatomic, retain)NSArray *titles;

@end

@implementation LeftViewController


static LeftViewController *leftVC= nil;

+(UIViewController *)shareLeftVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        leftVC = [sb instantiateViewControllerWithIdentifier:@"leftVC"];
    });
    return leftVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
   
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
//            [self.sideMenuViewController setContentViewController:[ListTableViewController sharedlistNav]animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
            [self login];
            
            break;
        case 1:

            [self nextUI];
            
            
            break;
            case 2:
            
            [self cache];
            break;
            
            
        default:
            break;
    }
}

- (void)login{
    
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            UITableViewCell *cell = [self.view viewWithTag:1000];
            cell.textLabel.text = snsAccount.userName;
        }});
    
    
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
    
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsFriends is %@",response.data);
    }];
    
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
    
}



- (void)nextUI{

    TopicTableViewController *topVC = [TopicTableViewController new];
    topVC.Id = @"12";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:topVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cache{
    // 计算getSize
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheSize = [NSString stringWithFormat:@"清除缓存%luM", size / 1024 / 1024];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:cacheSize preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    // 清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    self.titles = @[@"登陆", @"用户推荐", @"清除缓存", @" ", @" "];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = _titles[indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"登陆"]) {
        cell.tag = 1000;
    }
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

@end

//
//  ListTableViewController.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTableViewController.h"


@interface ListTableViewController : UITableViewController
//获取在storyboard中的nav
+(UINavigationController *)sharedlistNav;
@end

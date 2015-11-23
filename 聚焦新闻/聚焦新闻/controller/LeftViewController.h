//
//  LeftViewController.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/20.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface LeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

+(UIViewController *)shareLeftVC;

@end

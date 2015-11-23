//
//  DataTableViewController.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTableViewController : UITableViewController
//属性传值
//标题
@property (nonatomic, retain)NSString *titleStr;
//图片
//@property (nonatomic, strong)NSString *imgStr;
//接收ID
@property (nonatomic, retain)NSString *num;
@end

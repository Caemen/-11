//
//  ListTableViewCell.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"



@interface ListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *texLabel;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, retain)List *list;
@end

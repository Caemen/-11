//
//  DataTableViewCell.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"


@interface DataTableViewCell : UITableViewCell

;
@property (weak, nonatomic) IBOutlet UILabel *dataTitle;

@property (weak, nonatomic) IBOutlet UIImageView *dataImg;
@property (weak, nonatomic) IBOutlet UIWebView *dataText;

@property (nonatomic, retain)List *list;
@end

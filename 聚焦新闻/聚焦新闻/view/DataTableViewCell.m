//
//  DataTableViewCell.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "DataTableViewCell.h"

@implementation DataTableViewCell




- (void)setList:(List *)list{
    _dataTitle.text =list.title;
    
        }


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

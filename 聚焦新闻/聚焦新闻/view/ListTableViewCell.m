//
//  ListTableViewCell.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "ListTableViewCell.h"



@implementation ListTableViewCell

//-(void)setValue:(id)value forKey:(NSString *)key{
//    
//}

-(void)setList:(List *)list{
    
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:list.images.firstObject]];
    self.texLabel.text =list.title;

    
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

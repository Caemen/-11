//
//  Detail.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/23.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "Detail.h"

@implementation Detail
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _detaID =value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

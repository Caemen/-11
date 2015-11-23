//
//  List.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "List.h"

@implementation List
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID =value;
    }
    if ([key isEqualToString:@"image-source"]) {
        _imageSource =value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@---%@---%@--%@", _title, _image, _ID,_imageSource];
}

@end

//
//  List.h
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

@property (nonatomic, retain)NSString *date;
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSArray *images;
@property (nonatomic, retain)NSString *ID;
@property (nonatomic, retain)NSString *type;
@property (nonatomic, retain)NSString *ga_prefix;

@property (nonatomic, retain)NSString *body;
@property (nonatomic, retain)NSString *image;
@property (nonatomic, retain)NSString *imageSource;
@end

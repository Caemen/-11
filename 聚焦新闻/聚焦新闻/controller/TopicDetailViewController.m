//
//  TopicDetailViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/23.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "TopicDetailViewController.h"

@interface TopicDetailViewController ()

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parser];
}

- (void)parser{
    //    1.url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDeta
                                       ,_idname]];
    NSLog(@"%@",url);
    //    2.创建接收对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    session
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        解析
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                   });
    }];
    [task resume];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

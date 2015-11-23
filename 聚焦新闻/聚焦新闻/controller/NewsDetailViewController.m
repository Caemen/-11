//
//  NewsDetailViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/19.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ListTableViewController.h"
#import "List.h"

#import <Social/Social.h>
#import "UMSocial.h"

@interface NewsDetailViewController () <UIWebViewDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *imgSourceLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) IBOutlet UIScrollView *bigScrollView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    // Do any additional setup after loading the view from its nib.
    //    解析
    [self parserData];
    
    self.contentWebView.delegate = self;
    self.contentWebView.scrollView.scrollEnabled = NO;
    self.bigScrollView.delegate = self;
}
- (void)click{
    //分享
    [UMSocialSnsService presentSnsIconSheetView:self
    appKey:@"56457fe167e58eb44700327e"shareText:@"聚焦新闻"
    shareImage:[UIImage imageNamed:@"jujiao.png"]
    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
    delegate:nil];
    

    
        // 设置横屏 要写写在分享页面前面
//            [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
//        
//            [UMSocialSnsService presentSnsController:self appKey:@"56457fe167e58eb44700327e" shareText:@".." shareImage: [UIImage imageNamed:@"1"]shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToSms, UMShareToLine, UMShareToEmail, UMShareToQzone, nil] delegate:nil];
    
    
        
    }
    
    //弹出列表方法presentSnsIconSheetView需要设置delegate为self
    -(BOOL)isDirectShareInIconActionSheet
    {
        return YES;
    }
    
    -(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
    {
        //根据`responseCode`得到发送结果,如果分享成功
        if(response.responseCode == UMSResponseCodeSuccess)
        {
            //得到分享到的微博平台名
            NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        }
    }
    
    



//解析内容
- (void)parserData{
    
    //    1.url
    NSString *str =[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/"];
    NSString *string =[str stringByAppendingString:[NSString stringWithFormat:@"%@", _num]];
    NSURL *url =[NSURL URLWithString:string];
    NSLog(@"----%@",url);
    //    2.接收对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    3.session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //        解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options: 0 error:nil];
        List *list = [List new];
        [list setValuesForKeysWithDictionary:dic];
        
        NSLog(@"%@", list);
        if (list.image != nil) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:list.image]];
        }
        self.titleLab.text = list.title;
        self.imgSourceLab.text = list.imageSource;
        NSLog(@"%@",list.imageSource);
        [self.contentWebView loadHTMLString:list.body baseURL:nil];
        
           }];
    [task resume];
    
    
}
//判断底层scroll移动大小超过图片高度,就开始移动webView的scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= scrollView.frame.size.height * 0.399) {        self.contentWebView.scrollView.scrollEnabled = YES;
        
    }else{
        self.contentWebView.scrollView.scrollEnabled = NO;
    }
}
//webView中图片调整
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat width = self.contentWebView.frame.size.width;
    
    // 修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
    @"var script = document.createElement('script');""script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;" //缩放系数
    "for(i=0;i < document.images.length;i++){"
        "myimg = document.images[i];"
        "if(myimg.width > maxwidth){"
            "oldwidth = myimg.width;"
            "myimg.width = maxwidth;"
            "myimg.height = myimg.height * (maxwidth/oldwidth) + 90;"
       "}"
    "}"
 "}\";"
        "document.getElementsByTagName('head')[0].appendChild(script);", width-10]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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

//
//  ListTableViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//
#import <Social/Social.h>
#import "UMSocial.h"

#import "ListTableViewController.h"
#import "ListTableViewCell.h"
#import "List.h"
#import "NewsDetailViewController.h"
#import "MJRefresh.h"


@interface ListTableViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic, retain)UIPageControl *page;
// 接收top新闻
@property (nonatomic, retain) NSMutableArray *topArray;
//接收解析数据
@property (nonatomic, retain)NSMutableArray *dataArray;
//List
@property (nonatomic, retain)List *list;
//nstimer
@property (nonatomic, retain)NSTimer *timer;
@end

static NSString *listIdentifier = @"listCell";

@implementation ListTableViewController

static UINavigationController *listNav = nil;

+(UINavigationController *)sharedlistNav{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        listNav = [sb instantiateViewControllerWithIdentifier:@"listNav"];
    });
    return listNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    刷新
    // 添加头部刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
        // 自动进入刷新状态
    [self.tableView headerBeginRefreshing];
    
    
    
//    scroll内容
    self.scroll.contentSize = CGSizeMake(self.view.frame.size.width *5, self.view.frame.size.height);
//    整页翻滚
    self.scroll.pagingEnabled =YES;
//    返回顶部
    self.scroll.scrollsToTop =YES;
//    滚条显示
    _scroll.showsVerticalScrollIndicator =NO;
//    _scroll.showsHorizontalScrollIndicator =NO;
//    遇到边界是否反弹
    _scroll.bounces = NO;
    _scroll.delegate =self;
    
    
    self.page =[[UIPageControl alloc]initWithFrame:CGRectMake(self.scroll.frame.size.width *0.8, self.scroll.frame.size.height *0.9, self.scroll.frame.size.width *0.2, self.scroll.frame.size.height*0.1)];
//    _page.backgroundColor = [UIColor blackColor];
    //    总页数
    _page.numberOfPages = 5;
    //    选中颜色
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    //    未选中
    _page.pageIndicatorTintColor =[UIColor grayColor];
//    事件
    [_page addTarget:self action:@selector(changePage:) forControlEvents:(UIControlEventValueChanged)];

    [self.view addSubview:_page];
    
    
// 轮播
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    
//    注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:listIdentifier];
    
//   解析
    [self parser];
}


-(void)setScrollView{
    
    for (int i = 0; i < self.topArray.count; i ++) {
        UIImageView *img1 =[[UIImageView alloc]initWithFrame:CGRectMake(self.scroll.frame.size.width * i, 0, self.scroll.frame.size.width, self.scroll.frame.size.height)];
        List *list = self.topArray[i];
        [img1 sd_setImageWithURL:[NSURL URLWithString:list.image]];
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, img1.frame.size.height - 70, img1.frame.size.width - 40, 50)];
        lab1.text = list.title;
        lab1.numberOfLines = 0;
        lab1.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:0.2];
        lab1.textColor = [UIColor whiteColor];
        [img1 addSubview:lab1];
        [self.scroll addSubview:img1];
    }
}

//解析方法
- (void)parser{
    //    1.url
    NSURL *url = [NSURL URLWithString:kFirst];
    //    2.创建接收对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    session
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        解析
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.dataArray =[NSMutableArray arrayWithCapacity:5];
        NSArray *array =dic[@"stories"];
        for (NSDictionary *dic in array) {
            List *list =[List new];
            [list setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:list];
        }
        for (List *list in _dataArray) {
            NSLog(@"%@",list.images);
            NSLog(@"%@",list.title);
        }
        self.topArray =[NSMutableArray arrayWithCapacity:5];
        NSArray *array1 =dic[@"top_stories"];
        for (NSDictionary *dic in array1) {
            List *list =[List new];
            [list setValuesForKeysWithDictionary:dic];
            [_topArray addObject:list];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
    
    
}

//结束减速时触发(停止)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    //    获取偏移量
    NSInteger currentPage = self.scroll.contentOffset.x/self.scroll.frame.size.width;
    //    更新currentPage
    self.page.currentPage = currentPage;
    
    
}

//改变scoll
- (void)changePage:(UIPageControl *)sender{
    NSInteger currentPage = sender.currentPage;//获取当前显示的页面
    self.scroll.contentOffset = CGPointMake(self.scroll.frame.size.width *currentPage, 0);
}

//轮播
- (void)changeTimer:(NSTimer *)sender{
    static int i = 0;
    i++;
    if (i > 4) {
        i =0;
    }
    [_scroll setContentOffset:CGPointMake(self.scroll.frame.size.width *i, 0)];
    _page.currentPage =i;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        [self setScrollView];
    }
    return self.dataArray.count;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifier   forIndexPath:indexPath];
            
//    显示cell内容
    self.list =self.dataArray[indexPath.row];
    cell.list = _list;
    NSLog(@"11%@",_list.title);
    
    return cell;
}

//跳转页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NewsDetailViewController *dataVC = [NewsDetailViewController new];
    //    属性传值
    List *list = self.dataArray[indexPath.row];
    
    dataVC.num =list.ID;
    
    [self.navigationController pushViewController:dataVC animated:YES];
}
// 添加头部刷新
- (void)headerRereshing
{
    [self parser];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

//分享
- (IBAction)shaerAction:(UIBarButtonItem *)sender {
    
[UMSocialSnsService presentSnsIconSheetView:self
    appKey:@"56457fe167e58eb44700327e"
    shareText:@"聚焦新闻"shareImage:[UIImage imageNamed:@"jujiao.png"]
    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                           delegate:nil];
        
        // 设置横屏 要写写在分享页面前面
        //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
        
        //    [UMSocialSnsService presentSnsController:self appKey:@"5645c84f67e58ef9a3002ead" shareText:@"" shareImage: [UIImage imageNamed:@"1"]shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToQQ, UMShareToSms, UMShareToLine, UMShareToEmail, UMShareToQzone, nil] delegate:self];
        
        
        
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




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TopicTableViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/23.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "TopicTableViewController.h"
#import "List.h"
#import "TopicTableViewCell.h"
#import "TopicDetailViewController.h"
#import "NewsDetailViewController.h"


@interface TopicTableViewController ()
@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)NSMutableArray *dataArray1;
@property (nonatomic, retain)List *topList;

@end

static NSString *topicIdent =@"topicCell";
@implementation TopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =@"聚焦新闻";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    注册
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:topicIdent];
    
    [self parser];
//    [self parser1];
}

-(void)back {
    [self dismissModalViewControllerAnimated:YES];
}
    //解析方法
    - (void)parser{
        //    1.url
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",topicDetail,_Id]];
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
                  NSLog(@"`````%@",list.title);
                NSLog(@"%@",list.images.lastObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        [task resume];
        
        
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicIdent forIndexPath:indexPath];
    
    self.topList =self.dataArray[indexPath.row];
    cell.textLabel.text =self.topList.title;
    cell.textLabel.numberOfLines =0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TopicDetailViewController *deta =[TopicDetailViewController new];
//    
//    deta.idname = [self.dataArray[indexPath.row] topicID];
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc]init];
    newsDetail.num = [self.dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:newsDetail animated:YES];
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

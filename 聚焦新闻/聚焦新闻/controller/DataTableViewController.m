//
//  DataTableViewController.m
//  聚焦新闻
//
//  Created by 姜超 on 15/11/17.
//  Copyright © 2015年 姜超. All rights reserved.
//

#import "DataTableViewController.h"
#import "ListTableViewController.h"
#import "List.h"

@interface DataTableViewController ()

@property (nonatomic, retain)NSMutableArray *dataArray;
@end

static NSString *dataIdentifier = @"dataCell";

@implementation DataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    注册
    [self.tableView registerNib:[UINib nibWithNibName:@"DataTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:dataIdentifier];
    
//    解析
    [self parserData];
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
//        DataTableViewCell *dataCell = [DataTableViewCell new];
//        [dataCell.dataImg sd_setImageWithURL:[NSURL URLWithString:list.image]];
//        dataCell.dataText =list.body;
//        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    }];
    [task resume];
    
}

- (void)viewWillAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning      需要调节自适应高度
    return 603;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataIdentifier forIndexPath:indexPath];
    
//    设置cell
    cell.dataTitle.text = _titleStr;
//    [cell.dataImg sd_setImageWithURL:[NSURL URLWithString:_imgStr]];
    
    
    return cell;
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

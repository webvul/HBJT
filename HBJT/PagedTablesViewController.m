//
//  PagedTablesViewController.m
//  HBJT
//
//  Created by Davina on 16/2/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "PagedTablesViewController.h"

@interface PagedTablesViewController ()

@end

@implementation PagedTablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.view.frame.size.width/2.56;
    }
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuildHeaderTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"First Cell"];
    if (cell == nil) {
        cell = [[GuildHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"First Cell"];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://45.32.15.152//112.jpg"] placeholderImage:[UIImage imageNamed:@"a"]];
    return cell;
}

@end

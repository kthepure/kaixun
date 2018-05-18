//
//  NewFriendsVC.m
//  kaixun
//
//  Created by 张凯 on 2017/7/27.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#import "NewFriendsVC.h"

@interface NewFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_arrList;
    NSString *_username;
    NSUserDefaults *_userDefaultes;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NewFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    self.navigationItem.title = @"新朋友";
    
    _arrList = [[NSMutableArray alloc] init];
    
    _userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [_userDefaultes objectForKey:@"dic"];
    
    if (dic.count >0) {
        _username = [dic objectForKey:@"username"];
        [_arrList addObject:dic];
    }
    self.tableView.rowHeight = 55.0f;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIButton *btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, 10.0, 60, 35.0)];
        [btnAccept setTag:100];
        [cell.contentView addSubview:btnAccept];
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10.0, 60, 35.0)];
        [btnCancel setTag:101];
        [cell.contentView addSubview:btnCancel];
    }
    
    NSDictionary *dic = [_arrList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"username"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [dic objectForKey:@"message"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    UIButton *btnAccept = (UIButton *)[cell viewWithTag:100];
    [btnAccept setTitle:@"同意" forState:UIControlStateNormal];
    btnAccept.layer.cornerRadius = 4;
    [btnAccept setBackgroundColor:BLUETEXTCOLOR];
    [btnAccept addTarget:self action:@selector(btnAccept:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCancel = (UIButton *)[cell viewWithTag:101];
    [btnCancel setTitle:@"拒绝" forState:UIControlStateNormal];
    btnCancel.layer.cornerRadius = 4;
    [btnCancel setBackgroundColor:BLUETEXTCOLOR];
    [btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)btnAccept:(id)sender
{
    //同意好友请求
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:_username error:nil];
    
    [_userDefaultes removeObjectForKey:@"dic"];
    
    [_arrList removeAllObjects];
    [self.tableView reloadData];
}

- (void)btnCancel:(id)sender
{
    //拒绝好友请求
    [[EaseMob sharedInstance].chatManager rejectBuddyRequest:_username reason:@"不认识你" error:nil];
    
    [_userDefaultes removeObjectForKey:@"dic"];
    
    [_arrList removeAllObjects];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark subview load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        _tableView.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end

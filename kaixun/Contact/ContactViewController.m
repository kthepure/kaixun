//
//  ContactViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/14.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "ContactViewController.h"
#import "DDMenuController.h"
#import "AddContactVC.h"
#import "NewFriendsVC.h"
#import "ChatViewController.h"
#import "UIImage+Extend.h"
@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_arrSystem;
    NSArray *_arrFriends;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * friendsBgView;
@property (nonatomic, strong) UILabel *friendlab;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UIButton *friendBut;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    self.navigationItem.title = @"联系人";
    [self customNavigationBar];
    [self newFriendUI];
    
    _arrSystem = @[@"申请与通知",@"群聊",@"聊天室"];
//    _arrFriends = [[EaseMob sharedInstance].chatManager buddyList]; //获取好友列表
}

- (void)newFriendUI{
    self.friendsBgView = [[UIView alloc] init];
    self.friendsBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.friendsBgView];
    
    self.friendlab = [[UILabel alloc] init];
    self.friendlab.text = @"新朋友";
    [self.friendsBgView addSubview:self.friendlab];
    
    self.rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_jiantou"]];
    [self.friendsBgView addSubview:self.rightImg];
    
    self.friendBut = [[UIButton alloc] init];
    [self.friendBut addTarget:self action:@selector(friendButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendsBgView addSubview:self.friendBut];
    
    [self.friendsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.friendlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.friendsBgView).offset(15);
        make.centerY.equalTo(self.friendsBgView);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.friendsBgView).offset(-15);
        make.centerY.equalTo(self.friendsBgView);
    }];
    [self.friendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.friendsBgView);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(64);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}
- (void)friendButAction:(UIButton *)sender{
    NewFriendsVC *vc = [[NewFriendsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    //取消导航栏背景色透明效果(默认透明)
    [self.navigationController.navigationBar setTranslucent:NO];
    
//    EMError *error = nil;
//    NSArray *buddyList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
//    if (!error) {
//        NSLog(@"获取成功 -- %@",buddyList);
//    }
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            _arrFriends = buddyList;
        }else{
            _arrFriends = [[EaseMob sharedInstance].chatManager buddyList];
        }
        [self.tableView reloadData];
    } onQueue:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithDecimalRed:67 green:74 blue:84 alpha:1]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //取消导航栏背景色透明效果(默认透明)
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)customNavigationBar{
    //导航栏左按钮
    UIButton *leftBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftBut.layer.cornerRadius = 20;
    leftBut.layer.masksToBounds = YES;
    [leftBut setBackgroundImage:[UIImage imageNamed:@"head7_40x40"] forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(navigationLeftBarButAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBut = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    self.navigationItem.leftBarButtonItem = leftBarBut;
    //导航栏右按钮
    UIButton *rightBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBut setTitle:@"添加" forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(navigationRightBarButAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBut = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightBarBut;
}
//导航栏左边按钮方法
- (void)navigationLeftBarButAction{
    DDMenuController *ddMenu = (DDMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [ddMenu showLeftController:YES];
}
//导航栏右边按钮方法
- (void)navigationRightBarButAction{
    AddContactVC *vc = [[AddContactVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
//    NSInteger a = self.navigationController.viewControllers.count;
//    NSLog(@"self.navigationController.viewControllers.count = %ld",(long)a);
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _arrSystem.count;
    } else {
        return _arrFriends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            NSString *imgStr = @"";
            cell.textLabel.text = [_arrSystem objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                imgStr = @"icon_application_notification";
            }else if (indexPath.row == 1){
                imgStr = @"icon_group_chat";
            }else{
                imgStr = @"icon_chat_room";
            }
            UIImage *image = [UIImage imageNamed:imgStr];
            
            CGSize size = CGSizeMake(30, 30);
            //获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片 ,三个参数含义是设置大小、透明度 （NO为不透明）、缩放（0代表不缩放）
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            /*
             常用的图片缩放方式这三种:
             UIGraphicsBeginImageContext // 一个基于位图的上下文（context）,并将其设置为当前上下文(context)。
             UIGraphicsGetImageFromCurrentImageContext // 把当前context的内容输出成一个UIImage图片
             UIGraphicsEndImageContext // 关闭图形上下文
             思路
             调用UIGraphicsBeginImageContextWithOptions获得用来处理图片的图形上下文。
             利用该上下文，就可在上面进行绘图操作而生成图片。
             调用UIGraphicsGetImageFromCurrentImageContext可当前上下文中获取一个UIImage对象。
             在所有的绘图操作后记住要调用UIGraphicsEndImageContext关闭图形上下文。 
             */
            
            break;
        }
            
        case 1:
        {
            EMBuddy *eMBuddy = [_arrFriends objectAtIndex:indexPath.row];
            cell.textLabel.text = eMBuddy.username;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"headimg_dl%ld",indexPath.row]];
            cell.imageView.image = [image imageWithResetSize:CGSizeMake(34, 34)];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"联系人";
        label.textColor = TEXTCOLOR;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.centerY.equalTo(view);
        }];
        return view;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        EMBuddy *buddy = [_arrFriends objectAtIndex:indexPath.row];
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.username isGroup:NO];
        chatVC.title = buddy.username; //好友的名字
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];

    
    }

}
#pragma mark subview load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        _tableView.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ZoneViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/14.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "ZoneViewController.h"
#import "DDMenuController.h"
#import "BaiduMapVC.h"
#import "KXNavControlDelegate.h"
#import "KXZoneWithThreeButCell.h"
@interface ZoneViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) KXNavControlDelegate *transitionDelegate;
@property (null_resettable, strong, nonatomic) UITableView *tableView;

@end

@implementation ZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"空间";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    //取消导航栏背景色透明效果(默认透明)
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self customNavigationBar];
//    [self configureLayoutContraints];
    self.transitionDelegate = [KXNavControlDelegate new];

    
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
//    self.transitionDelegate.transition = @"ZKScaleTransition";
    self.transitionDelegate.transition = @"ZKWindTransition";
    self.navigationController.delegate = self.transitionDelegate;
    BaiduMapVC *vc = [[BaiduMapVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Method private
- (void)configureLayoutContraints{
    [self.view addSubview:self.bgImg];
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

#pragma mark - UITableView: DateSource, Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KXZoneWithThreeButCell *cell = [tableView dequeueReusableCellWithIdentifier:[KXZoneWithThreeButCell reuseIdentifier]];
    if (!cell) {
        cell = [[KXZoneWithThreeButCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KXZoneWithThreeButCell reuseIdentifier]];
        [cell setDelegate:self];
    }
    return cell;
}

#pragma mark subview load
- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_zone"]];
    }
    return _bgImg;
}

#pragma mark - Lazy Load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorColor:[UIColor colorWithDecimalRed:224 green:227 blue:233 alpha:1]];
        
        [_tableView setEstimatedRowHeight:0];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

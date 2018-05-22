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
#import "KXBuddyDynamicVC.h"
@interface ZoneViewController ()<UITableViewDataSource, UITableViewDelegate, KXZoneWithThreeButCellDelegate>{
    CGFloat _heightOfFirstCell;
}
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
    [self configureLayoutContraints];
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
    [rightBut setTitle:@"更多" forState:UIControlStateNormal];
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

}

#pragma mark Method private
- (void)configureLayoutContraints{
//    [self.view addSubview:self.bgImg];
//    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_topLayoutGuide);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.mas_bottomLayoutGuide);
//    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark - KXZoneWithThreeButCellDelegate
- (void)zoneBuddyDynamicsDelegate:(NSString *)title{
    KXBuddyDynamicVC *vc = [KXBuddyDynamicVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)zoneNearbyDelegate{
    TQLog(@"附近");
    //    self.transitionDelegate.transition = @"ZKScaleTransition";
    //    self.transitionDelegate.transition = @"ZKWindTransition";
    //    self.navigationController.delegate = self.transitionDelegate;
    BaiduMapVC *vc = [[BaiduMapVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)zoneIntersetTribesDelegate{
    
}

#pragma mark - UITableView: DateSource, Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KXZoneWithThreeButCell *cell = [tableView dequeueReusableCellWithIdentifier:[KXZoneWithThreeButCell reuseIdentifier]];
        if (!cell) {
            cell = [[KXZoneWithThreeButCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KXZoneWithThreeButCell reuseIdentifier]];
            [cell setDelegate:self];
        }
        return cell;
    }else{
        static NSString *identifier = @"zoneCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.text = [_arrSystem objectAtIndex:indexPath.row];
        cell.textLabel.text = @"鹅漫U品";
        UIImage *image = [UIImage imageNamed:@"create_group_cell_icon"];
        CGSize size = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGRect imageRect = CGRectMake(0, 0, size.width, size.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_heightOfFirstCell > 0) {
            return _heightOfFirstCell;
        }
        
        [self.tableView layoutIfNeeded];
        CGFloat contentWidth = CGRectGetWidth(self.tableView.frame);
        
        KXZoneWithThreeButCell *cell = [KXZoneWithThreeButCell new];
        
        [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(contentWidth);
        }];
        
        _heightOfFirstCell = roundf([cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5);
        return _heightOfFirstCell;
    }else{
        return 44;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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

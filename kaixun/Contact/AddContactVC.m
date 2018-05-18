//
//  AddContactVC.m
//  kaixun
//
//  Created by 张凯 on 2017/7/13.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#import "AddContactVC.h"

@interface AddContactVC ()<UISearchBarDelegate>
@property (strong, nonatomic) UIButton *searchBtn;//导航栏右边取消按钮
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) UIView *searchBackgroundView;
@end

@implementation AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    self.navigationItem.title = @"添加好友";
    [self configureLayoutContraints];
    [self.searchBar becomeFirstResponder];
}

- (void)configureLayoutContraints{
    [self.view addSubview:self.searchBackgroundView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchBtn];
    [self.searchBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBackgroundView).offset(7);
        make.left.equalTo(self.searchBackgroundView).offset(5);
        make.right.equalTo(self.searchBackgroundView).offset(-45);
        make.height.mas_equalTo(30);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBar);
        make.right.equalTo(self.searchBackgroundView);
        make.width.mas_equalTo(50);
    }];

}
//搜索按钮
- (void)searchButAction:(UIButton *)sender{
    
    if (self.searchBar.text.length == 0) {
        return;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBackgroundView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_s102_wodetouxiang"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(5);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.searchBar.text;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).offset(5);
        make.centerY.equalTo(view);
        make.right.lessThanOrEqualTo(view).offset(-60);
    }];
    UIButton *button = [[UIButton alloc] init];
    button.layer.cornerRadius = 4;
    [button setBackgroundColor:BLUETEXTCOLOR];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-5);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(50);
    }];
}

//发送添加好友申请
- (void)addButtonAction:(UIButton *)sender{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.searchBar.text message:@"我想加你为好友" error:&error];
    if (isSuccess && !error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"消息已发送，等待对方验证" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }

}


//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    self.searchStr = searchText;
//}
//搜索(键盘)
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark subview load
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"输入用户名搜索";
        _searchBar.delegate = self;
        [_searchBar setImage:[UIImage imageNamed:@"ico_sousuo"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}
-(UIView *)searchBackgroundView{
    if (!_searchBackgroundView) {
        _searchBackgroundView = [[UIView alloc] init];
        _searchBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _searchBackgroundView;
}
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setBackgroundColor:[UIColor clearColor]];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBtn addTarget:self action:@selector(searchButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}


@end

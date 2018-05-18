//
//  MessageViewController.m
//  kaixun
//
//  Created by 张凯 on 2016/11/14.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import "MessageViewController.h"
#import "DDMenuController.h"
#import "ChatWithUserVC.h"
#import <QuartzCore/QuartzCore.h>
@interface MessageViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *messageBut;
@property (nonatomic, strong) UIButton *telephoneBut;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chatList;
//临时聊天输入框
@property (nonatomic, strong) UITextField *messageTxt;
@property (nonatomic, strong) UIButton *sendBut;
@end

@implementation MessageViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    //取消导航栏背景色透明效果(默认透明)
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.chatList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [self customNavigationBar];
    [self configureLayoutConstraints];
    
    NSArray *cons1 = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.chatList addObjectsFromArray:cons1];
}
- (void)customNavigationBar{
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    navTitleView.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    navTitleView.layer.cornerRadius = 8;
    navTitleView.layer.masksToBounds = YES;
    navTitleView.layer.borderWidth = 1.5;
    navTitleView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [navTitleView addSubview:self.messageBut];
    [navTitleView addSubview:self.telephoneBut];
    [self.messageBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(navTitleView);
        make.width.equalTo(navTitleView).dividedBy(2);
    }];
    [self.telephoneBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(navTitleView);
        make.width.equalTo(navTitleView).dividedBy(2);
    }];
    self.navigationItem.titleView = navTitleView;
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
    [rightBut setTitle:@"＋" forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont boldSystemFontOfSize:40];
    [rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(navigationRightBarButAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBut = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightBarBut;
}
- (void)configureLayoutConstraints{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-35);
    }];
    [self.view addSubview:self.messageTxt];
    [self.messageTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-60);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-2);
        make.height.mas_equalTo(30);
    }];
    [self.view addSubview:self.sendBut];
    [self.sendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTxt.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.messageTxt);
    }];
}
//导航栏左边按钮方法
- (void)navigationLeftBarButAction{
    DDMenuController *ddMenu = (DDMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [ddMenu showLeftController:YES];
}
- (void)messageButAction{
    _messageBut.backgroundColor = [UIColor whiteColor];
     [_messageBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
    _telephoneBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    [_telephoneBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)telephoneButAction{
    _telephoneBut.backgroundColor = [UIColor whiteColor];
    [_telephoneBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
    _messageBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    [_messageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//导航栏右边按钮方法
- (void)navigationRightBarButAction{
    
}
- (void)sendButAction:(UIButton *)sender{
    ChatWithUserVC *vc = [[ChatWithUserVC alloc] init];
    vc.userName = self.messageTxt.text;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"chatListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    EMConversation *con = [self.chatList objectAtIndex:indexPath.row];
    cell.textLabel.text = con.chatter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatWithUserVC *vc = [[ChatWithUserVC alloc] init];
    EMConversation *con = [self.chatList objectAtIndex:indexPath.row];
    vc.userName = con.chatter;
    [self presentViewController:vc animated:YES completion:nil];
}
//监听系统键盘
#pragma mark Responding to keyboard events
- (void)keyboardWillHide:(NSNotification *)notification {
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    CGRect keyRect1 = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyRect2 = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = self.view.frame;
    rect.origin.y = keyRect2.origin.y - self.view.frame.size.height + 44;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark subview load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 46, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIButton *)messageBut{
    if (!_messageBut) {
        _messageBut = [[UIButton alloc] init];
        _messageBut.backgroundColor = [UIColor whiteColor];
        [_messageBut setTitle:@"消息" forState:UIControlStateNormal];
        [_messageBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
        _messageBut.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_messageBut addTarget:self action:@selector(messageButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBut;
}
-(UIButton *)telephoneBut{
    if (!_telephoneBut) {
        _telephoneBut = [[UIButton alloc] init];
        _telephoneBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
        [_telephoneBut setTitle:@"电话" forState:UIControlStateNormal];
        [_telephoneBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _telephoneBut.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_telephoneBut addTarget:self action:@selector(telephoneButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _telephoneBut;
}
-(UITextField *)messageTxt{
    if (!_messageTxt) {
        _messageTxt = [[UITextField alloc] init];
        _messageTxt.backgroundColor = [UIColor whiteColor];
        _messageTxt.layer.masksToBounds = YES;
        _messageTxt.layer.cornerRadius = 4;
        _messageTxt.layer.borderWidth = 1;
        _messageTxt.layer.borderColor = [[UIColor colorWithDecimalRed:240 green:247 blue:250 alpha:1] CGColor];
        _messageTxt.layer.shadowColor = [[UIColor colorWithDecimalRed:240 green:247 blue:250 alpha:1] CGColor];
        _messageTxt.delegate = self;
    }
    return _messageTxt;
}
-(UIButton *)sendBut{
    if (!_sendBut) {
        _sendBut = [[UIButton alloc] init];
        [_sendBut setTitle:@"选择" forState:UIControlStateNormal];
        [_sendBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
        _sendBut.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sendBut addTarget:self action:@selector(sendButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBut;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

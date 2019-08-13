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

@property (nonatomic, strong) UISegmentedControl *segmentedCtrl;
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
    //废弃手写的消息电话切换功能
    //    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    //    navTitleView.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    //    navTitleView.layer.cornerRadius = 8;
    //    navTitleView.layer.masksToBounds = YES;
    //    navTitleView.layer.borderWidth = 1.5;
    //    navTitleView.layer.borderColor = [[UIColor whiteColor] CGColor];
    //    self.messageBut.frame = CGRectMake(0, 0, 60, 30);
    //    self.telephoneBut.frame = CGRectMake(60, 0, 60, 30);
    //    [navTitleView addSubview:self.messageBut];
    //    [navTitleView addSubview:self.telephoneBut];
    //    self.navigationItem.titleView = navTitleView;
    self.navigationItem.titleView = self.segmentedCtrl;
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
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}
//导航栏左边按钮方法
- (void)navigationLeftBarButAction{
    DDMenuController *ddMenu = (DDMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [ddMenu showLeftController:YES];
}
//- (void)messageButAction{
//    _messageBut.backgroundColor = [UIColor whiteColor];
//     [_messageBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
//    _telephoneBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
//    [_telephoneBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}
//- (void)telephoneButAction{
//    _telephoneBut.backgroundColor = [UIColor whiteColor];
//    [_telephoneBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
//    _messageBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
//    [_messageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}
#pragma mark - Segment Action Target
- (void) segmentedControlDidTouchDown:(UISegmentedControl *)sender{
    
}
//导航栏右边按钮方法
- (void)navigationRightBarButAction{
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EMConversation *con = [self.chatList objectAtIndex:indexPath.row];
    cell.textLabel.text = con.chatter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatWithUserVC *vc = [[ChatWithUserVC alloc] init];
    EMConversation *con = [self.chatList objectAtIndex:indexPath.row];
    vc.userName = con.chatter;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithDecimalRed:245 green:247 blue:250 alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 46, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        if(@available(iOS 11.0, *)) {
        //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        } else {
        //            self.automaticallyAdjustsScrollViewInsets = NO;
        //        }
    }
    return _tableView;
}

//-(UIButton *)messageBut{
//    if (!_messageBut) {
//        _messageBut = [[UIButton alloc] init];
//        _messageBut.backgroundColor = [UIColor whiteColor];
//        [_messageBut setTitle:@"消息" forState:UIControlStateNormal];
//        [_messageBut setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
//        _messageBut.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [_messageBut addTarget:self action:@selector(messageButAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _messageBut;
//}
//-(UIButton *)telephoneBut{
//    if (!_telephoneBut) {
//        _telephoneBut = [[UIButton alloc] init];
//        _telephoneBut.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
//        [_telephoneBut setTitle:@"电话" forState:UIControlStateNormal];
//        [_telephoneBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _telephoneBut.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        [_telephoneBut addTarget:self action:@selector(telephoneButAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _telephoneBut;
//}
- (UISegmentedControl *)segmentedCtrl {
    if (!_segmentedCtrl) {
        NSArray *titles = nil;
        titles = @[@"消息", @"电话"];
        _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:titles];
        _segmentedCtrl.backgroundColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];;
        _segmentedCtrl.tintColor = [UIColor whiteColor];
        NSDictionary *attr = nil;
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            _segmentedCtrl.frame = CGRectMake( 0, 0, 70*titles.count, 27);
            attr = @{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:15]};
        }else {
            _segmentedCtrl.frame = CGRectMake( 0, 0, 60*titles.count, 27);
            attr = @{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:13]};
        }
        
        [_segmentedCtrl setTitleTextAttributes:attr forState:UIControlStateNormal];
        _segmentedCtrl.layer.cornerRadius = 8;
        _segmentedCtrl.layer.masksToBounds = YES;
        _segmentedCtrl.layer.borderWidth = 1.5;
        _segmentedCtrl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segmentedCtrl.selectedSegmentIndex = 0;
        
        [_segmentedCtrl addTarget:self action:@selector(segmentedControlDidTouchDown:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedCtrl;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

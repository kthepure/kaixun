//
//  ChatWithUserVC.m
//  kaixun
//
//  Created by 张凯 on 2017/7/3.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#import "ChatWithUserVC.h"
#import "MBProgressHUD+Extend.h"
@interface ChatWithUserVC ()<UITextFieldDelegate,IChatManagerDelegate, EMCallManagerDelegate>
{
    EMConversation *conversation ;
}
@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, strong) UITextField *messageTxt;
@property (nonatomic, strong) UIButton *sendBut;
@end

@implementation ChatWithUserVC
- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的chatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //    [[EaseMob sharedInstance].callManager removeDelegate:self];
    //    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    //开始新建会话，获取会话列表
    conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.userName conversationType:eConversationTypeChat];
    //    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 98, [UIScreen mainScreen].bounds.size.width, 400)];
    //    self.textview.backgroundColor = [UIColor colorWithDecimalRed:230 green:237 blue:245 alpha:1];
    //    [self.view addSubview:self.textview];
    
    [self customNavigationBar];
    [self configureLayoutConstraints];
    [self addText];
}

- (void)customNavigationBar{
    //    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    //    [b setTitle:@"back" forState:UIControlStateNormal];
    //    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    b.backgroundColor = [UIColor clearColor];
    //    [b addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    //    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:b];
    //    self.navigationController.navigationItem.leftBarButtonItem = left;
    
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitle:@"删除会话" forState:UIControlStateNormal];
    b1.backgroundColor = [UIColor clearColor];
    [b1 addTarget:self action:@selector(deleteChatManager) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:b1];
    
    //    UINavigationBar * bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    //    UINavigationItem * title = [[UINavigationItem alloc] initWithTitle:self.userName];
    //    [bar pushNavigationItem:title animated:NO];
    //    title.leftBarButtonItem = left;
    //    title.rightBarButtonItem = right;
    //    [self.view addSubview:bar];
    
    //    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.title = self.userName;
}

- (void)configureLayoutConstraints{
    [self.view addSubview:self.messageTxt];
    [self.messageTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-60);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-5);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.sendBut];
    [self.sendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTxt.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.messageTxt);
    }];
    [self.view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.messageTxt.mas_top).offset(-15);
    }];
}
-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendButAction:(UIButton *)sender{
    //    EMChatText *txtChat = [[EMChatText alloc] initWithText:[NSString stringWithFormat:@"%@\n\t\t\t\t\t%@说:%@",self.textview.text,self.userName,self.messageTxt.text]];
    EMChatText *txtChat = [[EMChatText alloc] initWithText:self.messageTxt.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    //生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.userName bodies:@[body]];
    message.messageType = eMessageTypeChat;
    EMError *error = nil;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [chatManager sendMessage:message progress:nil error:&error];
    if (error) {
        [MBProgressHUD toastWithFailture:@"发送失败"];
    }else{
        self.textview.text = [NSString stringWithFormat:@"%@\n\t\t\t\t\t我说:%@",self.textview.text,self.messageTxt.text];
    }
}

- (void)addText{
    //从会话管理者中获得当前会话
    EMConversation *conversation2 = [[EaseMob sharedInstance].chatManager conversationForChatter:self.userName conversationType:0];
    //conversation
    NSString * context = @"";//用于制作对话框中的内容(现在还没有分自己发送的还是别人发送的)
    NSArray *arrcon;
    NSArray *arr;
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;//制作时间戳
    arr = [conversation2 loadAllMessages];//获得内存中所有的会话
    arrcon = [conversation2 loadNumbersOfMessages:10 before:timestamp];//根据时间获得5调会话。(时间戳作用:获得timestamp这个时间以前的所有/5会话)
    for (EMMessage *msg in arrcon) {
        id<IEMMessageBody> messageBody = [msg.messageBodies firstObject];
        NSString *messageStr = nil;
        messageStr = ((EMTextMessageBody *)messageBody).text;
        if (![msg.from isEqualToString:self.userName]) {
            context = [NSString stringWithFormat:@"%@\n\t\t\t\t\t我说:%@",context,messageStr];
        }else{
            context = [NSString stringWithFormat:@"%@\n%@",context,messageStr];
        }
    }
    self.textview.text = context;
}
//收到消息时的回调
- (void)didReceiveMessage:(EMMessage *)message{
    //因为不是uitableview,所以直接在textview上输出就好,不用下面的代码,搞datasource
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSString *messageStr = nil;
    messageStr = ((EMTextMessageBody *)messageBody).text;
    self.textview.text = [NSString stringWithFormat:@"%@\n%@",self.textview.text,messageStr];
}
//删除单个会话
- (void)deleteChatManager{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.userName deleteMessages:YES append2Chat:YES];
    [self addText];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark subview load
- (UITextView *)textview{
    if (!_textview) {
        _textview = [[UITextView alloc] init];
        _textview.font = [UIFont systemFontOfSize:17];
        //        _textview.backgroundColor = [UIColor colorWithDecimalRed:230 green:237 blue:245 alpha:1];
    }
    return _textview;
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
        [_sendBut setTitle:@"发送" forState:UIControlStateNormal];
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

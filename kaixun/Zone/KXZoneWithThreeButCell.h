//
//  KXZoneWithThreeButCell.h
//  kaixun
//
//  Created by 张凯 on 2018/5/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TQPHealthyServiceHelpWayCellDelegate <NSObject>

@optional
/// 好友动态
//- (void)healthyServiceHelpWayCellWillAskingForHelper:(TQPHealthyServiceHelpWayCell *)healthyServiceHelpWay;
/// 拨打400服务热线
//- (void)healthyServiceHelpWayCellWillCallingPhone:(TQPHealthyServiceHelpWayCell *)healthyServiceHelpWay;
/// 寻找贴心服务
//- (void)healthyServiceHelpWayCellWillRequireService:(TQPHealthyServiceHelpWayCell *)healthyServiceHelpWay;
@end
///空间界面上部三个按钮
@interface KXZoneWithThreeButCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (weak, nonatomic) id<TQPHealthyServiceHelpWayCellDelegate> delegate;

@end

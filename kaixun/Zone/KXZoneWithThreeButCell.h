//
//  KXZoneWithThreeButCell.h
//  kaixun
//
//  Created by 张凯 on 2018/5/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KXZoneWithThreeButCellDelegate <NSObject>

@optional
/// 好友动态
- (void)zoneBuddyDynamicsDelegate:(NSString *)title;
/// 附近
- (void)zoneNearbyDelegate;
/// 兴趣部落
- (void)zoneIntersetTribesDelegate;
@end
///空间界面上部三个按钮
@interface KXZoneWithThreeButCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (weak, nonatomic) id<KXZoneWithThreeButCellDelegate> delegate;

@end

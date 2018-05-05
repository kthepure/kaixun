//
//  QRViewController.h
//  kaixun
//
//  Created by 张凯 on 2016/11/23.
//  Copyright © 2016年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackMessageVCWhenDismissRQCodeVCDelegate <NSObject>
- (void)backMessageVC;
@end

@interface QRCodeViewController : UIViewController
@property (nonatomic, weak) id<BackMessageVCWhenDismissRQCodeVCDelegate> delegate;
@end

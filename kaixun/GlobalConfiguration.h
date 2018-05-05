//
//  GlobalConfiguration.h
//  kaixun
//
//  Created by 张凯 on 2017/8/16.
//  Copyright © 2017年 zhangkai. All rights reserved.
//

#ifndef GlobalConfiguration_h
#define GlobalConfiguration_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]


#endif /* GlobalConfiguration_h */

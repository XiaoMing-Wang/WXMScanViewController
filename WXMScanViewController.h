//
//  WXMScanViewController.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//
/** 导航栏颜色 */
#define WXMScan_NColor [UIColor whiteColor]

/** 扫码中心区域 256容易识别 */
#define KRectSize ([UIScreen mainScreen].bounds.size)
#define WXMScan_CenterRect CGRectMake((KRectSize.width - 256) / 2.0, 205, 256, 256)

/** 底部工具栏 */
#define WXMScan_BottomRect CGRectMake(0, KRectSize.height - 80, KRectSize.width, 80)

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WXMScanJumpType) {
    WXMScanJumpTypePush = 0,
    WXMScanJumpTypePresent = 1,
};

@interface WXMScanViewController : UIViewController
@property (nonatomic, assign) WXMScanJumpType jumpType;
@end

//
//  CTMediator+WXMScanInterface.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "CTMediator.h"

@interface CTMediator (WXMScanInterface)

/** 相机权限 未检测和有都是YES */
- (BOOL)cameraPermission;

/** 获取扫码界面 */
- (UIViewController *)achieveWXMScanViewController;


@end

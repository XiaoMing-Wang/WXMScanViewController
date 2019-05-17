//
//  CTMediator+WXMScanInterface.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "CTMediator+WXMScanInterface.h"

static NSString *WXM_TargetClass = @"WXMScanInterface";

@implementation CTMediator (WXMScanInterface)

/** 相机权限 未检测和有都是YES */
- (BOOL)cameraPermission {
    return [[self performTarget:WXM_TargetClass
                         action:NSStringFromSelector(_cmd)
                         params:nil
              shouldCacheTarget:NO] boolValue] ;
}
/** 获取扫码界面 */
- (UIViewController *)achieveWXMScanViewController {
    return [self performTarget:WXM_TargetClass
                        action:NSStringFromSelector(_cmd)
                        params:nil
             shouldCacheTarget:NO] ;
}
@end

//
//  WXMScanInterface.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMScanInterface.h"
#import "WXMScanAssistant.h"
#import "WXMScanViewController.h"

@implementation WXMScanInterface

/** 相机权限 */
- (id)cameraPermission {
    return @(WXMScanAssistant.wxm_avAuthorizationStatus);
}

/** 获取扫码界面 */
- (UIViewController *)achieveWXMScanViewController {
    WXMScanViewController * vc = [WXMScanViewController new];
    return vc;
}
@end

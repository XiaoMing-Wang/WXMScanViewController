//
//  WXMScanManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "WXMScanAssistant.h"
#import "WXMWKWebViewController.h"

@interface WXMScanAssistant ()
@end
@implementation WXMScanAssistant

/* 处理扫码结果 */
+ (BOOL)wxm_handleResultWithString:(NSString *)obj scanVC:(UIViewController *)scanVC {
    NSLog(@"%@",obj);
    
//    [scanVC.navigationController pushViewController:[UIViewController new] animated:YES];
//    [self removeScanViewController:scanVC];
    
    NSURL *url = [NSURL URLWithString:obj ?: @""];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        WXMWKWebViewController * wk = [WXMWKWebViewController wkWebViewControllerWithTitle:@"" urlString:obj];
        [scanVC.navigationController pushViewController:wk animated:YES];
        [self removeScanViewController:scanVC];
    }
    
    return NO;
}

/* 相机权限 */
+ (BOOL)wxm_avAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        NSString *msg = @"请在系统设置中打开“允许访问相机”，否则将无法使用扫码功能";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:cancle];
        [alert addAction:action];
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}
/** 跳转去掉扫码界面 */
+ (void)removeScanViewController:(UIViewController *)scanVC {
    if (scanVC.navigationController == nil) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(.26 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        NSMutableArray *arrayM = @[].mutableCopy;
        NSArray *viewControllers = scanVC.navigationController.viewControllers;
        if (viewControllers.count <= 1) return;
        [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[scanVC class]]) [arrayM addObject:obj];
        }];
        [scanVC.navigationController setViewControllers:arrayM];
    });
}
@end

//
//  WXMScanManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "WXMScanAssistant.h"
@interface WXMScanAssistant ()
@end
@implementation WXMScanAssistant

/* 相机权限 */
+ (BOOL)wxm_avAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [self showAlertViewControllerWithTitle: @"提示"
                                       message:@"请在系统设置中打开“允许访问相机”，否则将无法使用相机拍照"
                                        cancel:@"取消"
                                   otherAction:@[@"去开启"]
                                 completeBlock:^(NSInteger buttonIndex) {
                                     if (buttonIndex) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                 }];
        return NO;
    }
    return YES;
}

/* 处理扫码结果 */
+ (BOOL)wxm_handleResultWithString:(NSString *)obj scanVC:(UIViewController *)scanVC {
    NSLog(@"%@",obj);
    
//    [scanVC.navigationController pushViewController:[UIViewController new] animated:YES];
//    [self removeScanViewController:scanVC];
    
    
    
    
    return NO;
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
/** AlertView */
+ (void)showAlertViewControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                                  cancel:(NSString *)cancel
                             otherAction:(NSArray *)otherAction
                           completeBlock:(void (^)(NSInteger buttonIndex))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){ if (block) block(0); }]];
    
    [otherAction enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        [alert addAction: [UIAlertAction actionWithTitle:otherAction[idx] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) { if (block) block(idx + 1); }]];
    }];
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end

//
//  WXMScanManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXMScanAssistant : NSObject

/* 相机权限 */
+ (BOOL)wxm_avAuthorizationStatus;

/* 处理扫码结果 YES继续扫码 */
+ (BOOL)wxm_handleResultWithString:(NSString *)obj scanVC:(UIViewController*)scanVC;


@end

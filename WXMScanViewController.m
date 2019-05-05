//
//  WXMScanViewController.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/5.
//  Copyright © 2019年 wq. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "WXMScanViewController.h"
#import "WXMScanCenterView.h"
#import "WXMScanAssistant.h"
#import "WXMScanBottomView.h"

@interface WXMScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) WXMScanCenterView *centerView;
@property (nonatomic, strong) WXMScanBottomView *bottomView;
@property (nonatomic, assign) BOOL isScan;
@end

@implementation WXMScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"二维码";
    [self setupNavigation];
    [self rightBarButtonItem];
    
    [self.view addSubview:self.blackView];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.bottomView];
    [self loadBlackMaskview];
    [self initializationDevice];
}

/** 黑色遮罩 */
- (void)loadBlackMaskview {
    _maskLayer = [CALayer layer];
    _maskLayer.frame = [UIScreen mainScreen].bounds;
    _maskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor;
    [self.view.layer insertSublayer:_maskLayer atIndex:0];
    
    CAShapeLayer *maskShape = [[CAShapeLayer alloc] init];
    UIBezierPath *mainPath = [UIBezierPath bezierPathWithRect:_maskLayer.bounds];
    UIBezierPath *bezier = [[UIBezierPath bezierPathWithRect:WXMScan_CenterRect] bezierPathByReversingPath];
    [mainPath appendPath:bezier];
    maskShape.path = mainPath.CGPath;
    _maskLayer.mask = maskShape;
}

/** 初始化设备 实例化摄像头 */
- (void)initializationDevice {
    [self.centerView reductionOld];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        [self initializationInterface:input error:error];
    });
}
- (void)initializationInterface:(AVCaptureDeviceInput *)input error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSLog(@"当期设备没有摄像头:%@", error.localizedDescription);
            [self leaveCurrentViewcontroller];
            return;
        }
        
        /** 界面设置 */
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.maskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
            self.blackView.alpha = 0;
        } completion:nil];
        
        
        /** 输出 */
        CGRect windowRect = [UIScreen mainScreen].bounds;
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        CGFloat x = WXMScan_CenterRect.origin.x / windowRect.size.width;
        CGFloat y = WXMScan_CenterRect.origin.y / windowRect.size.height;
        CGFloat w = WXMScan_CenterRect.size.width / windowRect.size.width;
        CGFloat h = WXMScan_CenterRect.size.height / windowRect.size.height;
        
        //扫描的区域，0~1的值
        output.rectOfInterest = CGRectMake(y, x, h, w);
        
        //设置代理，扫描成功后调用的代理
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //设备会话
        self.session = [[AVCaptureSession alloc] init];
        
        //设置会话的质量
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        
        /** 为会话添加输入和输出 */
        [self.session addInput:input];
        [self.session addOutput:output];
        
        // 设置输出格式类型，必须放在addOutput之后
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        // 显示扫描的图层
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        
        // 图层的显示模式
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = self.view.bounds;
        [self.view.layer insertSublayer:self.preview atIndex:0];
        [self.session startRunning];
        
    });
}
#pragma mark __________________________________________________________ 扫码成功回调

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (self.isScan) return;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        self.isScan = ![WXMScanAssistant wxm_handleResultWithString:obj.stringValue scanVC:self];
    } else {
        [WXMScanAssistant showAlertViewControllerWithTitle:@"" message:@"无法识别二维码内容..." cancel:@"返回" otherAction:@[@"重试"] completeBlock:^(NSInteger buttonIndex) {
            if (!buttonIndex) [self leaveCurrentViewcontroller];
            if (buttonIndex) self.isScan = NO;
        }];
    }
}
- (void)leaveCurrentViewcontroller {
    [self endScan];
    if (_jumpType == WXMScanJumpTypePush) [self.navigationController popViewControllerAnimated:YES];
    if (_jumpType == WXMScanJumpTypePresent) [self dismissViewControllerAnimated:YES completion:nil];
}
/** 结束扫码 */
- (void)endScan {
    [self.session stopRunning];
    [self.preview removeFromSuperlayer];
    [self.centerView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    self.centerView = nil;
    self.bottomView = nil;
}
/** 相册 */
- (void)rightBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:0 target:self action:@selector(rightTouch)];
    item.tintColor = WXMScan_NColor;
    self.navigationItem.rightBarButtonItem = item;
}
- (void)rightTouch {
    
}
/** 导航栏 */
- (void)setupNavigation {
    UIImage *img = [self imageWithColor:[WXMScan_NColor colorWithAlphaComponent:0.0]];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : WXMScan_NColor};
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}
/** 颜色制作图片 特定大小 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.jumpType == WXMScanJumpTypePush && !self.navigationController) [self endScan];
}
- (WXMScanCenterView *)centerView {
    if (!_centerView)_centerView = [[WXMScanCenterView alloc] initWithFrame:WXMScan_CenterRect];
    return _centerView;
}
- (WXMScanBottomView *)bottomView {
    if (!_bottomView) _bottomView = [[WXMScanBottomView alloc] initWithFrame:WXMScan_BottomRect];
    return _bottomView;
}
- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}
@end

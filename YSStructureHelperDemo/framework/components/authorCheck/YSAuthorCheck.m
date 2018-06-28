//
//  YSAuthorCheck.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSAuthorCheck.h"
#import <AVFoundation/AVFoundation.h>

@interface YSAuthorCheck()

@end

@implementation YSAuthorCheck

#pragma mark - 相机

+ (YSDeviceAuthorType)checkCameraAuthor {
    
    YSDeviceAuthorType result;
    // 检测设备是否支持
    BOOL availabel = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!availabel) {
        result = YSDeviceAuthorType_notSupport;
        return result;
    }
    
    // 检测授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            result = YSDeviceAuthorType_unknown;
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            result = YSDeviceAuthorType_denied;
            break;
        case AVAuthorizationStatusAuthorized:
            result = YSDeviceAuthorType_allow;
            break;
    }
    return YSDeviceAuthorType_unknown;
}

+ (void)requestCameraAuthor {
    
}

+ (void)gotoAuthorSettings {
    
}

@end

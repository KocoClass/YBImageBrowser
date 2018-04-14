//
//  YBImageBrowserUtilities.m
//  YBImageBrowserDemo
//
//  Created by 杨少 on 2018/4/11.
//  Copyright © 2018年 杨波. All rights reserved.
//

#import "YBImageBrowserUtilities.h"

NSString * const YBImageBrowser_notificationName_hideSelf = @"YBImageBrowser_notificationName_hideSelf";

@implementation YBImageBrowserUtilities

+ (BOOL)isGif:(NSData *)data {
    return [[self getTypeOfImageData:data] isEqualToString:@"gif"];
}

+ (NSString *)getTypeOfImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12)
                return nil;
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"])
                return @"webp";
            return nil;
    }
    return nil;
}

+ (UIViewController *)getTopController
{
    
    UIViewController *topController = nil;
    
    UIWindow *window = [self getNormalWindow];
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:UIViewController.class])
        topController = nextResponder;
    else
        topController = window.rootViewController;
    return topController;
}

+ (UIWindow *)getNormalWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    return window;
}

+ (CGFloat)getWidthWithAttStr:(NSAttributedString *)attStr {
    return [attStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
}

@end
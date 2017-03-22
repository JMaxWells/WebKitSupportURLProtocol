//
//  WKWebImageHelper.m
//  WebKitSupportURLProtocol
//
//  Created by MaxWellPro on 2017/3/22.
//  Copyright © 2017年 QuanYanTech. All rights reserved.
//

#import "WKWebImageHelper.h"

@implementation WKWebImageHelper

+ (NSURL *)webImageStringToURL:(NSString *)url {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    if ([url rangeOfString:@"jpg"].location != NSNotFound || [url rangeOfString:@"jpeg"].location != NSNotFound || [url rangeOfString:@"png"].location != NSNotFound) {
        // 将format为jpg jpeg png 改为webp格式
        url = [NSString stringWithFormat:@"%@!/format/webp",url];
    }
    return [NSURL URLWithString:url];
}

@end

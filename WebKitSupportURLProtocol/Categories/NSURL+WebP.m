//
//  NSURL+WebP.m
//  BigFan
//
//  Created by MaxWellPro on 2016/11/28.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import "NSURL+WebP.h"

@implementation NSURL (WebP)

- (BOOL)URLStringcontainFomartString:(NSString *)string {
    return ([self.absoluteString.lowercaseString rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound);
}

- (BOOL)isWebPURL {
    return [self URLStringcontainFomartString:@"-webp"] || [self URLStringcontainFomartString:@"/webp"];
}

- (BOOL)isImageURL {
    NSArray *extensions = @[@"jpg", @"jpeg", @"png",@"webp"];
    for (NSString *extension in extensions) {
        if ([self.absoluteString.lowercaseString rangeOfString:extension options:NSCaseInsensitiveSearch].location != NSNotFound){
            return YES;
        }
    }
    return NO;
}

@end

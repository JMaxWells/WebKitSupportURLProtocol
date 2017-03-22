//
//  NSURL+WebP.h
//  BigFan
//
//  Created by MaxWellPro on 2016/11/28.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WebP)
- (BOOL)URLStringcontainFomartString:(NSString *)string;

- (BOOL)isWebPURL;

- (BOOL)isImageURL;

@end

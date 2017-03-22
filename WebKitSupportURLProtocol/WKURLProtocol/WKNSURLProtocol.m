//
//  WKNSURLProtocol.m
//  WebKitSupportURLProtocol
//
//  Created by MaxWellPro on 2017/3/22.
//  Copyright © 2017年 QuanYanTech. All rights reserved.
//

#import "WKNSURLProtocol.h"
#import "NSURL+WebP.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageDownloaderOperation.h>
#import "WKWebImageHelper.h"

static NSString * const URLProtocolHandledKey = @"WK_URLProtocolHandledKey";

@interface WKNSURLProtocol() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *absoluteString;

@end

@implementation WKNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 非又拍云地址
    if ([[request.URL absoluteString] rangeOfString:@"upaiyun"].location == NSNotFound) {
        return NO;
    }
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)) {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        NSString *agent = [request valueForHTTPHeaderField:@"User-Agent"];
        // 只过滤UIWebview里边的加载图片请求
        if ([agent rangeOfString:@"AppleWebKit"].location != NSNotFound && [request.URL isImageURL]) {
            return YES;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)equivalent toRequest:(NSURLRequest *)request; {
    return [super requestIsCacheEquivalent:equivalent toRequest:request];
}

+ (NSMutableURLRequest *)redirectHostInRequset:(NSMutableURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    NSString *URLString = [self.request.URL absoluteString];
    NSURL *imageURL;
    
    // 重定义请求地址
    if ([URLString rangeOfString:@"format"].location == NSNotFound) {
        imageURL = [WKWebImageHelper webImageStringToURL:URLString];
    }
    else {
        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
        return;
    }
    
#warning - 敲黑板 画重点了
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageURL
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                            // 是否以png结尾
                                                            if ([imageURL.absoluteString.lowercaseString hasSuffix:@".png"]) {
                                                                data = UIImagePNGRepresentation(image);
                                                            } else {
                                                                data = UIImageJPEGRepresentation(image, 1);
                                                            }
                                                            if (!self.client) {
                                                                return ;
                                                            }
                                                            [self.client URLProtocol:self didLoadData:data];
                                                            [self.client URLProtocolDidFinishLoading:self];
                                                        }];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

@end

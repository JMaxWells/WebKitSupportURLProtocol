//
//  WKViewController.m
//  WebKitSupportURLProtocol
//
//  Created by MaxWellPro on 2017/3/22.
//  Copyright © 2017年 QuanYanTech. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>
#import "NSURLProtocol+WebKitSupport.h"

@interface WKViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 黑科技Runtime+NSURLProtocol的结合
    for (NSString* scheme in @[@"http", @"https"]) {
        [NSURLProtocol wk_registerScheme:scheme];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WebKitSupportURLProtocol";
    
    [self.view addSubview:self.webView];
    [self.webView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/afffda6d885a"]];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - 页面跳转的代理方法

//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//
//}
//
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler {
    
}


#pragma mark - Lazy load

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _webView;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    for (NSString* scheme in @[@"http", @"https"]) {
        [NSURLProtocol wk_unregisterScheme:scheme];
    }
}

@end

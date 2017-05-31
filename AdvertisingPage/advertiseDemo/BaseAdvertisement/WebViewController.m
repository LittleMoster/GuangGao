//
//  WebViewController.m
//  UICategory
//
//  Created by cguo on 2017/5/15.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgress.h"
#define progressViewTintColor [UIColor redColor]
#define progressBackgroundColor  [UIColor grayColor]

@interface WebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;
/** 视图 */
@property (nonatomic, strong)UIWebView *webView;

/** 进度条*/
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupbaseView];
    self.progress = [[NJKWebViewProgress alloc] init];
    
    self.webView.delegate=self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress) {
        weakSelf.progressView.progress = progress;
        NSLog(@"%f",progress);
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;
    if (self.url==nil &&self.url.length==0) {
        self.url=@"http://www.jianshu.com/p/884137d5ca8b";  
    }
  
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
//        [self.webView setScalesPageToFit:YES];
    
    
}

-(void)setupbaseView
{
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    
    self.progressView=[[UIProgressView alloc]init];
    self.progressView.frame=CGRectMake(0, 0, self.view.frame.size.width, 2);
    self.progressView.progressTintColor=progressViewTintColor;
    self.progressView.backgroundColor=progressBackgroundColor;
    [self.webView addSubview:self.progressView];
    
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    
    self.progressView.progress=progress;
    self.progressView.hidden=(progress==1.0);
    
}
- (void)CallBack:(id)sender {
    
    [self.webView goBack];//
}
- (void)ComeIn:(id)sender {
    [self.webView goForward];
}
- (void)Refresh:(id)sender {
    
    [self.webView reload];
}
#pragma mark-网页加载完毕时会来到这个界面
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   //让网页中的图片自适应屏幕的大小
    
        NSString *js = @"function imgAutoFit() { \
        var imgs = document.getElementsByTagName('img'); \
        for (var i = 0; i < imgs.length; ++i) { \
        var img = imgs[i]; \
        img.style.maxWidth = %f; \
        } \
        }";
        
        js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
        
        [webView stringByEvaluatingJavaScriptFromString:js];
        [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
   
}


@end

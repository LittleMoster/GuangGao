
//
//  AdvertisementView.m
//  advertiseDemo
//
//  Created by cguo on 2017/5/31.
//  Copyright © 2017年 zhouhuanqiang. All rights reserved.
//

#import "AdvertisementView.h"
#import "WebViewController.h"
#define showtime  4
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#define ADImageNameKey  @"ADImageNameKey"
#define ADViewURLKey  @"ADViewURLKey"

@interface AdvertisementView ()

@property (nonatomic, strong) UIImageView *adView;
    
@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, strong) NSTimer *countTimer;
    
@property (nonatomic, assign) int count;


@end

@implementation AdvertisementView

//创建广告view
-(void)ShowAdvertView
{
  
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    self.frame=window.bounds;
    [window addSubview:self];
    
        // 1.广告图片
        _adView = [[UIImageView alloc] initWithFrame:self.frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
//        _adView.clipsToBounds = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
//        [_adView addGestureRecognizer:tap];
        
        // 2.跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        
//判断本地中是否有图片
    BOOL hasImage=[self isFileExistWithFilePath:[self getFilePathWithImageName:[kUserDefaults valueForKey:ADImageNameKey]]];
    if (hasImage) {
        _adView.image=[UIImage imageWithContentsOfFile:[self getFilePathWithImageName:[kUserDefaults valueForKey:ADImageNameKey]]];
          [self startAd];
    }
    [self GetPhotoPath];

}

//保存图片
-(void)GetPhotoPath
{
    //从服务器获取图片名
    // TODO 请求广告接口
    
//    请求到的信息保存到沙盒中
    // 如果有广告链接，将广告链接也保存下来
    //            [kUserDefaults setObject:<#(nullable id)#> forKey:ADViewURLKey];
    //现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
     //判断本地中是否有相同的文件
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
 
    //没有就下载图片
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
    
 
    //有就返回图片路径
//    return [self getFilePathWithImageName:imageName];
}

//让图片消失
-(void)dismiss
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//点击view跳转到广告页详情
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
    
//    WebViewController *web=[[WebViewController alloc]init];
//    
////    web.url=[kUserDefaults valueForKey:ADViewURLKey];
//    web.url=@"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg";
//    
//    [[self viewController].navigationController pushViewController:web animated:YES];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObject:@"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg" forKey:@"urlKey"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:dic];
    
}

//倒计时显示
-(void)startAd
{
    
    
    __block int timeout=showtime;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if (timeout==0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                移除界面
                [self dismiss];
                
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //按钮计数减一
                   [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}




/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}



/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:ADImageNameKey];

            [kUserDefaults synchronize];

          
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:ADImageNameKey];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

@end

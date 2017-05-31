//
//  ViewController.m
//  advertiseDemo
//
//  Created by zhouhuanqiang on 16/5/22.
//  Copyright © 2016年 zhouhuanqiang. All rights reserved.
//

#import "ViewController.h"
#import "AdvertiseViewController.h"
#import "WebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd:) name:@"pushtoad" object:nil];
}

- (void)pushToAd:(NSNotification*)noti {

    NSLog(@"%@",noti);
    WebViewController *adVc = [[WebViewController alloc] init];
   
    NSLog(@"%@",noti.userInfo[@"urlKey"]);
    adVc.url=noti.userInfo[@"urlKey"];
    [self.navigationController pushViewController:adVc animated:YES];
    
}


@end

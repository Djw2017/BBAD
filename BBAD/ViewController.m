//
//  ViewController.m
//  BBAD
//
//  Created by Dongjw on 17/5/23.
//  Copyright © 2017年 Babybus. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "ADNativeManager.h"

@interface ViewController () <ADNativeDelegate>
{
    ADNativeManager *_nativeManger;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    ADNativeConfig *config = [[ADNativeConfig alloc] init];
    config.appkey = @"1106019494";
    config.placementId = @"6060024131687918";
    config.count = 5;
    config.defaultPlatform = ADPlatformGDT;
    config.page = ADPageTopicDetailVC;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _nativeManger = [ADNativeManager createNativeAdWithConfig:config];
        _nativeManger.delegate = self;
        [_nativeManger startRequest];
    });
}

- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didReceiveContent:(NSMutableArray<ADNativeContent *>*)contentMAry {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 300)];
    [self.view addSubview:view];
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 100)];
    [im sd_setImageWithURL:[NSURL URLWithString:contentMAry[0].imageUrl]];
    [view addSubview:im];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 320, 80)];
    [view addSubview:l];
    l.text = contentMAry[0].title;
    UILabel *d = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 80)];
    [view addSubview:d];
    d.text = contentMAry[0].describe;
    
    UITapGestureRecognizer *dd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sdf)];
    [view addGestureRecognizer:dd];
    
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 320, 300)];
//    [self.view addSubview:view1];
//    
//    UIImageView *im1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 100)];
//    [im sd_setImageWithURL:[NSURL URLWithString:contentMAry[1].imageUrl]];
//    [view1 addSubview:im1];
//    
//    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 320, 80)];
//    [view1 addSubview:l1];
//    l.text = contentMAry[1].title;
//    UILabel *d1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 80)];
//    [view1 addSubview:d1];
//    d1.text = contentMAry[1].describe;
//    
//    UITapGestureRecognizer *dd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sdfd)];
//    [view1 addGestureRecognizer:dd1];
    
    [_nativeManger attachNativeAd:contentMAry[0] toView:self.view];
    
//    [_nativeManger attachNativeAd:contentMAry[1] toView:self.view];
}

- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didFailToReceiveWithError:(NSError *)error {

}

- (void)nativeAdWillPresentScreenWithManager:(ADNativeManager *)nativeAd {
    
}

- (void)nativeAdApplicationWillEnterBackgroundWithManager:(ADNativeManager *)nativeAd {
    
}

- (void)nativeAdClosedWithManager:(ADNativeManager *)nativeAd {
    
}


- (void)sdf {
    [_nativeManger clickNativeAd:_nativeManger.contentMAry[0]];
}
- (void)sdfd {
    [_nativeManger clickNativeAd:_nativeManger.contentMAry[1]];
}
@end

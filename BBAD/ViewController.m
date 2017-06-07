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
    NSMutableArray<ADNativeContent *> *_oneChildPage;
    NSMutableArray<ADNativeContent *> *_zeroChildPage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _nativeManger = [[ADNativeManager alloc] initWithPage:ADPageAppAgeTwoVC];
        _nativeManger.delegate = self;
        [_nativeManger startRequest];
    });
}

- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didReceiveContent:(NSMutableArray<ADNativeContent *>*)contentMAry {
    
    if (contentMAry[0].child_page == 1) {
        _oneChildPage = contentMAry;
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

    }else {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 320, 300)];
        [self.view addSubview:view1];
    
        UIImageView *im1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 100)];
        [im1 sd_setImageWithURL:[NSURL URLWithString:contentMAry[0].imageUrl]];
        [view1 addSubview:im1];
    
        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 320, 80)];
        [view1 addSubview:l1];
        l1.text = contentMAry[0].title;
        UILabel *d1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 80)];
        [view1 addSubview:d1];
        d1.text = contentMAry[0].describe;
    
        UITapGestureRecognizer *dd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sdfd)];
        [view1 addGestureRecognizer:dd1];
        _zeroChildPage = contentMAry;
        

    }
    [_nativeManger attachNativeAd:contentMAry[0] toView:self.view];

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
    [_nativeManger clickNativeAd:_oneChildPage[0]];
}
- (void)sdfd {
    [_nativeManger clickNativeAd:_zeroChildPage[0]];
}
@end

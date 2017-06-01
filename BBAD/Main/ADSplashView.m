//
//  ADSplashView.m
//  BBAD
//
//  Created by BabyBus on 15/11/27.
//  Copyright © 2015年 Babybus. All rights reserved.
//

#import <BBSDK/BBMacros.h>

#import <Masonry/Masonry.h>

#import "UIImageView+WebCache.h"

#import "ADSplashView.h"

// 默认广告展示时间
static int ShowTimeLimit = 2.0;

@interface ADSplashView(){
    
    @package
    struct {
        /// 开屏广告视图展示成功
        unsigned int delegateDidDisplayed        : 1;
        /// 用户点击开屏广告视图
        unsigned int delegateDidUserClicked		 : 1;
        /// 开屏广告视图执行结束
        unsigned int delegateDidDisplayCompleted : 1;
    }_delegateFlags;
    
    // 广告视图
    UIImageView *_adImageView;
    
    // 广告背景：下方宝宝巴士字样
    UIImageView *_adBGImageView;
    
    NSString *_urlImage;
    
    // 默认展示图定时器
    NSTimer *_defaultImgTimer;

}

@end

@implementation ADSplashView

- (instancetype)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_FULL_WIDTH, SCREEN_FULL_HEIGHT)];
    
    if (self) {
        
        // 创建背景
        [self creatViewBackGround];
 
        // 广告同级背景
        [self creatBGImageView];
   
        // 开屏宣传图
        [self creatADImageView];

    }

    return self;
}

/**
 创建整个开屏广告的背景
 */
- (void)creatViewBackGround {
    UIView *viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FULL_WIDTH, SCREEN_FULL_HEIGHT)];
    viewbg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewbg];
}

/**
 创建广告同级背景
 */
- (void)creatBGImageView {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString* imageName = [NSString stringWithFormat:@"%0.0fx%0.0f",SCREEN_FULL_HEIGHT*scale,SCREEN_FULL_WIDTH*scale];
    
    UIImage *ig = [UIImage imageNamed:imageName];
    //6p 9.0.2系统 imageName = "2001x1125"
    if (ig == nil) {
        if (667 == SCREEN_FULL_HEIGHT) {
            ig = [UIImage imageNamed:@"2208x1242"];
        }
    }
    _adBGImageView = [[UIImageView alloc] initWithImage:ig];
    _adBGImageView.frame = CGRectMake(0, 0, SCREEN_FULL_WIDTH, SCREEN_FULL_HEIGHT);
    [self addSubview:_adBGImageView];

}

/**
 创建广告ImageView
 */
- (void)creatADImageView {
    
    float heightWindow = [[UIScreen mainScreen] applicationFrame].size.height;
    //大全广告
    _adImageView = [[UIImageView alloc] init];
    _adImageView.contentMode=UIViewContentModeScaleAspectFill;
    _adImageView.clipsToBounds=YES;
    _adImageView.alpha = 0.0;
    [self addSubview:_adImageView];
    
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        if (IS_IPAD) {
            make.height.equalTo(_adImageView.mas_width).multipliedBy(1566.0/1536);
        }
        else if (heightWindow<480){
            make.height.equalTo(_adImageView.mas_width).multipliedBy(1836.0/1536);
        }
        else{
            make.height.equalTo(_adImageView.mas_width).multipliedBy(1833.0/1242);
        }
    }];
}




#pragma mark - property set
- (void)setSplashViewDelegate:(id<ADSplashViewDelegate> )splashViewDelegate {
    
    if (_splashViewDelegate != splashViewDelegate) {
        
        _splashViewDelegate = splashViewDelegate;
        _delegateFlags.delegateDidDisplayed = [_splashViewDelegate respondsToSelector:@selector(splashAdViewDidDisplayed:)];
        _delegateFlags.delegateDidUserClicked = [_splashViewDelegate respondsToSelector:@selector(splashAdViewDidUserClicked:)];
        _delegateFlags.delegateDidDisplayCompleted = [_splashViewDelegate respondsToSelector:@selector(splashAdViewDidDisplayCompleted:)];
    }
}

- (void)setSplashBackgroundImageStr:(NSString *)splashBackgroundImageStr {
    _adBGImageView.image = [UIImage imageNamed:splashBackgroundImageStr];
}




#pragma mark - view life cycle
/**
 展示
 */
- (void)showToRoot {
    
    self.windowLevel = UIWindowLevelAlert;
    UIViewController* splashVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSplashView)];
    [splashVC.view addGestureRecognizer:tapGesture];
    self.rootViewController = splashVC;
    [self makeKeyAndVisible];
    
    // 默认视图消失定时器
    [self creatDefaultImgTimer];

}

/**
 默认开屏广告消失定时器
 */
- (void)creatDefaultImgTimer {
    
    self.excuting = YES;
    // 设置默认视图2秒后自动消失定时器
    _defaultImgTimer = [NSTimer scheduledTimerWithTimeInterval:ShowTimeLimit
                                                         target:self
                                                       selector:@selector(dismiss)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)removeForRoot {
    if (_defaultImgTimer) {
        [_defaultImgTimer invalidate];
        _defaultImgTimer = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self dismiss];
}

/**
 * 切换显示广告视图
 *
 * @param portrait  广告竖屏图
 * @param landscape 广告横屏图
 * @param interval  广告显示时间，ver=5 添加
 */
- (void)displayWithPortraitADImage:(NSString *)portrait landscapeADImage:(NSString *)landscape interval:(NSTimeInterval)interval {
    
    // 广告位加载网络图片
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:portrait] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            if (_delegateFlags.delegateDidDisplayed) {
                [_splashViewDelegate splashAdViewDidDisplayed:self];
            }
        }
    }];
    
    // 销魂默认定时器
    [_defaultImgTimer invalidate];
    _defaultImgTimer = nil;
    
    _adImageView.alpha = 1.0;
    // 开启开屏广告定时器
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:interval];
}




#pragma mark - inward method
//点击
-(void)tapSplashView {
     
    if (_delegateFlags.delegateDidUserClicked) {
        [_splashViewDelegate splashAdViewDidUserClicked:self];
    }

    [self removeFromSuperview];
    [self dismiss];
}

-(void)dismiss{

    self.excuting = NO;
    
    //检测是否进入主页
    [UIView animateKeyframesWithDuration:0.5f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        if (_delegateFlags.delegateDidDisplayCompleted) {
            [_splashViewDelegate splashAdViewDidDisplayCompleted:self];
        }
        [self resignKeyWindow];
    }];
}



- (void)dealloc{
    _adImageView = nil;
    _adBGImageView = nil;
}

@end

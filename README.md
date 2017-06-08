# BBAD

## Podfile

```

source 'https://github.com/Djw2017/BBNetwork.git'
source 'https://github.com/Djw2017/BBSDK.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'

target 'TargetName' do
pod 'BBAD', :git => 'https://github.com/Djw2017/BBAD.git'
end
```
BBAD依赖于BBNetwork、BBSDK两个私有库，SDWebImage、Masonry两个公共库，并且BBNetwork依赖于AFNetworking，

需要其他广告主时 请导入相应广告库

```
pod 'BBAD/GDT', :git => 'https://github.com/Djw2017/BBAD.git'
pod 'BBAD/IFLY', :git => 'https://github.com/Djw2017/BBAD.git'
```

## 开屏广告

在


	(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

中引入

	#import <BBAD/ADSplashManager.h>

###开启开屏：
```
// 请求测试数据
[ADSplashManager sharedInstance].debugMode = YES;
[ADSplashManager sharedInstance].delegate = self;
[[ADSplashManager sharedInstance] startSplash];
    
```
###规则：
*  没有开屏缓存数据时，是不会显示开屏的，也就是程序第一次启动时是不会有开屏的，每次开屏的数据为上一次请求到服务端的数据。
*  stopSplash只对自家广告有效，因为广点通等广告主的开屏广告不提供提前停止API。
*  内部会自动请求服务端开屏数据。
*  各第三方广告主广告appkey、placementId目前放入库内，根据初始化的页面会自动匹配。


## 原生广告

    #import <BBAD/ADNativeManager.h>

###开启原生广告请求
```
_nativeManger = [[ADNativeManager alloc] initWithPage:ADPageTopicDetailVC];
_nativeManger.delegate = self;
[_nativeManger startRequest];

```

###界面消失时需要取消代理
    _nativeManger.delegate = nil;
###规则:
* 除特殊情况的广告主外，每次一律默认拉取5条广告数据。
* 代理

```
- (void)nativeAdWithManager:(ADNativeManager *)nativeAd didReceiveContent:(NSMutableArray<ADNativeContent *>*)contentMAry。
```
可能重复调用多次。根据child_page决定，因为每个child_page可能会有不一样的广告主。</br>
每调用一次，contentMAry为新的数据数组
在代理中必须添加

    [_nativeManger attachNativeAd:contentMAry[0] toView:self.view]

代码。


* 每次点击原生广告 需要调用

```
	- (void)clickNativeAd:(nonnull ADNativeContent *)nativeContent
```
其中nativeContent为请求到的广告数据，所以你需要区分目前点击的是哪个原生广告。
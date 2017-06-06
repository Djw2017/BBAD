//
//  AppDelegate.h
//  BBAD
//
//  Created by Dongjw on 17/5/23.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ADSplashManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,ADSplashDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIViewController *viewController;

@end


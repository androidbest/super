//
//  AddressTabbar.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-11.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
@interface AddressTabbar : UITabBarController
@property (strong ,nonatomic)HomeView *homeView;
+ (CAAnimation *)animationTransitionFade;
@end

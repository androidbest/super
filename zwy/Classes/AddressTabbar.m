//
//  AddressTabbar.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-11.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "AddressTabbar.h"
#import "GroupAddressView.h"
#import "MassTextingView.h"
@interface AddressTabbar ()

@end

@implementation AddressTabbar

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecode{
//    self =[super initWithCoder:aDecode];
//    if (self) {
//
//    }
//    return self;
//}

+ (CAAnimation *)animationTransitionFade{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30f;         /* 间隔时间*/
    transition.type = @"moveIn"; /* 各种动画效果*/
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
    transition.repeatCount=1;//动画次数
    transition.autoreverses = NO;						//动画是否回复
    //@"cube" @"moveIn" @"reveal" @"fade"(default)/淡化/   @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    transition.subtype = kCATransitionFromRight;   /* 动画方向*/
    return transition;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
  
}

- (void)selectedTab:(UIButton *)btnBar{
    if (btnBar.tag==3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MassTextingView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"MassTextingView"];
        CAAnimation *animation =[AddressTabbar animationTransitionFade];
        [detaView.view.layer addAnimation:animation forKey:@"animationTransitionFade"];
        [self addChildViewController:detaView];
        [detaView didMoveToParentViewController:self];
        [self.view addSubview:detaView.view];
        detaView.view.frame=self.view.frame;
        return;
    }
    if (btnBar.tag==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAddressCallKeyboard"
                                                            object:btnBar];
    }
    self.selectedIndex=btnBar.tag;
}

- (void)viewWillAppear:(BOOL)animated{
self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (int i=0; i<4 ;i++) {
        UIButton * btnBar =[UIButton buttonWithType:UIButtonTypeCustom];
        btnBar.frame =CGRectMake((ScreenWidth/4)*i, 0, (ScreenWidth/4), 49);
        btnBar.tag=i;
        btnBar.backgroundColor=[UIColor clearColor];
        [btnBar addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btnBar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAddressCallKeyboard"
                                                        object:item];
}
@end

//
//  BaseTabbar.m
//  zwy
//
//  Created by cqsxit on 13-12-10.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseTabbar.h"
#import "AddressTabbar.h"
#import "HomeView.h"
@interface BaseTabbar ()

@end

@implementation BaseTabbar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i=0; i<4 ;i++) {
        UIButton * btnBar =[UIButton buttonWithType:UIButtonTypeCustom];
        btnBar.frame =CGRectMake((ScreenWidth/4)*i, 0, (ScreenWidth/4), 49);
        btnBar.tag=i;
        btnBar.backgroundColor=[UIColor clearColor];
        [btnBar addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:btnBar];
    }
    self.selectedIndex=2;
	// Do any additional setup after loading the view. tabbarStroy
}

- (void)selectedTab:(UIButton *)btnBar{
    if (btnBar.tag==0) {
        for (UIViewController *viewController in self.viewControllers) {
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController =(UINavigationController*)viewController;
                    if ([navigationController.topViewController isKindOfClass:[HomeView class]]) {
                        [(HomeView *)navigationController.topViewController HomeToAddressBookView];
                    }
        
            }
        }
        return;
    }

    self.selectedIndex=btnBar.tag;
}

- (void)TabbarScrollEnabled:(BOOL)Enabled{
   self.TabbarScrollView.scrollEnabled=Enabled;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

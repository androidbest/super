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
	// Do any additional setup after loading the view. tabbarStroy
}

/*
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
*/
- (void)TabbarScrollEnabled:(BOOL)Enabled{
   self.TabbarScrollView.scrollEnabled=Enabled;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

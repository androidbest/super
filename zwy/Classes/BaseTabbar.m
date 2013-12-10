//
//  BaseTabbar.m
//  zwy
//
//  Created by cqsxit on 13-12-10.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseTabbar.h"

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
    
	// Do any additional setup after loading the view.
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

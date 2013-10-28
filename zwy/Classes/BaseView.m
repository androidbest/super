//
//  BaseView.m
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()

@end

@implementation BaseView

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

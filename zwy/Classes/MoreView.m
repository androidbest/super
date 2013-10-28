//
//  MoreView.m
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MoreView.h"
#import "MoreController.h"
@interface MoreView ()

@end

@implementation MoreView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"更多" image:[UIImage imageNamed:@"more_out"] selectedImage:[UIImage imageNamed:@"more_over"]];
        
        MoreController *more=[MoreController new];
        more.moreView=self;
        self.controller=more;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_moreListView.delegate=self.controller;
    _moreListView.dataSource=self.controller;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MyInfoView.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MyInfoView.h"
#import "MyInfoController.h"
#import "Constants.h"
@interface MyInfoView ()

@end

@implementation MyInfoView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
//        self.tabBarItem=[self.tabBarItem initWithTitle:@"我" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MyInfoController *myinfo=[MyInfoController new];
        myinfo.myInfoView=self;
        self.controller=myinfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tableview.delegate=self.controller;
    _tableview.dataSource=self.controller;
}

-(void)viewWillAppear:(BOOL)animated{
self.tabBarController.navigationItem.title=user.username;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

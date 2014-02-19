//
//  GroupAddressView.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-9.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "GroupAddressView.h"
#import "GroupAddressController.h"
#import "Constants.h"
@interface GroupAddressView ()

@end

//单位通讯录
@implementation GroupAddressView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        GroupAddressController * contro =[GroupAddressController new];
        contro.grougView=self;
        self.controller=contro;
         self.tabBarItem=[self.tabBarItem initWithTitle:@"单位通讯录" image:[UIImage imageNamed:@"tabItem_groupArBook_out"] selectedImage:[UIImage imageNamed:@"tabItem_groupArBook_over"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewGroup.dataSource=self.controller;
    _tableViewGroup.delegate=self.controller;
    _searchBar.delegate=self.controller;
    [self.controller initWithData];
    self.navigationItem.title=user.ecname;
    
     self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.controller action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    [rightBtn setImage:[UIImage imageNamed:@"navigation_updata_over"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navigation_updata_out"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self.controller action:@selector(rightDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem =rightItem;
}
///

- (void)LeftDown{

}


- (void)rightDown{

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationItem.title=user.ecname;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

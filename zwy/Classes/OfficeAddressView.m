//
//  OfficeAddressView.m
//  zwy
//
//  Created by cqsxit on 13-10-20.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "OfficeAddressView.h"
#import "OfficeAddressController.h"
@interface OfficeAddressView ()

@end

@implementation OfficeAddressView

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
        OfficeAddressController * contro =[OfficeAddressController new];
        self.controller=contro;
        contro.officeView=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * view =[[UIView alloc] init];
    view.frame =CGRectMake(0, 0, ScreenWidth, 40);
    view.backgroundColor =self.navigationItem.titleView.backgroundColor;
    self.navigationItem.titleView=view;
     NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"部门",@"人员",nil];
     UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
     segmentedControl.frame =CGRectMake(0.0,5.0,230.0,30.0);
    [segmentedControl addTarget:self.controller action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    self.segmentedControl=segmentedControl;
    [view addSubview:_segmentedControl];
    
    [_btnAll addTarget:self.controller action:@selector(btnAll) forControlEvents:UIControlEventTouchUpInside];
    [_btnCencel addTarget:self.controller action:@selector(btnCencel) forControlEvents:UIControlEventTouchUpInside];
    [_btnConfirmation addTarget:self.controller action:@selector(btnConfirmation) forControlEvents:UIControlEventTouchUpInside];
    [_btnSuperior addTarget:self.controller action:@selector(btnSuperior) forControlEvents:UIControlEventTouchUpInside];
    _btnSuperior.enabled=NO;
    [_searchBar setDelegate:self.controller];
    
    self.tableViewGroup =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 64+44, ScreenWidth,ScreenHeight-64-49-44) withDelegate:self.controller];
    _tableViewGroup.dataSource=self.controller;
    _tableViewGroup.delegate=self.controller;
    _tableViewGroup.separatorStyle = NO;
    _tableViewGroup.tag=0;
    [self.view addSubview:_tableViewGroup];
    [_tableViewGroup LoadDataBegin];
    
    self.tableViewPeople =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 64+44, ScreenWidth,ScreenHeight-64-49-44) withDelegate:self.controller];
    self.tableViewPeople.dataSource=self.controller;
    self.tableViewPeople.delegate=self.controller;
    _tableViewPeople.separatorStyle = NO;
    [self.view addSubview:_tableViewPeople];
    _tableViewPeople.separatorStyle=NO;
    _tableViewPeople.tag=1;
    self.tableViewPeople.hidden=YES;
    [_tableViewPeople LoadDataBegin];
}

- (void)segmentedControl:(id)sender{

}
- (void)returnDidAddress:(NSArray *)arr{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

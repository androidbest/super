//
//  MailAddressView.m
//  zwy
//
//  Created by cqsxit on 13-10-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MailAddressView.h"
#import "MailAddressController.h"

@interface MailAddressView ()

@end

@implementation MailAddressView


- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        MailAddressController * contro =[MailAddressController new];
        contro.mailView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewPeople=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, ScreenWidth, ScreenHeight-64-44-74) style:UITableViewStylePlain];
    self.tableViewPeople.dataSource=self.controller;
    self.tableViewPeople.delegate =self.controller;
    [self.view addSubview:_tableViewPeople];
    
    [_serchBar setDelegate:self.controller];
    [_btnAffirm addTarget:self.controller action:@selector(btnAffirm) forControlEvents:UIControlEventTouchUpInside];
    _btnAffirm.layer.masksToBounds = YES;
    _btnAffirm.layer.cornerRadius = 6.0;

	// Do any additional setup after loading the view.
    
}

- (void)returnDidAddress:( PeopelInfo*)deta{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

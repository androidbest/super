//
//  MassMyAddressView.m
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassMyAddressView.h"
#import "MassMyaddressController.h"
@interface MassMyAddressView ()

@end


//短信群发选择通讯录联第人
@implementation MassMyAddressView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        MassMyaddressController  *contro =[MassMyaddressController new];
        contro.massView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.title=@"本地通讯录";
        self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [_btnAll addTarget:self.controller action:@selector(btnAll:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCencel addTarget:self.controller action:@selector(btnCencel:) forControlEvents:UIControlEventTouchUpInside];
    [_btnConfirm addTarget:self.controller action:@selector(btnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [_btnReturn addTarget:self.controller action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    self.tableViewAddress.delegate=self.controller;
    self.tableViewAddress.dataSource=self.controller;
    self.searchBar.delegate=self.controller;
    [self.controller initWithData];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.controller action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
	// Do any additional setup after loading the view.
}

- (void)LeftDown{
    
}

- (void)btnAll:(id)sender{
    
}

- (void)btnCencel:(id)sender{
    
}

- (void)btnConfirm:(id)sender{
    
}

- (void)btnReturn:(id)sender{
    
}

- (void)returnDidAddress:(NSArray *)arr{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

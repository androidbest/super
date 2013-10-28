//
//  optionAddress.m
//  zwy
//
//  Created by cqsxit on 13-10-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "optionAddress.h"
#import "OptionAddressController.h"
@interface optionAddress ()

@end

@implementation optionAddress

-  (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        OptionAddressController *contro=[[OptionAddressController alloc] init];
        contro.OptionView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"选择联系人";
    
    [_btnAll addTarget:self.controller action:@selector(btnAll:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCencel addTarget:self.controller action:@selector(btnCencel:) forControlEvents:UIControlEventTouchUpInside];
    [_btnConfirm addTarget:self.controller action:@selector(btnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [_btnReturn addTarget:self.controller action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
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
    [_btnBack addTarget:self.controller action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    
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

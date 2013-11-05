//
//  AccountManager.m
//  zwy
//
//  Created by wangshuang on 10/20/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "AccountManager.h"
#import "AccountManagerController.h"
@interface AccountManager ()

@end

@implementation AccountManager

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){        
        AccountManagerController *more=[AccountManagerController new];
        more.account=self;
        self.controller=more;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
	_accountList.delegate=self.controller;
    _accountList.dataSource=self.controller;
    
    [((AccountManagerController *)self.controller) startCell];
    
    [_logout addTarget:self.controller action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    _logout.layer.masksToBounds = YES;
    _logout.layer.cornerRadius = 6.0;
    _logout.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [_logout addTarget:self.controller action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)loginout{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

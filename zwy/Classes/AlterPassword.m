//
//  AlterPassword.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AlterPassword.h"
#import "AlterPasswordController.h"
@interface AlterPassword ()

@end

@implementation AlterPassword

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
        AlterPasswordController * contro =[AlterPasswordController new];
        self.controller =contro;
        contro.alterView=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_btnOK addTarget:self.controller action:@selector(btnOK) forControlEvents:UIControlEventTouchUpInside];
    _btnOK.layer.masksToBounds = YES;
    _btnOK.layer.cornerRadius = 6.0;
    
    [_textBeforePw setDelegate:self.controller];
    _textBeforePw.secureTextEntry=YES;
    
    [_textLastPw setDelegate:self.controller];
    _textLastPw.secureTextEntry=YES;
    
    [_textNewPw setDelegate:self.controller];
    _textNewPw.secureTextEntry=YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  AddPeopleBookView.m
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AddPeopleBookView.h"
#import "AddPeopleBookController.h"
@interface AddPeopleBookView ()

@end

@implementation AddPeopleBookView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        AddPeopleBookController *contro=[AddPeopleBookController new];
        contro.addView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textTel.keyboardType=UIKeyboardTypeNumberPad;
    _textTel.delegate=self.controller;
    [_btnSave addTarget:self.controller action:@selector(btnSave) forControlEvents:UIControlEventTouchUpInside];
    _btnSave.layer.masksToBounds = YES;
    _btnSave.layer.cornerRadius = 5.0;
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

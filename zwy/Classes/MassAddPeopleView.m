//
//  MassAddPeopleView.m
//  zwy
//
//  Created by cqsxit on 13-10-23.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassAddPeopleView.h"
#import "MassAddPeopleController.h"

@interface MassAddPeopleView ()

@end

@implementation MassAddPeopleView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        MassAddPeopleController *contro=[MassAddPeopleController new];
        contro.massAddView=self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"添加号码";
    [_btnAffirm addTarget:self.controller action:@selector(btnAffirm) forControlEvents:UIControlEventTouchUpInside];
    _btnAffirm.layer.masksToBounds = YES;
    _btnAffirm.layer.cornerRadius = 5.0;
    
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_textTel setDelegate:self.controller];
    _textTel.keyboardType=UIKeyboardTypePhonePad;	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)returnDidAddress:(NSArray *)arr{

}
@end

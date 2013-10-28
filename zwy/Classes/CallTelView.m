//
//  CallTelView.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "CallTelView.h"
#import "CallTelController.h"
#import "AddressTabbar.h"
@interface CallTelView ()

@end

@implementation CallTelView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
         self.tabBarItem=[self.tabBarItem initWithTitle:@"拨号" image:[UIImage imageNamed:@"tabItem_call_over"] selectedImage:[UIImage imageNamed:@"tabItem_call_out"]];
        
        CallTelController * contro =[CallTelController new];
        contro.callView =self;
        self.controller=contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.tabBarItem=[self.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
    [_btNumber0 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber1 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber2 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber3 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber4 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber5 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber6 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber7 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber8 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber9 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber100 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btNumber1000 addTarget:self.controller action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_btnHidden addTarget:self.controller action:@selector(btnHidden) forControlEvents:UIControlEventTouchUpInside];
    [_btncancel addTarget:self.controller action:@selector(btncancel) forControlEvents:UIControlEventTouchUpInside];
    _tableViewPeople.dataSource=self.controller;
    _tableViewPeople.delegate=self.controller;
	// Do any additional setup after loading the view.
    [self.controller initWithData];
    _labelCall.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(btnBigImageView:)];
    [_labelCall addGestureRecognizer:tap];
    
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
       [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
       [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
       [backButton addTarget:self action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;

}
- (void)btnBigImageView:(UITapGestureRecognizer *)tap{

}
-(void)inputNumber:(UIButton *)sender{

}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =_keyboradView.frame;
        rect.origin.y=self.tabBarController.tabBar.frame.origin.y-rect.size.height-64;
        _keyboradView.frame=rect;
    }];
}

- (void)LeftDown{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  EcOptionView.m
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "EcOptionView.h"
#import "EcOptionController.h"
@interface EcOptionView ()

@end

@implementation EcOptionView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        EcOptionController *more=[EcOptionController new];
        more.ecOptionView=self;
        self.controller=more;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//初使化数据
    [self.controller initData:self];
    _EcList.dataSource=self.controller;
    _EcList.delegate=self.controller;
    
    //状态栏颜色
    [_statusBar setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    
    //请求单位信息
    [(EcOptionController *)self.controller getEc];
    
    [_ok setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _ok.layer.masksToBounds = YES;
    _ok.layer.cornerRadius = 6.0;
    _ok.layer.borderWidth = 0.5;
    _ok.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_ok addTarget:self.controller action:@selector(selectOk) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectOk{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

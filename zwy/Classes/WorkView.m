//
//  WorkView.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "WorkView.h"
#import "WorkController.h"
#import "DetailTextView.h"
@interface WorkView ()

@end

@implementation WorkView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        WorkController *contro =[WorkController new];
        self.controller=contro;
        contro.workViews=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightButton  =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self.controller action:@selector(btnEditing)];
    self.navigationItem.rightBarButtonItem=rightButton;
	
    _dayBackgroudView1 =[[UIView alloc] initWithFrame:CGRectMake(126, 54, 60, 35)];
    _dayBackgroudView1.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _dayBackgroudView1.layer.zPosition=-1;
    /*添加阴影*/
    _dayBackgroudView1.layer.shadowColor = [UIColor blackColor].CGColor;
    _dayBackgroudView1.layer.shadowOffset = CGSizeMake(0, 0);//阴影偏移角度
    _dayBackgroudView1.layer.shadowOpacity = 0.5;//阴影透明度
    _dayBackgroudView1.layer.shadowRadius = 1.0;//阴影扩散强度
    /*添加边框*/
//    _dayBackgroudView1.layer.borderWidth = 1;
//    _dayBackgroudView1.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.wariningBackView addSubview:_dayBackgroudView1];
    
    _dayBackgroudView2 =[[UIView alloc] initWithFrame:CGRectMake(126, 94, 60, 35)];
    _dayBackgroudView2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _dayBackgroudView2.layer.zPosition=-2;
    /*添加阴影*/
    _dayBackgroudView2.layer.shadowColor = [UIColor blackColor].CGColor;
    _dayBackgroudView2.layer.shadowOffset = CGSizeMake(0, 0);
    _dayBackgroudView2.layer.shadowOpacity = 0.5;
    _dayBackgroudView2.layer.shadowRadius = 1.0;
    /*添加边框*/
//    _dayBackgroudView2.layer.borderWidth = 1;
//    _dayBackgroudView2.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.wariningBackView addSubview:_dayBackgroudView2];
    
    [self.controller initWithData];

}

- (void)btnEditing{
    
}
- (void)upDataScheduleList:(int)TableViewType{

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

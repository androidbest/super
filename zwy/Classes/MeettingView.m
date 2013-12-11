//
//  MeettingView.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MeettingView.h"
#import "MeettingController.h"
@interface MeettingView ()

@end

@implementation MeettingView{
    BOOL isStart;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        isStart=YES;
        MeettingController *meetting=[MeettingController new];
        meetting.meettingView=self;
        self.controller=meetting;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //返回按钮
    self.navigationItem.leftBarButtonItem=self.temporaryBarButtonItem;
    
    //初使化数据
    [_btnCheck addTarget:self.controller action:@selector(btnCheck) forControlEvents:UIControlEventTouchUpInside];
    _btnCheck.layer.masksToBounds = YES;
    _btnCheck.layer.cornerRadius = 5.0;
    
    [_btnDate addTarget:self.controller action:@selector(btnDate) forControlEvents:UIControlEventTouchUpInside];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * dateText = [formatter stringFromDate:[NSDate date]];
    [_btnDate setTitle:dateText forState:UIControlStateNormal];
    _btnDate.hidden=YES;
    
    [_btnTime addTarget:self.controller action:@selector(btnTime) forControlEvents:UIControlEventTouchUpInside];
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"HH:mm"];
    NSString * timeText = [formatterTime stringFromDate:[NSDate date]];
    [_btnTime setTitle:timeText forState:UIControlStateNormal];
    _btnTime.hidden=YES;
    
    [_segControl addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    _meetting_date.hidden=YES;
    _meetting_time.hidden=YES;
    _btnTime.hidden=YES;
    _btnDate.hidden=YES;
    _statusLabel.hidden=YES;
    
    _reciver=[[UILabel alloc] initWithFrame:CGRectMake(20,129,56,21)];
    _reciver.font=[UIFont systemFontOfSize:16];
    _reciver.textAlignment=NSTextAlignmentLeft;
    _reciver.backgroundColor=[UIColor clearColor];
    _reciver.text=@"接收人:";
    
    _btnAddpeople=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnAddpeople.frame =CGRectMake(279, 124, 32, 31);
    [_btnAddpeople setImage:[UIImage imageNamed:@"btn_addPeople"] forState:UIControlStateNormal];
    [_btnAddpeople addTarget:self.controller action:@selector(btnAddpeople) forControlEvents:UIControlEventTouchUpInside];
    [_btnAddpeople setImageEdgeInsets:UIEdgeInsetsMake(3,0,2,5)];
   
    
    if(iPhone5){
        _tableViewPeople=[[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, 320) style:UITableViewStylePlain];
        _tableViewPeople.delegate=self.controller;
        _tableViewPeople.dataSource=self.controller;
        
    }else{
        _tableViewPeople=[[UITableView alloc] initWithFrame:CGRectMake(0, 170, 320, 250) style:UITableViewStylePlain];
        _tableViewPeople.delegate=self.controller;
        _tableViewPeople.dataSource=self.controller;
    }
    
    [self.view addSubview:_tableViewPeople];
    [self.view addSubview:_reciver];
    [self.view addSubview:_btnAddpeople];
    
    
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//    [formatter1 setDateFormat:@"yyyy/MM/dd HH:mm"];
//    NSString * dateText1 = [formatter1 stringFromDate:[NSDate date]];
//    _atonce_time.text=dateText1;
//    
//    _nsTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
}

- (void)backButtonToHome{
    if (!self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) self.navigationController.navigationBarHidden=NO;
}


- (void)segmentAction:(id)sender{
    
}

- (void)dateChanged{

}


- (void)viewDidAppear:(BOOL)animated{

}


- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if ([((MeettingController *)self.controller).MeetType isEqualToString:@"0"]){
//        CGRect rect=_viewPeople.frame;
//        rect.origin.y-=60;
//        rect.size.height+=60;
//        _viewPeople.frame=rect;
//        
//        CGRect tableview=_tableViewPeople.frame;
//        tableview.size.height+=60;
//        _tableViewPeople.frame=tableview;
//        [self performSelector:@selector(setTaleViewframe) withObject:self afterDelay:0.0];
//    }
}

- (void)setTaleViewframe{
//    CGRect tableview=_tableViewPeople.frame;
//    tableview.size.height+=60;
//    _tableViewPeople.frame=tableview;
}


- (void)viewWillLayoutSubviews{
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dissmissFromHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

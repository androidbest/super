//
//  NewsScheduleView.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "NewsScheduleView.h"
#import "DateSwitchView.h"
#import "NewsScheduleController.h"
@interface NewsScheduleView ()

@end

@implementation NewsScheduleView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self  =[super initWithCoder:aDecoder];
    if (self) {
        NewsScheduleController *contro =[NewsScheduleController new];
        self.controller=contro;
        contro.newsView=self;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    for (UINavigationItem * item in self.navigationBarNews.items) {
        if (_strTitle) item.title=_strTitle;
    }
    [_btnBack addTarget:self.controller action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave addTarget:self.controller action:@selector(btnSave) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addTarget:self.controller action:@selector(btnCancel) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel.layer.masksToBounds = YES;
    _btnCancel.layer.cornerRadius = 5.0;
    [_btnClass addTarget:self.controller action:@selector(btnClass) forControlEvents:UIControlEventTouchUpInside];
    [_btnOptionTime addTarget:self.controller action:@selector(btnOptionTime) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnFirst addTarget:self.controller action:@selector(btnFirst:) forControlEvents:UIControlEventTouchUpInside];
    [_switchReqeat addTarget:self.controller action:@selector(switchReqeat:) forControlEvents:UIControlEventTouchUpInside];

    _swithTimeType=[[SevenSwitch alloc] initWithFrame:CGRectMake(240,129,60,31)];
    _swithTimeType.onColor =[UIColor colorWithRed:0.25 green:0.59 blue:1.0 alpha:1.0];
    _swithTimeType.onTitle =@"公历";
    _swithTimeType.offTitle=@"农历";
    _swithTimeType.on=YES;
    [_swithTimeType addTarget:self.controller action:@selector(swithTimeType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_swithTimeType];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *Date = [formatter stringFromDate:[NSDate date]];
    [_btnOptionTime setTitle:Date forState:UIControlStateNormal];
    
    [self.controller initWithData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textTitle resignFirstResponder];
}

- (void)btnFirst:(UISwitch *)sender{

}


- (void)switchReqeat:(UISwitch *)sender{
    
}

- (void)switchTime:(UISwitch *)sender{
    
}

- (void)swithTimeType:(SevenSwitch *)sender {
}

- (void)updataWarning:(warningDataInfo *)info{

}

- (void)deleteWarning:(NewsScheduleView *)newsView{

}
- (void)upDataScheduleList:(int)TableViewType{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  NoticeView.m
//  zwy
//
//  Created by wangshuang on 10/11/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "NoticeView.h"
#import "NoticeController.h"
#import "PullRefreshTableView.h"
@interface NoticeView ()

@end

@implementation NoticeView{

}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    if(self){
        NoticeController *notice=[NoticeController new];
        notice.noticeView=self;
        self.controller=notice;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listview =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout, ScreenWidth,ScreenHeight-topLayout) withDelegate:self.controller];
    self.listview.backgroundColor=[UIColor whiteColor];
//    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview.separatorStyle = NO;
    [self.view addSubview:self.listview];
    [self.listview LoadDataBegin];/*刷新数据*/
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    [send setValue:self forKey:@"data"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

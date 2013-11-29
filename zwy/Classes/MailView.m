//
//  MailView.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MailView.h"
#import "MailController.h"
#import "MailDetail.h"
@interface MailView ()

@end

@implementation MailView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        MailController *mail=[MailController new];
        mail.mailView=self;
        self.controller=mail;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_selecter addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
         self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.listview =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview.tag=0;
    self.listview.separatorStyle = NO;
    [self.view addSubview:self.listview];
    [self.listview LoadDataBegin];/*刷新数据*/
    
    self.listview1 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview1.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview1.tag=1;
    self.listview1.separatorStyle = NO;
    [self.view addSubview:self.listview1];
    self.listview1.hidden=YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    MailDetail * detail =(MailDetail *)send;
    detail.MailDelegate=self.controller;
    [send setValue:self forKey:@"data"];
}

-(void)segmentAction:(UISegmentedControl *)Seg{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dissmissFromHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

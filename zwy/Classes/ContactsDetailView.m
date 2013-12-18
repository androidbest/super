//
//  ContactsDetailView.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsDetailView.h"
#import "ContactsDetailController.h"
#import "HTTPRequest.h"
@interface ContactsDetailView ()

@end

@implementation ContactsDetailView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        ContactsDetailController *contacts=[ContactsDetailController new];
        contacts.contactsDetailView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _username.text=_data.Name;
    _msisdn.text=_data.tel;
    _department.text=_data.area;
    [HTTPRequest imageWithURL:_data.headPath imageView:_imageView placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    if([_data.job isEqualToString:@"null"]){
     _job.text=@"未分配";
    }else{
     _job.text=_data.job;
    }
    
    [_sumbitBtn setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _sumbitBtn.layer.masksToBounds = YES;
    _sumbitBtn.layer.cornerRadius = 6.0;
//    _sumbitBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
   
    [_sumbitBtn addTarget:self.controller action:NSSelectorFromString(@"submit") forControlEvents:UIControlEventTouchUpInside];
    [_call addTarget:self.controller action:NSSelectorFromString(@"callTell") forControlEvents:UIControlEventTouchUpInside];
    [_sms addTarget:self.controller action:NSSelectorFromString(@"smsSend") forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //将page2设定成Storyboard Segue的目标UIViewController
    id page2 = segue.destinationViewController;
    //将值透过Storyboard Segue带给页面2的string变数
    [page2 setValue:_data forKey:@"chat"];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=_data.Name;
}

@end

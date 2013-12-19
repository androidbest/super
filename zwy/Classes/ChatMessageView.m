//
//  ChatMessageView.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ChatMessageView.h"
#import "ChatMessageController.h"
@interface ChatMessageView ()

@end

@implementation ChatMessageView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        ChatMessageController *contacts=[ChatMessageController new];
        contacts.chatMessageView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_send setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _send.layer.masksToBounds = YES;
    _send.layer.cornerRadius = 6.0;
    
    _toolbar.layer.borderWidth=0.5;
    _toolbar.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    _im_text.layer.masksToBounds=YES;
    _im_text.layer.cornerRadius=6.0;
    _im_text.layer.borderWidth=0.5;
    _im_text.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=_chatData.Name;
}

@end

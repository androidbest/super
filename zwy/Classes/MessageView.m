//
//  MessageView.m
//  zwy
//
//  Created by wangshuang on 12/9/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageView.h"
#import "MessageController.h"
@interface MessageView ()

@end

@implementation MessageView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MessageController *message=[MessageController new];
        message.messageView=self;
        self.controller=message;
        
     }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	 
}

-(void)viewWillAppear:(BOOL)animated{
self.tabBarController.navigationItem.title=@"最近联系人";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

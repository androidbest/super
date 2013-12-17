//
//  ContactsDetailView.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsDetailView.h"
#import "ContactsDetailController.h"
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
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

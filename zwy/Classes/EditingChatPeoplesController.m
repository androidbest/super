//
//  EditingChatPeoplesController.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "EditingChatPeoplesController.h"
#import "PeopelInfo.h"
#import "PhotoButton.h"
#import "OptionChatPeopleView.h"
@implementation EditingChatPeoplesController
{
    BOOL isDelete;
}
- (id)init{
    self =[super init];
    if (self) {
        isDelete=NO;
    }
    return self;
}


- (void)initWithData{
    if (_editingView.chatView.arrPeoples) {
        [_editingView.chatView.arrPeoples addObject:@"10000"];
        [_editingView.chatView.arrPeoples addObject:@"10001"];
    }
    [self updatePeoples];
}

- (void)updatePeoples{
    int widthIndex=4;
    int lineIndex=0;
    float imageHeadSize=55;
    float imageInterval=20;
    
    for (int i=0; i<_editingView.chatView.arrPeoples.count/widthIndex; i++) {
        for (int j=0; j<widthIndex; j++) {
            int btnTag=lineIndex*widthIndex+j;
            PhotoButton *btn=[PhotoButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((imageHeadSize+imageInterval)*j+imageInterval, imageInterval+(imageHeadSize+imageInterval)*lineIndex, imageHeadSize, imageHeadSize);
            [self.editingView.view  addSubview:btn];
            
            NSObject *obj =_editingView.chatView.arrPeoples[btnTag];
            if ([obj isEqual:@"10000"]) {
                btn.layerBubble.hidden=YES;
                btn.tag=10000;
                [btn setBackgroundColor:[UIColor brownColor]];
                [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
            }else if([obj isEqual:@"10001"]){
                btn.layerBubble.hidden=YES;
                btn.tag=10001;
                [btn setBackgroundColor:[UIColor redColor]];
                [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btn setBackgroundColor:[UIColor greenColor]];
                btn.tag=btnTag;
                btn.layerBubble.hidden=!isDelete;
                [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        lineIndex++;
    }
    
    ///////////////////////////////////
    for (int i=0; i<_editingView.chatView.arrPeoples.count%widthIndex; i++) {
        int btnTag=lineIndex*widthIndex+i;
        NSObject *obj =_editingView.chatView.arrPeoples[btnTag];
        PhotoButton *btn=[PhotoButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((imageHeadSize+imageInterval)*i+imageInterval, imageInterval+(imageHeadSize+imageInterval)*lineIndex, imageHeadSize, imageHeadSize);
        [self.editingView.view  addSubview:btn];
        
        if ([obj isEqual:@"10000"]) {
            btn.layerBubble.hidden=YES;
            btn.tag=10000;
            [btn setBackgroundColor:[UIColor brownColor]];
            [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
        }else if([obj isEqual:@"10001"]){
            btn.layerBubble.hidden=YES;
            btn.tag=10001;
            [btn setBackgroundColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [btn setBackgroundColor:[UIColor greenColor]];
            btn.tag=btnTag;
            btn.layerBubble.hidden=!isDelete;
            [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 按钮

//添加
- (void)btnAddpeople:(PhotoButton *)sender{
    [self.editingView performSegueWithIdentifier:@"EditingChatViewToOptionView" sender:nil];
}

//删除
- (void)btnDeletePeople:(PhotoButton *)sender{
    if (isDelete) {
        isDelete=NO;
    }else{
        isDelete=YES;
    }
    for (UIView *view in _editingView.view.subviews) {
        if ([view isKindOfClass:[PhotoButton class]]) {
            PhotoButton *btn =(PhotoButton *)view;
            if(btn.tag==10000||btn.tag==10001)btn.layerBubble.hidden=YES;
            else btn.layerBubble.hidden=!isDelete;
        }
    }
}

//点击对应头像
- (void)btnPeopleHead:(PhotoButton *)sender{
    if (isDelete) {
        [_editingView.chatView.arrPeoples removeObjectAtIndex:sender.tag];
        for (UIView *view in _editingView.view.subviews) {
            if ([view isKindOfClass:[PhotoButton class]]) {
                [view removeFromSuperview];
            }
        }
        [self updatePeoples];
    }else{
        
    }
}

- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EditingChatViewToOptionView"]) {
        OptionChatPeopleView *optionView=[OptionChatPeopleView new];
        optionView.OptionChatPeopleDelegate =self;
    }
}

@end

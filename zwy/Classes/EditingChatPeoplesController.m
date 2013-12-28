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

//退出群组
- (void)btnRemove{
    [_editingView.chatView.arrPeoples removeAllObjects];
    _editingView.chatView.arrPeoples=nil;
    
    [self.editingView.navigationController popViewControllerAnimated:YES];
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
            [self.editingView.scrollView  addSubview:btn];
            
            NSObject *obj =_editingView.chatView.arrPeoples[btnTag];
            if ([obj isEqual:@"10000"]) {
                btn.layerBubble.hidden=YES;
                btn.tag=10000;
                [btn setBackgroundImage:[UIImage imageNamed:@"im_head"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
            }else if([obj isEqual:@"10001"]){
                btn.layerBubble.hidden=YES;
                btn.tag=10001;
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_clear_people"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                btn.tag=btnTag;
                btn.layerBubble.hidden=!isDelete;
                [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
                PeopelInfo *info =_editingView.chatView.arrPeoples[btnTag];
                [HTTPRequest setImageWithURL:info.headPath placeholderImage:[UIImage imageNamed:@"default_avatar"] ImageBolck:^(UIImage *image) {
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                }];
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
        [self.editingView.scrollView  addSubview:btn];
        
        if ([obj isEqual:@"10000"]) {
            btn.layerBubble.hidden=YES;
            btn.tag=10000;
             [btn setBackgroundImage:[UIImage imageNamed:@"im_head"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
        }else if([obj isEqual:@"10001"]){
            btn.layerBubble.hidden=YES;
            btn.tag=10001;
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_clear_people"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            btn.tag=btnTag;
            btn.layerBubble.hidden=!isDelete;
            [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
            PeopelInfo *info =_editingView.chatView.arrPeoples[btnTag];
            [HTTPRequest setImageWithURL:info.headPath placeholderImage:[UIImage imageNamed:@"default_avatar"] ImageBolck:^(UIImage *image) {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    }
    
    if (_editingView.chatView.arrPeoples.count%widthIndex==0) {
        [self.editingView.scrollView setContentSize:CGSizeMake(320, lineIndex*(imageHeadSize+imageInterval))];
    }else{
        [self.editingView.scrollView setContentSize:CGSizeMake(320, (lineIndex+1)*(imageHeadSize+imageInterval))];
    }
    
}

#pragma mark - 按钮

//添加
- (void)btnAddpeople:(PhotoButton *)sender{
    [self.editingView performSegueWithIdentifier:@"EditingChatViewToOptionView" sender:nil];
}

- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EditingChatViewToOptionView"]) {
        UINavigationController *navigation =segue.destinationViewController;
        OptionChatPeopleView *optionView=(OptionChatPeopleView*)navigation.topViewController;
        optionView.OptionChatPeopleDelegate=self;
        optionView.ismodeAnimation=YES;
        optionView.arrReqeatePeoples=[[NSArray alloc] initWithArray:_editingView.chatView.arrPeoples];
    }
}

#pragma mark -OptionChatPeopleDelegate
- (void)MessageViewToChatMessageView:(NSArray *)peoples{
    NSIndexSet * indexSet=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_editingView.chatView.arrPeoples.count-2,peoples.count)];
    [_editingView.chatView.arrPeoples insertObjects:peoples atIndexes:indexSet];
    [self updatePeoples];
}

//删除
- (void)btnDeletePeople:(PhotoButton *)sender{
    if (isDelete) {
        isDelete=NO;
    }else{
        isDelete=YES;
    }
    for (UIView *view in _editingView.scrollView.subviews) {
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
        for (UIView *view in _editingView.scrollView.subviews) {
            if ([view isKindOfClass:[PhotoButton class]]) {
                [view removeFromSuperview];
            }
        }
        [self updatePeoples];
    }else{
        
    }
}

@end

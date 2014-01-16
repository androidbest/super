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
#import "CoreDataManageContext.h"
#import "MessageView.h"
@implementation EditingChatPeoplesController
{
    BOOL isDelete;
    NSString *Names;
    NSString *HeadPaths;
    NSString *msisdns;
    
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
    [[CoreDataManageContext newInstance] deleteChatInfoWithChatMessageID:_editingView.chatMessageID];
    NSArray *navArr=self.editingView.navigationController.viewControllers;
    for (UIViewController *nav in navArr)
    {
        if ([nav isKindOfClass:[UITabBarController class]])
        {
            [self.editingView.navigationController popToViewController:nav animated:YES];
        }
    }
}

- (void)updatePeoples{
    int widthIndex=4;
    int lineIndex=0;
    float imageHeadSize=55;
    float imageInterval=20;
    
    Names=nil;
    HeadPaths=nil;
    msisdns=nil;
    
    
    for (int i=0; i<_editingView.chatView.arrPeoples.count/widthIndex; i++) {
        NSLog(@"%d",_editingView.chatView.arrPeoples.count/widthIndex);
        for (int j=0; j<widthIndex; j++) {
            int btnTag=lineIndex*widthIndex+j;
            PhotoButton *btn=[PhotoButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((imageHeadSize+imageInterval)*j+imageInterval, imageInterval+(imageHeadSize+imageInterval)*lineIndex, imageHeadSize, imageHeadSize);
            [self.editingView.scrollView  addSubview:btn];
            
            NSObject *obj =_editingView.chatView.arrPeoples[btnTag];
            if ([obj isEqual:@"10000"]) {
                btn.layerBubble.hidden=YES;
                btn.tag=10000;
                [btn setBackgroundImage:[UIImage imageNamed:@"chat_jiahao"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
            }else if([obj isEqual:@"10001"]){
                btn.layerBubble.hidden=YES;
                btn.tag=10001;
                [btn setBackgroundImage:[UIImage imageNamed:@"chat_jianhao"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                btn.tag=btnTag;
                btn.layerBubble.hidden=!isDelete;
                [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
                PeopelInfo *info =_editingView.chatView.arrPeoples[btnTag];
                btn.labelName.text=info.Name;
                [HTTPRequest setImageWithURL:info.headPath placeholderImage:[UIImage imageNamed:@"default_avatar"] ImageBolck:^(UIImage *image) {
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                }];
                
                if (!Names) Names=info.Name;
                else Names=[NSString stringWithFormat:@"%@,%@",Names,info.Name];
                
                if (!HeadPaths) HeadPaths=info.headPath;
                else HeadPaths=[NSString stringWithFormat:@"%@,%@",HeadPaths,info.headPath];
                
                if (!msisdns) msisdns =info.tel;
                else msisdns=[NSString stringWithFormat:@"%@,%@",msisdns,info.tel];
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
             [btn setBackgroundImage:[UIImage imageNamed:@"chat_jiahao"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAddpeople:) forControlEvents:UIControlEventTouchUpInside];
        }else if([obj isEqual:@"10001"]){
            btn.layerBubble.hidden=YES;
            btn.tag=10001;
            [btn setBackgroundImage:[UIImage imageNamed:@"chat_jianhao"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnDeletePeople:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            btn.tag=btnTag;
            btn.layerBubble.hidden=!isDelete;
            [btn addTarget:self action:@selector(btnPeopleHead:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
            PeopelInfo *info =_editingView.chatView.arrPeoples[btnTag];
            btn.labelName.text=info.Name;
            [HTTPRequest setImageWithURL:info.headPath placeholderImage:[UIImage imageNamed:@"default_avatar"] ImageBolck:^(UIImage *image) {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }];
            
            if (!Names) Names=info.Name;
            else Names=[NSString stringWithFormat:@"%@,%@",Names,info.Name];
            
            if (!HeadPaths) HeadPaths=info.headPath;
            else HeadPaths=[NSString stringWithFormat:@"%@,%@",HeadPaths,info.headPath];
            
            if (!msisdns) msisdns =info.tel;
            else msisdns=[NSString stringWithFormat:@"%@,%@",msisdns,info.tel];
        }
    }
    
    //改变滑动视图滑动范围
    if (_editingView.chatView.arrPeoples.count%widthIndex==0) {
        [self.editingView.scrollView setContentSize:CGSizeMake(320, lineIndex*(imageHeadSize+imageInterval))];
    }else{
        [self.editingView.scrollView setContentSize:CGSizeMake(320, (lineIndex+1)*(imageHeadSize+imageInterval))];
    }
    
    //更新数据库信息
    [self updateCoreData];
}


- (void)updateCoreData{
    if (!_editingView.chatView.sessionInfo) return;
    _editingView.chatView.sessionInfo.session_receivermsisdn=msisdns;
    _editingView.chatView.sessionInfo.session_receiveravatar=HeadPaths;
    _editingView.chatView.sessionInfo.session_receivername=Names;
    [[CoreDataManageContext newInstance] saveContext];
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
- (void)MessageViewToChatMessageView:(NSMutableArray *)peoples{
   
    for ( PeopelInfo *info in peoples) {
        if (info.tel==user.msisdn) {
            [peoples removeObject:info];
        }
    }
    
    NSIndexSet * indexSet=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_editingView.chatView.arrPeoples.count-2,peoples.count)];
    [_editingView.chatView.arrPeoples insertObjects:peoples atIndexes:indexSet];
    [self updatePeoples];
}

//删除
- (void)btnDeletePeople:(PhotoButton *)sender{
    if (_editingView.chatView.arrPeoples.count<=4) return;
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
        PeopelInfo *info =_editingView.chatView.arrPeoples[sender.tag];
        if ([info.tel isEqualToString:user.msisdn]) {
            [self showHUDText:@"不能删除自己" showTime:1];
            return;
        }
        
        [_editingView.chatView.arrPeoples removeObjectAtIndex:sender.tag];
        for (UIView *view in _editingView.scrollView.subviews) {
            if ([view isKindOfClass:[PhotoButton class]]) {
                [view removeFromSuperview];
            }
        }
        
        if (_editingView.chatView.arrPeoples.count<=4) isDelete=NO;
        [self updatePeoples];
    }else{
        
    }
}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.editingView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}
@end

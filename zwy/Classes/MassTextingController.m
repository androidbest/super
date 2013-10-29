//
//  MassTextingController.m
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "MassTextingController.h"
#import "optionAddress.h"
#import "MassMyaddressController.h"
#import "PeopelInfo.h"
#import "GroupInfo.h"

@implementation MassTextingController
{
NSMutableArray * arrAllNumber;
     BOOL isSign;
}

#pragma mark -  初始化
- (id)init{
    self =[super init];
    if (self) {
        self.arrDidAllPeople=[[NSMutableArray alloc] init];
        arrAllNumber =[[NSMutableArray alloc] init];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}

#pragma mark - 按钮方法
/*系统通讯录*/
- (void)BtnGroupAddress{
    [self.massView performSegueWithIdentifier:@"MassToOptionAddress" sender:nil];
}

/*本地通讯录*/
- (void)btnMyAddress{
   [self.massView performSegueWithIdentifier:@"massToAddress" sender:nil];
}

/*手动添加*/
- (void)btnSelfAdd{
  [self.massView performSegueWithIdentifier:@"MassTextingToMassAdd" sender:nil];
}

/*选择短信模版*/
- (void)btnSMSMode{
    [self.massView performSegueWithIdentifier:@"MassToSMSMode" sender:Nil];
}

/*全部清除*/
- (void)btnClear{
    [_arrDidAllPeople removeAllObjects];
    [arrAllNumber  removeAllObjects];
    [_massView.tableViewPeople reloadData];
}


/*是否签名*/
- (void)btnSign:(UIButton *)sender{
    if (sender.tag==0) {
        sender.tag=1;
        isSign=YES;
        [sender setImage:[UIImage imageNamed:@"btn_check"] forState:UIControlStateNormal];
    }else{
        sender.tag=0;
        isSign=NO;
        [sender setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
    }
}



/*返回*/
- (void)btnBack{
    [UIView animateWithDuration:.3 animations:^{
        _massView.view.layer.position  =CGPointMake(ScreenWidth/2+ScreenWidth, ScreenHeight/2);
    } completion:^(BOOL finished) {
        if (finished) {
            [_massView.view removeFromSuperview];
            [_massView removeFromParentViewController];
        }
    }];
}

/*发送*/
- (void)btnSend{
    NSMutableArray *arrPeople =[[NSMutableArray alloc] init];
    for (int i=0; i<_arrDidAllPeople.count; i++) {
        PeopelInfo *info =_arrDidAllPeople[i];
        [arrPeople addObject:info.tel];
    }
    if (_arrDidAllPeople.count==0) {
        [ToolUtils alertInfo:@"请选择联系人"];
        return;
    }
    
    if (_massView.textSendContext.text.length==0||[_massView.textSendContext.text isEqualToString:@"请编辑内容"]) {
        [ToolUtils alertInfo:@"请输入内容"];
        return;
    }
    
    if (isSign&&_massView.textsign.text.length==0) {
        [ToolUtils alertInfo:@"请添加签名"];
        return;
    }
    NSString *content;
    if (isSign) {
        content =[NSString stringWithFormat:@"%@\n[%@]",_massView.textSendContext.text,_massView.textsign.text];
        NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:_massView.textsign.text forKey:@"signContent"];
        [defaults synchronize];
    }else{
        content=_massView.textSendContext.text;
    }
    [self sendSMS:content recipientList:arrPeople];
}

#pragma mark - 短信模版回调
- (void)returnSMSModeInfo:(NSString *)SMSContent{
    self.massView.textSendContext.textColor=[UIColor blackColor];
    self.massView.textSendContext.text=SMSContent;
    _massView.labelTextMaxLengh.text=[NSString stringWithFormat:@"%@/350",[ToolUtils numToString:SMSContent.length]];
}

#pragma mark - 弹出信息发送页面
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self.massView presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark -信息发送回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}



#pragma mark -接受选择通讯录传回来的数据
- (void)returnDidAddress:(NSArray *)arr{
    NSObject *obj;
    if (arr.count!=0) {
        for (int i =0; i<arr.count; i++) {
            obj=arr[i];
            if ([obj isKindOfClass:[PeopelInfo class]]) {
                if (![arrAllNumber containsObject:[(PeopelInfo *)obj tel]]){
                    [arrAllNumber addObject:[(PeopelInfo *)obj tel]];
                    [_arrDidAllPeople addObject:obj];
                }
            }
            
        }
    }
    
    [self.massView.tableViewPeople reloadData];
}



#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDidAllPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell=@"SMSCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:11];
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    NSObject * obj =_arrDidAllPeople[indexPath.row];
    if ([obj isKindOfClass:[PeopelInfo class]]) {
        cell.textLabel.text=[(PeopelInfo *)obj Name];
        cell.detailTextLabel.text=[(PeopelInfo *)obj tel];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrDidAllPeople removeObjectAtIndex:indexPath.row];
        [arrAllNumber  removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark -弹出键盘通知
-(void)inputKeyboardWillShow:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect rect=self.massView.view.frame;
        rect.origin.y=-keyBoardFrame.size.height;
        self.massView.view.frame=rect;
    }];
}

#pragma mark -取消键盘通知
-(void)inputKeyboardWillHide:(NSNotification *)notificationKeyboar{
    CGFloat animationTime = [[[notificationKeyboar userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect rect=self.massView.view.frame;
        rect.origin.y=0;
        self.massView.view.frame=rect;
    }];
}

- (void)endTextEditing{
    [self.massView.view endEditing:YES];
}

#pragma mark -  textiew提示语
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.massView.textSendContext])
    {
        if ([textView.text isEqualToString:@"请编辑内容"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.massView.textSendContext])
    {
        if (textView.text.length==0)
        {
            textView.text = @"请编辑内容";
            textView.textColor = [UIColor lightGrayColor];
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * textStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (textStr.length>=350)
    {
        textView.text = [textStr substringToIndex:350];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    _massView.labelTextMaxLengh.text=[NSString stringWithFormat:@"%@/350",[ToolUtils numToString:textView.text.length]];
}

@end

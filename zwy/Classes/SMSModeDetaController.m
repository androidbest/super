//
//  SMSModeDetaController.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "SMSModeDetaController.h"
#import "SMSInfo.h"
#import "TemplateCell.h"
#import "Constants.h"

@implementation SMSModeDetaController
{
    SMSInfo * info;
}
- (id)init{
    self=[super init];
    if (self) {
        info= [SMSInfo new];
        //返回消息通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
    }
    return self;
}

- (void)initWithData{
    self.HUD.labelText = @"正在请求数据..";
    [self.HUD show:YES];
//    self.HUD.dimBackground = YES;
    [packageData getTemplate:self TemplateID:_smsView.info.SmsID pageNmu:@"1"];
}

- (void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    if (![notification userInfo]) {
         [ToolUtils alertInfo:requestError];
        return;
    }
    
    info =[AnalysisData getTemplate:[notification userInfo]];
    [_smsView.tableViewModeInfo reloadData];
}

- (void)btnBack{
    [_smsView.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return info.AllSMSContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  static NSString *CellIdentifier = @"Cell";

   // lable.text=[info.AllSMSContent[indexPath.row] content];
static NSString * strCell2 =@"cell2";
   TemplateCell *  cell =[tableView dequeueReusableCellWithIdentifier:strCell2];
    if (!cell) {
        cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell2];
    }
    cell.content.text=[info.AllSMSContent[indexPath.row] content];
    cell.content.textColor=[UIColor blackColor];
    CGRect textRect = [cell.content.text boundingRectWithSize:CGSizeMake(280.0f, 1000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:cell.content.font}
                                                      context:nil];
    CGRect rect=cell.content.frame;
    rect.size=textRect.size;
    rect.origin.y=15;
    rect.origin.x=15;
    cell.content.frame=rect;
    rect =cell.frame;
    rect.size.height=cell.content.frame.size.height+30;
    cell.frame=rect;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_smsView.navigationController popViewControllerAnimated:NO];
    [_smsView.SMSModeDetaViewDelegate returnSMSModeDetaInfo:[info.AllSMSContent[indexPath.row] content]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

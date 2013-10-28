//
//  SMSModeController.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "SMSModeController.h"
#import "SMSInfo.h"
#import "SMSDetaInfo.h"
#import "SmsSonDetaInto.h"
#import "SMSModeDetaView.h"
#import "Constants.h"
@implementation SMSModeController{
    SMSInfo *smsInfo;
}

- (id)init{
    self=[super init];
    if (self) {
        smsInfo =[SMSInfo new];
        _arrAllModeInfo =[[NSMutableArray alloc] init];
        //返回消息通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
    }
    return self;
}

-(void)initReqData{
    self.HUD.labelText = @"正在请求数据..";
    [self.HUD show:YES];
    self.HUD.dimBackground = YES;
[packageData templateInfor:self];
}

- (void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    
    if (![notification userInfo]) {
        [ToolUtils alertInfo:requestError];
        return;
    }
    SMSInfo *info =[AnalysisData templateInfor:[notification userInfo]];
    smsInfo=info;
    [_smsView.tableViewSMSMode reloadData];
}


- (void)btnBack{
    [self.smsView.navigationController popViewControllerAnimated:YES];
}

/*modeInfo回调*/
- (void)returnSMSModeDetaInfo:(NSString *)SMSContent{
    [self performSelector:@selector(returnSMSMode:) withObject:SMSContent afterDelay:0.0];

}
- (void)returnSMSMode:(NSString *)SMSContent{
    [self.smsView.SMSModeViewDelegate returnSMSModeInfo:SMSContent];
    [self.smsView.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDetaSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [smsInfo.AllSMSLate count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen)
    {
        if (self.selectIndex.section == section)
        {
            return [[[smsInfo.AllSMSLate objectAtIndex:section] Alltitle] count]+1;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
        SmsSonDetaInto *deta =[[[smsInfo.AllSMSLate objectAtIndex:self.selectIndex.section] Alltitle] objectAtIndex:indexPath.row-1];
        UILabel * labeltext =(UILabel *)[cell viewWithTag:101];
        UIImageView * imageView  =(UIImageView *)[cell  viewWithTag:100];
        imageView.image=[UIImage imageNamed:@"sms_template"];
        labeltext.text=deta.SmsName;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIView * view =[[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor =[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        cell.backgroundView=view;
        SMSDetaInfo * deta =[smsInfo.AllSMSLate objectAtIndex:indexPath.section];
        cell.textLabel.text = deta.templatename;
        return cell;
    }

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else
            {
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    }
    else
    {
            SmsSonDetaInto *deta =[[[smsInfo.AllSMSLate objectAtIndex:indexPath.section] Alltitle] objectAtIndex:indexPath.row-1];
        [self initBackBarButtonItem:self.smsView];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SMSModeDetaView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"SMSModeDetaView"];
        [self.smsView.navigationController pushViewController:detaView animated:YES];
        detaView.info=deta;
        detaView.SMSModeDetaViewDelegate=self;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.smsView.tableViewSMSMode beginUpdates]; //开始展开setion
    NSInteger section = self.selectIndex.section;
    
    NSInteger contentCount = [[[smsInfo.AllSMSLate objectAtIndex:section] Alltitle] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {
        [self.smsView.tableViewSMSMode insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationBottom];
    }
	else
    {
        [self.smsView.tableViewSMSMode deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.smsView.tableViewSMSMode endUpdates];//结束setion的展开动作
    if (nextDoInsert)
    {
        self.isOpen = YES;
        self.selectIndex = [self.smsView.tableViewSMSMode indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen)
        [self.smsView.tableViewSMSMode scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];//卷起行
}


@end

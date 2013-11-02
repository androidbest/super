//
//  OfficeFlowController.m
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficeFlowController.h"
#import "ToolUtils.h"
#import "Constants.h"
#import "AnalysisData.h"
#import "PackageData.h"
#import "DocFlowCell.h"
#import "DocFlow.h"
@implementation OfficeFlowController{
    NSMutableArray *arr;
}
-(id)init{
    self=[super init];
    arr=[NSMutableArray new];
    if(self){
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25;
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    [self.HUD hide:YES];
    if(dic){
        RespList *list=[AnalysisData showFlowDocList:dic];
        if(list.resplist.count>0){
            for(int i=0;i<list.resplist.count;i++){
                NSArray * nsarr=@[[list.resplist objectAtIndex:i]];
                [arr addObject:nsarr];
            }
            [self.officeFlowView.flowList reloadData];
        }else{
            [ToolUtils alertInfo:@"暂无数据"];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if((arr.count-1)==section){
        UIView* header =[UIView new];
        header.alpha=0;
        [header setBackgroundColor:[UIColor whiteColor]];

        return header;
    }else{
        UIView* header =[UIView new];
        header.alpha=0.3;
        [header setBackgroundColor:[UIColor grayColor]];
                return header;
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strcell =@"docflowcell";
    DocFlowCell * cell =(DocFlowCell *)[tableView dequeueReusableCellWithIdentifier:strcell];
    if (!cell) {
        cell =[[DocFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
//        cell=[[[NSBundle mainBundle] loadNibNamed:strcell owner:self options:nil] objectAtIndex:0];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    DocFlow *info=[[arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(indexPath.section==0){
        cell.topLabel.hidden=YES;
    }

    cell.num.text=[ToolUtils numToString:indexPath.section+1];
    cell.handler.text=info.membername;
    cell.handletime.text=info.overTime;
    cell.hanldeStep.text=info.doStatus;
    if (![info.describe isEqualToString:@"null"]) {cell.auditStatus.text=info.describe;}
    else{cell.auditStatus.text=@"";}
    
    NSString * strContent=info.content;
    if ([strContent isEqualToString:@"null"]) {strContent=@"";}
    cell.content.text=strContent;
    
    
    //添加滑动试图
//    UIScrollView *_scrollView=[[UIScrollView alloc] initWithFrame:cell.content.frame];
//    _scrollView.delegate = self;
//    cell.contentSroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
//    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    cell.contentSroll.backgroundColor=[UIColor clearColor];
//    cell.contentSroll.autoresizesSubviews = NO;
//    cell.contentSroll.canCancelContentTouches = NO;
//    cell.contentSroll.showsHorizontalScrollIndicator = NO;
//    cell.contentSroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//    cell.contentSroll.clipsToBounds = YES;
//    cell.contentSroll.scrollEnabled = YES;
//    cell.contentSroll.pagingEnabled = NO;
////   CGFloat contentLength=[strContent length]*15;
//    cell.contentSroll.contentSize=CGSizeMake(200, 0);
////    cell.content.frame=CGRectMake(0, 0, contentLength,21);
//    cell.content.text=strContent;
//    cell.content.font=[UIFont systemFontOfSize:13];
//    cell.content.textColor=[UIColor grayColor];
//    cell.content.backgroundColor=[UIColor clearColor];
//    cell.content.textAlignment=NSTextAlignmentLeft;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)sendDocFlow{
[packageData docFlow:self ID:self.officeFlowView.data.ID];
self.HUD.labelText = @"正在获取数据..";
[self.HUD show:YES];
self.HUD.dimBackground = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

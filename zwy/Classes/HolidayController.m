//
//  HolidayController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "HolidayController.h"
#import "NewsScheduleView.h"
#import "MassTextingView.h"
#import "DetailTextView.h"
#import "TemplateCell.h"
@implementation HolidayController


- (id)init{
    self =[super init];
    if (self) {
        _arrSMSMode =[NSMutableArray new];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}

- (void)initWithData{
    _holiView.LableDays.attributedText =[DetailTextView setDateAttributedString:_holiView.info.remainTime];
    if ([_holiView.info.warningType isEqualToString:@"2"])   _holiView.labelName.text=[NSString stringWithFormat:@"%@ 的生日",_holiView.info.content];
    else _holiView.labelName.text=_holiView.info.content;
   
    _holiView.lableDate.text=_holiView.info.warningDate;
}

#pragma mark - newsScheduleDelegate
- (void)updataWarning:(warningDataInfo *)info{
    _holiView.info.remainTime=info.remainTime;
    _holiView.info.content=info.content;
    _holiView.info.warningDate=info.warningDate;
    
    _holiView.LableDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    
    if ([_holiView.info.warningType isEqualToString:@"2"]) _holiView.labelName.text=[NSString stringWithFormat:@"%@ 的生日",info.content];
    else _holiView.labelName.text=info.content;
   
    _holiView.labelName.text=info.content;
    _holiView.lableDate.text=info.warningDate;
    
    int scheduleType =[_holiView.info.warningType intValue];
    [_holiView.HolidayViewDelegate upDataScheduleList:scheduleType];
}

#pragma mark - 接收数据
- (void)handleData:(NSNotification *)notification{

}

#pragma mark - 按钮实现方法
- (void)btnEditing{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    detaView.strTitle=@"生日祝福";
    detaView.info=_holiView.info;
    [self.holiView presentViewController:detaView animated:YES completion:nil];
    detaView.newsScheduleDelegate=self;
   
}

#pragma mark - UITableViewDataSoures
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrSMSMode.count;
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
    cell.content.text=@"anyone";
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

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MassTextingView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"MassTextingView"];
    detaView.isSchedule=YES;
    [self.holiView.navigationController pushViewController:detaView animated:YES];
}

/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{

}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [self.holiView.tableViewSMSMode scrollViewDidPullScroll:scrollView];
}
@end

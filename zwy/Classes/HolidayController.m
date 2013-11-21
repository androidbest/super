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
 _holiView.LableDays.attributedText =[DetailTextView setDateAttributedString:@"123"];
}

#pragma mark - 接收数据
- (void)handleData:(NSNotification *)notification{

}

#pragma mark - 按钮实现方法
- (void)btnEditing{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    detaView.strTitle=@"生日祝福";
    [self.holiView presentViewController:detaView animated:YES completion:nil];
}

#pragma mark - UITableViewDataSoures
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrSMSMode.count+5;
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

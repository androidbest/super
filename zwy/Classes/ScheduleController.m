//
//  ScheduleController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ScheduleController.h"
#import "ScheduleCell.h"
@implementation ScheduleController{

    tableViewScheduleType tableView_Type;
    NSString *notificationNameAll;
    NSString *notificationNameWork;
    NSString *notificationNameLife;
    NSString *notificationNameBirthday;
    NSString *notificationNameHoliday;
}

- (id)init{
    self=[super init];
    if (self) {
        tableView_Type =tableView_ScheduleType_All;
        _arrAll =[[NSMutableArray alloc] init];
        _arrWork=[[NSMutableArray alloc] init];
        _arrLife =[[NSMutableArray alloc] init];
        _arrBirthday=[[NSMutableArray alloc] init];
        _arrholiday =[[NSMutableArray alloc] init];
      
        notificationNameAll=@"notificationNameAll";
        notificationNameWork=@"notificationNameWork";
        notificationNameLife=@"notificationNameLife";
        notificationNameBirthday=@"notificationNameBirthday";
        notificationNameHoliday=@"notificationNameHoliday";
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameAllData:)
                                                    name:notificationNameAll
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameWorkData:)
                                                    name:notificationNameWork
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameLifeData:)
                                                    name:notificationNameLife
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameBirthdayData:)
                                                    name:notificationNameBirthday
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameHolidayData:)
                                                    name:notificationNameHoliday
                                                  object:self];
        
    }
    return self;
}

#pragma mark -接受数据信息
//所有日程
- (void)notificationNameAllData:(NSNotification *)notification{

}

//工作日程
- (void)notificationNameWorkData:(NSNotification *)notification{
    
}

//生活日程
- (void)notificationNameLifeData:(NSNotification *)notification{
    
}

//生日日程
- (void)notificationNameBirthdayData:(NSNotification *)notification{
    
}

//节日日程
- (void)notificationNameHolidayData:(NSNotification *)notification{
    
}

#pragma mark - 选择卡按钮
-(void)segmentAction:(UISegmentedControl *)Seg{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret=0;
    switch (tableView.tag) {
        case 0:{
            ret=_arrAll.count;
        }
            break;
            
        case 1:{
            ret=_arrWork.count;
        }
            break;
            
        case 2:{
            ret=_arrLife.count;
        }
            break;
            
        case 3:{
            ret=_arrBirthday.count;
        }
            break;
            
        case 4:{
            ret=_arrholiday.count;
        }
            break;
        default:
            
            break;
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"cell";
    ScheduleCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
    }
    switch (tableView.tag) {
        case 0:{
         
        }
            break;
            
        case 1:{
        
        }
            break;
            
        case 2:{
           
        }
            break;
            
        case 3:{
          
        }
            break;
            
        case 4:{
         
        }
            break;
        default:
            
            break;
    }
    return cell;
}
/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{

}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
        [self.schedView.tableViewAll scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==1){
        [self.schedView.tableViewWork scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==2){
        [self.schedView.tableViewLife scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==3){
        [self.schedView.tableViewBirthday scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==4){
        [self.schedView.tableViewHoliday scrollViewDidPullScroll:scrollView];
    }
}

@end

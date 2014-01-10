//
//  ScheduleController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ScheduleController.h"
#import "ScheduleCell.h"
#import "DetailTextView.h"
#import "WorkView.h"
#import "HolidayView.h"
#import "NewsScheduleView.h"
#import "UpdataDate.h"

@implementation ScheduleController{

    tableViewScheduleType tableView_Type;
    NSString *notificationNameAll;
    NSString *notificationNameWork;
    NSString *notificationNameLife;
    NSString *notificationNameBirthday;
    NSString *notificationNameHoliday;
    
    /*请求的页数*/
    int pagesAll;
    int pagesWork;
    int pageLife;
    int pageBirthday;
    int pageHoliday;
    
    /*是否是第一次请求数据*/
    BOOL isAllFirstLoad;
    BOOL isWorkFirstLoad;
    BOOL isLifeFirstLoad;
    BOOL isBirthdayFirstLoad;
    BOOL isHolidayFirstLoad;
    
    /*是否下拉刷新*/
    BOOL isPullDownAll;
    BOOL isPullDownWork;
    BOOL isPullDownLife;
    BOOL isPullDownBirthday;
    BOOL isPullDownHoliday;
    
    /*是否有置顶信息*/
    BOOL isFirst;
    
    /*第一次创建本地通知*/
    BOOL isAllInit;
    BOOL isWorkInit;
    BOOL isLifeInit;
    BOOL isBirthdayInit;
    BOOL isHolidayInit;
    
   
    
    NSDictionary *dicDcomentFirst;
    NSString *InitDaysTime;
    warningDataInfo *warningDataFirstInfo;
}

- (id)init{
    self=[super init];
    if (self) {
        pagesAll=1;
        pagesWork=1;
        pageLife=1;
        pageBirthday=1;
        pageHoliday=1;
        
        isAllInit=YES;
        isWorkInit=YES;
        isLifeInit=YES;
        isBirthdayInit=YES;
        isHolidayInit=YES;
        
        isAllFirstLoad=YES;
        isWorkFirstLoad=YES;
        isLifeFirstLoad=YES;
        isBirthdayFirstLoad=YES;
        isHolidayFirstLoad=YES;
        
        tableView_Type =tableView_ScheduleType_All;
        _isInit=NULL;
        InitDaysTime=@" 09:00";
        
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

- (void)initWithData{
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];
    isFirst=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    if (isFirst) {
        NSDictionary *dic =[[NSDictionary alloc] initWithContentsOfFile:strPath];
        NSString *strDate=dic[@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [formatter dateFromString:strDate];
        int isStart =[ToolUtils bigOrsmallOneDay:startDate withAnotherDay:[NSDate date]];
        
        if (isStart<0&&([dic[@"reqeatType"] isEqualToString:@"0"]||!dic[@"reqeatType"])) {/*如果置顶日程过期删除*/
            [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
            isFirst=NO;
        }else {
            dicDcomentFirst=[NSDictionary dictionaryWithDictionary:dic];
        }
        
    }
    if (_arrAll.count>0&&!isFirst) {
        [self getFirstSchedule];
    }
}

/*设置置顶提醒*/
- (void)getFirstSchedule{
    if (_arrAll.count==0) {
        _schedView.labelName.text=@"暂无数据";
        return;
    }
    warningDataInfo * info =_arrAll[0];
    NSString *Title;
    if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
        Title =[info.content stringByAppendingString:@" 的生日"];
        _schedView.labelName.text=Title;
    }
    else {
        Title=info.content;
        _schedView.labelName.text=Title;
    }
     _schedView.labelBirthday.text = info.warningDate;
    _schedView.labelDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    warningDataFirstInfo=info;
}

/*同步置顶信息*/
- (void)updateFirstSchedule:(warningDataInfo *)info{
     NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    NSMutableDictionary *dicFirst=[[NSMutableDictionary alloc] init];
    [dicFirst setObject:info.content forKey:@"name"];/*提醒标题*/
    [dicFirst setObject:info.warningDate forKey:@"date"];//时间
    [dicFirst setObject:info.warningID forKey:@"ID"];//日程ID
    [dicFirst  setObject:info.RequestType forKey:@"reqeatType"];//重复类型
    [dicFirst setObject:info.warningType forKey:@"ScheduleType"];//日程类型
    if(info.isUserHandAdd)[dicFirst setObject:info.isUserHandAdd forKey:@"dataType"];//是否为手动添加
    
    [dicFirst writeToFile:strPath atomically:NO];//写入沙盒
    
    NSString *Title;
    if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
        Title =[info.content stringByAppendingString:@" 的生日"];
        _schedView.labelName.text=Title;
    }
    else {
        Title=info.content;
        _schedView.labelName.text=Title;
    }
    _schedView.labelBirthday.text = info.warningDate;
    _schedView.labelDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    warningDataFirstInfo=info;
}

/*添加日程提醒*/
- (void)btnAddSchedule{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    [self.schedView presentViewController:detaView animated:YES completion:nil];
    detaView.btnCancel.hidden=YES;
    detaView.schedView=self.schedView;
    detaView.newsScheduleDelegate=self;
}

/*push到详细页面*/
- (void)PushMassTextView{
    if ([warningDataFirstInfo.warningType isEqualToString:@"0"]||[warningDataFirstInfo.warningType isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
        [self.schedView.navigationController pushViewController:detaView animated:YES];
        detaView.info=warningDataFirstInfo;
        detaView.WorkViewDelegate=self;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
        [self.schedView.navigationController pushViewController:detaView animated:YES];
        detaView.info =warningDataFirstInfo;
        detaView.HolidayViewDelegate=self;
    }
}

#pragma mark - 更新数据(newsScheduleDelegate,HolidayViewDelegate,WorkViewDelegate)
- (void)upDataScheduleList:(int)TableViewType{

    self.HUD = [[MBProgressHUD alloc] initWithView:self.schedView.navigationController.view];
	[self.schedView.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"更新日程";
	// Set determinate bar mode
	self.HUD.delegate = self;
    [self.HUD show:YES];
    
    
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    BOOL isboolFirst=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    
    if (!isboolFirst) {
        isFirst=NO;
        dicDcomentFirst=nil;
        dicDcomentFirst=[NSDictionary dictionary];
    }else {
        isFirst=YES;
        dicDcomentFirst =[NSDictionary dictionaryWithContentsOfFile:strPath];
    }
    
    pagesAll=1;
    isPullDownAll=YES;
    [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
    switch (TableViewType) {
        case 0:{
            
            pagesWork=1;
            isPullDownWork=YES;/*重新刷新数据*/
            isWorkInit=YES;/*更新本地通知*/
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 1:{
            pageLife=1;
            isPullDownLife=YES;
            isLifeInit=YES;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 2:{
            pageBirthday=1;
            isPullDownBirthday=YES;
            isBirthdayInit=YES;
            [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 3:{
            pageHoliday=1;
            isPullDownHoliday=YES;
            isHolidayInit=YES;
            [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
        }
            break;
        default:
            break;
    }
}

#pragma mark -接受数据信息
//所有日程
- (void)notificationNameAllData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewAll reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownAll) {
        isPullDownAll=NO;
        pagesAll=1;
        [_arrAll removeAllObjects];
    }
    if (info.warningList&&info.warningList.count>0)
    [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_All];
    
    if (_arrAll.count!=0) {
        _schedView.tableViewAll.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//    if (_arrAll.count>=info.AllCount) {
        _schedView.tableViewAll.reachedTheEnd=NO;
//    }else {
//    _schedView.tableViewAll.reachedTheEnd=YES;
//    }
    [_schedView.tableViewAll reloadDataPull];
    
    if (!isFirst) {/*设置置顶内容*/
        [self getFirstSchedule];
    }
    
    /*创建通告*/
    if (isAllInit)[self addAllLocalNotification];
    
    if (self.HUD)[self.HUD hide:YES afterDelay:1];
   
}

//工作日程
- (void)notificationNameWorkData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewWork reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownWork) {
        isPullDownWork=NO;
        pagesWork=1;
        [_arrWork removeAllObjects];
    }
    if (info.warningList&&info.warningList.count>0)
        [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Work];
        
    if (_arrWork.count!=0) {
        _schedView.tableViewWork.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//    if (_arrWork.count>=info.AllCount) {
        _schedView.tableViewWork.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewWork.reachedTheEnd=YES;
//    }
    
    [_schedView.tableViewWork reloadDataPull];
    
    if (isWorkInit){/*创建通告*/
        _isInit=&isWorkInit;
        [self addWarningLocalNotification:_arrWork initWithOrBool:&isWorkInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
}

//生活日程
- (void)notificationNameLifeData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewLife reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownLife) {
        isPullDownLife=NO;
        pageLife=1;
        [_arrLife removeAllObjects];
    }
    
    if (info.warningList&&info.warningList.count>0)
        [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Life];
        
    if (_arrLife.count!=0) {
        _schedView.tableViewLife.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//   if (_arrLife.count>=info.AllCount) {
        _schedView.tableViewLife.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewLife.reachedTheEnd=YES;
//    }
    [_schedView.tableViewLife reloadDataPull];
    
    if (isLifeInit) {/*创建通告*/
        _isInit=&isLifeInit;
        [self addWarningLocalNotification:_arrLife initWithOrBool:&isLifeInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
}

//生日日程
- (void)notificationNameBirthdayData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewBirthday reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownBirthday) {
        isPullDownBirthday=NO;
        pageBirthday=1;
        [_arrBirthday removeAllObjects];
    }
    
    if (info.warningList&&info.warningList.count>0)
         [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Birthday];
        
    if (_arrBirthday.count!=0) {
        _schedView.tableViewBirthday.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//    if (_arrBirthday.count>=info.AllCount) {
        _schedView.tableViewBirthday.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewBirthday.reachedTheEnd=YES;
//    }
    [_schedView.tableViewBirthday reloadDataPull];
    
    if (isBirthdayInit) {/*创建通告*/
        _isInit=&isBirthdayInit;
        [self addWarningLocalNotification:_arrBirthday initWithOrBool:&isBirthdayInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
}

//节日日程
- (void)notificationNameHolidayData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewHoliday reloadDataPull];
        return;
    }
    
     warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownHoliday) {
        isPullDownHoliday=NO;
        pageHoliday=1;
        [_arrholiday removeAllObjects];
    }
    
     if (info.warningList&&info.warningList.count>0)
         [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Holiday];
         
    if (_arrholiday.count!=0) {
        _schedView.tableViewHoliday.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }

    
//    if (_arrholiday.count>=info.AllCount) {
        _schedView.tableViewHoliday.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewHoliday.reachedTheEnd=YES;
//    }
    [_schedView.tableViewHoliday reloadDataPull];
    
    if (isHolidayInit){/*创建通告*/
        _isInit=&isHolidayInit;
        [self addWarningLocalNotification:_arrholiday initWithOrBool:&isHolidayInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
}

- (NSArray *) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    NSMutableArray *arrBefore;//未过期日程array
    NSMutableArray *arrAfter;//已过期日程array
    NSMutableArray *arrAll;//排序完成的日程array
    
    //设置排序方式key
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    
    //未过期日程排序
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF.remainTimeInt >= 0"];
    arrBefore =[NSMutableArray arrayWithArray:[dicArray filteredArrayUsingPredicate:thePredicate]];
    [arrBefore sortUsingDescriptors:descriptors];
    
    //已过期日程排序
    arrAfter=dicArray;
    [arrAfter removeObjectsInArray:arrBefore];
    [arrAfter sortUsingDescriptors:descriptors];
    
    arrAll =[NSMutableArray new];
    [arrAll addObjectsFromArray:arrBefore];
    [arrAll addObjectsFromArray:arrAfter];
    

    return arrAll;
    
}

//按时间重新排列数据 remainTime
- (void)updateTableViewDateMinToMax:(NSMutableArray *)array tableViewType:(tableViewScheduleType)tableViewType{
    NSMutableArray *arrInfo =[NSMutableArray arrayWithArray:[self changeArray:array orderWithKey:@"remainTimeInt" ascending:YES]];
    
    switch (tableViewType) {
        case tableView_ScheduleType_All:{
            [_arrAll addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Work:{
            [_arrWork addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Life:{
            [_arrLife addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Birthday:{
            [_arrBirthday addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Holiday:{
            [_arrholiday addObjectsFromArray:arrInfo];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 选择卡按钮
-(void)segmentAction:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:{
            tableView_Type=tableView_ScheduleType_All;
            _schedView.tableViewAll.hidden=NO;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 1:{
          tableView_Type=tableView_ScheduleType_Work;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=NO;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 2:{
            tableView_Type=tableView_ScheduleType_Life;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=NO;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 3:{
            tableView_Type=tableView_ScheduleType_Birthday;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=NO;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 4:{
            tableView_Type=tableView_ScheduleType_Holiday;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=NO;
        }
            break;
            
        default:
            
            break;

    }
    [self loadDataTableView];/*选择卡刷新数据*/
}

/*选择卡刷新数据*/
- (void)loadDataTableView{
    if (!_schedView.tableViewAll.hidden) {
        /*第一次刷新数据(全部)*/
        if (_arrAll.count==0&&isAllFirstLoad) {
            [_schedView.tableViewAll LoadDataBegin];
            isAllFirstLoad=NO;
        }
        
    }else if(!_schedView.tableViewWork.hidden){
        /*第一次刷新数据(工作)*/
        if (_arrWork.count==0&&isWorkFirstLoad) {
             [_schedView.tableViewWork LoadDataBegin];
            isWorkFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewLife.hidden){
        /*第一次刷新数据(生活)*/
        if (_arrLife.count==0&&isLifeFirstLoad){
             [_schedView.tableViewLife LoadDataBegin];
            isLifeFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewBirthday.hidden){
        /*第一次刷新数据(生日)*/
        if (_arrBirthday.count==0&&isBirthdayFirstLoad) {
             [_schedView.tableViewBirthday LoadDataBegin];
            isBirthdayFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewHoliday.hidden){
        /*第一次刷新数据(节日)*/
        if (_arrholiday.count==0&&isHolidayFirstLoad){
             [_schedView.tableViewHoliday LoadDataBegin];
            isHolidayFirstLoad=NO;
        }

    }
}

#pragma mark -UItableviewDataSource
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
    }
    switch (tableView.tag) {
        case 0:{
            /***************************/
            warningDataInfo * info =_arrAll[indexPath.row];
            if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
            NSString *Title;
            if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
                Title =[info.content stringByAppendingString:@" 的生日"];
                cell.labelTitle.text=nil;
                cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
                cell.labelTime.text = info.brithdayDate;
            }
            else {
                Title=info.content;
                cell.labelTitle.text=Title;
                cell.labelTime.text = info.warningDate;
            }
            cell.labelDays.attributedText =[DetailTextView setCellTimeAttributedString:info.remainTime];
            /***************************/
        }
            break;
            
        case 1:{
            warningDataInfo *info =_arrWork[indexPath.row];
            if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 2:{
            warningDataInfo *info =_arrLife[indexPath.row];
            if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 3:{
            warningDataInfo *info =_arrBirthday[indexPath.row];
            if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
            
            /*如果为手动添加标题后面不自动添加“的生日“字段*/
            if ([info.isUserHandAdd isEqualToString:@"0"]) {
                cell.labelTitle.text=info.content;
            }else{
                NSString * Title =[info.content stringByAppendingString:@" 的生日"];
                cell.labelTitle.text=nil;
                cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
                
            }
            cell.labelTime.text=info.brithdayDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 4:{
            warningDataInfo *info =_arrholiday[indexPath.row];
            if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
        default:
            
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 0:{
        warningDataInfo * info =_arrAll[indexPath.row];
            if ([info.warningType isEqualToString:@"0"]||[info.warningType isEqualToString:@"1"]||([info.isUserHandAdd isEqualToString:@"0"]&&[info.warningType isEqualToString:@"4"])) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info=info;
                detaView.WorkViewDelegate=self;
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info =info;
                detaView.HolidayViewDelegate=self;
            }
        }
            break;
            
        case 1:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info=_arrWork[indexPath.row];
            detaView.WorkViewDelegate=self;
        }
            break;
            
        case 2:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info=_arrLife[indexPath.row];
            detaView.WorkViewDelegate=self;
        }
            break;
            
        case 3:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info =_arrBirthday[indexPath.row];
            detaView.HolidayViewDelegate=self;
        }
            break;
            
        case 4:{
            warningDataInfo *info =_arrholiday[indexPath.row];
            if ([info.isUserHandAdd isEqualToString:@"0"]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info=info;
                detaView.WorkViewDelegate=self;
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info =info;
                detaView.HolidayViewDelegate=self;
            }

        }
            break;
        default:
            
            break;
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    switch (tableView.tag) {
        case 0:{
            pagesAll=1;
            isPullDownAll=YES;
            [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
        }
            break;
            
        case 1:{
            pagesWork=1;
            isPullDownWork=YES;
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 2:{
            pageLife=1;
            isPullDownLife=YES;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 3:{
             pageBirthday=1;
            isPullDownBirthday=YES;
             [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 4:{
           pageHoliday=1;
            isPullDownHoliday=YES;
           [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
        }
            break;
        default:
            
            break;
    }

}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    switch (tableView.tag) {
        case 0:{
            pagesAll++;
            [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
        }
            break;
            
        case 1:{
            pagesWork++;
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 2:{
            pageLife++;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 3:{
            pageBirthday++;
            [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 4:{
            pageHoliday++;
            [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
        }
            break;
        default:
            
            break;
    }

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

//创建本地通告（全部）
- (void)addAllLocalNotification{
    NSArray*allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification*localNotification in allLocalNotification){
            [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
    }
    
    int count;
    if (_arrAll.count>10) count=10;
    else count=_arrAll.count;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int i=0; i<count; i++) {
        warningDataInfo *info =_arrAll[i];
        NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
        NSDate *dateWarning =[dateFormatter dateFromString:strDate];
        NSTimeInterval time_warning =[dateWarning timeIntervalSince1970];
        NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
        /*添加本地通知*/
        if (time_warning>=time_now)[self addLocalNotification:info];
        
    }
    isAllInit=NO;
}

//创建本地通告（分类）
- (void)addWarningLocalNotification:(NSMutableArray *)array initWithOrBool:(BOOL *)Bool{
    *_isInit=NO;
    *Bool=NO;
    int count;
    if (array.count>5) count=5;
    else count=array.count;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
     NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for (int i=0; i<count; i++) {
        warningDataInfo *info =array[i];
        NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
        NSDate *dateWarning =[dateFormatter dateFromString:strDate];
        
        NSTimeInterval time_warning =[dateWarning timeIntervalSince1970];
        NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
        
        /*删除重复的本地通知*/
        for(UILocalNotification*localNotification in allLocalNotification){
            NSString *alarmValue =[localNotification.userInfo objectForKey:@"ID"];
            if ([alarmValue isEqualToString:info.warningID]) {
              [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
            }
        }
        /****************/
        
        /****************/
        /*添加本地通知*/
        if (time_warning>=time_now) [self addLocalNotification:info];
       /****************/
    }
    
}



/*添加本地通知*/
- (void)addLocalNotification:(warningDataInfo *)info{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
    NSDate * date =[dateFormatter dateFromString:strDate];
    UILocalNotification*notification=[[UILocalNotification alloc]init];
    if(notification!=nil){
        notification.fireDate=date;//开始时间
        notification.timeZone=[NSTimeZone defaultTimeZone];// 设置时区
        notification.soundName=UILocalNotificationDefaultSoundName;//播放音乐类型
        NSString *strBody;
        if ([info.warningType isEqualToString:@"2"]) {
            strBody=[NSString stringWithFormat:@"%@ 的生日",info.content];
        }else{
            strBody=info.content;
        }
        
        if ([info.RequestType isEqualToString:@"1"]) {
            notification.repeatInterval=NSCalendarUnitWeekdayOrdinal;
        }else if([info.RequestType isEqualToString:@"2"]){
            notification.repeatInterval =NSCalendarUnitMonth;
        }else if([info.RequestType isEqualToString:@"3"]){
            notification.repeatInterval=NSCalendarUnitYear;
        }
        
        notification.alertBody=strBody;//提示的消息
        notification.alertLaunchImage = @"lunch.png";// 这里可以设置从通知启动的启动界面，类似Default.png的作用。
        notification.soundName=@"ping.caf";
        notification.alertAction = @"打开"; //提示框按钮
        notification.hasAction=NO;//是否显示额外的按钮
        
        NSMutableDictionary *dicInfo =[[NSMutableDictionary alloc] init];
        [dicInfo setObject:strBody forKey:@"content"];
        [dicInfo setObject:info.warningID forKey:@"ID"];
        [dicInfo setObject:info.RequestType forKey:@"RequestType"];
        [dicInfo setObject:info.warningType forKey:@"warningType"];
        [dicInfo setObject:info.remainTime forKey:@"remainTime"];
        [dicInfo setObject:info.UserTel forKey:@"UserTel"];
        [dicInfo setObject:info.warningDate forKey:@"warningDate"];
        if (info.isUserHandAdd)[dicInfo setObject:info.isUserHandAdd forKey:@"dataType"];
        
        notification.userInfo=dicInfo;//notification信息
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }

}
@end

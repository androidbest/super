//
//  OfficeController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficeController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "TemplateCell.h"
@implementation OfficeController{
NSString *page0;
NSString *page1;
NSString *page2;
NSString *page3;
NSMutableArray *arr0;
NSMutableArray *arr1;
NSMutableArray *arr2;
NSMutableArray *arr3;
NSInteger arr0Count;
NSInteger arr1Count;
NSInteger arr2Count;
NSInteger arr3Count;

    NSMutableArray * arrOverManage;
    NSMutableArray * arrEndManage;
    NSMutableArray * arrOverHear;
    NSMutableArray * arrEndHear;
    
BOOL isUpdata;
BOOL isUpdata1;
BOOL isUpdata2;
BOOL isUpdata3;
    NSInteger selecter;
}

-(id)init{
    self=[super init];
    if(self){
        page0=@"1";
        page1=@"1";
        page2=@"1";
        page3=@"1";
        selecter=0;
        arr0=[NSMutableArray new];
        arr1=[NSMutableArray new];
        arr2=[NSMutableArray new];
        arr3=[NSMutableArray new];
        
        
        NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERMANAGE];
        BOOL blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrOverManage =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrOverManage=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_ENDMANAGE];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrEndManage =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrEndManage=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERHEAR];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrOverHear =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrOverHear=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_ENDHEAR];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrEndHear =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrEndHear=[NSMutableArray new];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData1:)
                                                    name:xmlNotifInfo1
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData2:)
                                                    name:xmlNotifInfo2
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData3:)
                                                    name:xmlNotifInfo3
                                                  object:self];
    }
    return self;
}

//页签选择
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:{
            //待办公文
            selecter=0;
            [self.officeView.listview reloadDataPull];
            self.officeView.listview.hidden=NO;
            self.officeView.listview1.hidden=YES;
            self.officeView.listview2.hidden=YES;
            self.officeView.listview3.hidden=YES;
        }
            break;
        case 1:{
            //已办公文
            selecter=1;
            if(arr1.count==0){
                self.officeView.listview1.separatorStyle = NO;
                [self.officeView.listview1 reloadDataPull];
                [self.officeView.listview1 LoadDataBegin];
            }else{
                [self.officeView.listview1 reloadDataPull];
            }
            
            self.officeView.listview.hidden=YES;
            self.officeView.listview1.hidden=NO;
            self.officeView.listview2.hidden=YES;
            self.officeView.listview3.hidden=YES;
        }break;
        case 2:{
            //待审公文
            selecter=2;
            if(arr2.count==0){
                self.officeView.listview2.separatorStyle = NO;
                [self.officeView.listview2 reloadDataPull];
                [self.officeView.listview2 LoadDataBegin];
            }else{
                [self.officeView.listview2 reloadDataPull];
            }
            self.officeView.listview.hidden=YES;
            self.officeView.listview1.hidden=YES;
            self.officeView.listview2.hidden=NO;
            self.officeView.listview3.hidden=YES;
        }break;
        case 3:{
            //已审公文
            selecter=3;
            if(arr3.count==0){
                self.officeView.listview3.separatorStyle = NO;
                [self.officeView.listview3 reloadDataPull];
                [self.officeView.listview3 LoadDataBegin];
            }else{
                [self.officeView.listview3 reloadDataPull];
            }
            self.officeView.listview.hidden=YES;
            self.officeView.listview1.hidden=YES;
            self.officeView.listview2.hidden=YES;
            self.officeView.listview3.hidden=NO;
        }break;
    }
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata) {
        [arr0 removeAllObjects];
        isUpdata=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getDocList:dic];
        if(list.resplist.count>0||arr0.count!=0){
            [arr0 addObjectsFromArray:list.resplist];
            arr0Count=list.rowCount;
            self.officeView.listview.separatorStyle = YES;
            _officeView.listview.backgroundColor =[UIColor whiteColor];
        }else{

        self.officeView.listview.separatorStyle = NO;
        _officeView.listview.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.officeView.listview reloadDataPull];
}

//处理网络数据
-(void)handleData1:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata1) {
        [arr1 removeAllObjects];
        isUpdata1=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getDocList:dic];
        if(list.resplist.count>0||arr1.count!=0){
          [arr1 addObjectsFromArray:list.resplist];
            arr1Count=list.rowCount;
          self.officeView.listview1.separatorStyle = YES;
        _officeView.listview1.backgroundColor =[UIColor whiteColor];
        }else{
self.officeView.listview1.separatorStyle = NO;
        _officeView.listview1.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.officeView.listview1 reloadDataPull];
}

//处理网络数据
-(void)handleData2:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata2) {
        [arr2 removeAllObjects];
        isUpdata2=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getDocList:dic];
        if(list.resplist.count>0||arr2.count!=0){
            [arr2 addObjectsFromArray:list.resplist];
            arr2Count=list.rowCount;
            self.officeView.listview2.separatorStyle = YES;
             _officeView.listview2.backgroundColor =[UIColor whiteColor];
        }else{
self.officeView.listview2.separatorStyle = NO;
            _officeView.listview2.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.officeView.listview2 reloadDataPull];
}

//处理网络数据
-(void)handleData3:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata3) {
            [arr3 removeAllObjects];
        
        isUpdata3=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getDocList:dic];
        if(list.resplist.count>0||arr3.count!=0){
            [arr3 addObjectsFromArray:list.resplist];
            arr3Count=list.rowCount;
            self.officeView.listview3.separatorStyle = YES;
             _officeView.listview3.backgroundColor =[UIColor whiteColor];
        }else{
self.officeView.listview3.separatorStyle = NO;
            _officeView.listview3.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.officeView.listview3 reloadDataPull];
}





//判断是否需要下拉加载更多内容
- (NSInteger)tableViewReacherdTheEnd:(NSInteger)count{
    if (selecter==0) {
        if (count==arr0Count||count>arr0Count) {
            self.officeView.listview.reachedTheEnd=YES;
        }else{
            self.officeView.listview.reachedTheEnd=NO;
        }
    }else if (selecter==1) {
        if (count==arr1Count||count>arr1Count) {
            self.officeView.listview.reachedTheEnd=YES;
        }else{
            self.officeView.listview.reachedTheEnd=NO;
        }
    } else if(selecter==2){
        if (count==arr2Count||count>arr2Count) {
            self.officeView.listview.reachedTheEnd=YES;
        }else{
            self.officeView.listview.reachedTheEnd=NO;
        }
    }else{
        if (count==arr3Count||count>arr3Count) {
            self.officeView.listview.reachedTheEnd=YES;
        }else{
            self.officeView.listview.reachedTheEnd=NO;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret=0;
    switch (tableView.tag) {
        case 0:{
            ret=arr0.count;
        }
        break;
            
        case 1:{
            ret=arr1.count;
        }
        break;
            
        case 2:{
            ret=arr2.count;
        }
        break;
            
        case 3:{
            ret=arr3.count;
        }
        break;
        default:
            
        break;
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"cell";
    TemplateCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
       
    }
    
    DocContentInfo *info;
    if(tableView.tag==0){
        info=arr0[indexPath.row];
        if ([arrOverManage containsObject:info.ID]) cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==1){
        info=arr1[indexPath.row];
        if ([arrEndManage containsObject:info.ID]) cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==2){
        info=arr2[indexPath.row];
        if ([arrOverHear containsObject:info.ID]) cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==3){
        if ([arrEndHear containsObject:info.ID]) cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        info=arr3[indexPath.row];
    }
    cell.title.text=info.title;
    cell.time.text=info.time;
    cell.content.text=@"非文本模式公文,请点击进入查看内容";
    
    return cell;
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(upData) withObject:nil afterDelay:2];
    if(tableView.tag==0){
        isUpdata=YES;
        page0=@"1";
        [packageData getDocList:self infoType:@"1" pages:page0 SELType:xmlNotifInfo];
    }else if(tableView.tag==1){
        isUpdata1=YES;
        page1=@"1";
        [packageData alreadyDocList:self type:@"1" pageNum:page1 SELType:xmlNotifInfo1];
    }else if(tableView.tag==2){
        isUpdata2=YES;
        page2=@"1";
        [packageData getDocList:self infoType:@"2" pages:page2 SELType:xmlNotifInfo2];
    }else{
        isUpdata3=YES;
        page3=@"1";
        [packageData alreadyDocList:self type:@"2" pageNum:page3 SELType:xmlNotifInfo3];
    }
}

//处理后刷新列表
-(void)refreshListView:(NSInteger)row{
//    if(selecter==0){
//        [arr0 removeObjectAtIndex:row];
//    }else{
//        [arr1 removeObjectAtIndex:row];
//    }
    [self.officeView.listview reloadDataPull];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.officeView performSegueWithIdentifier:@"officetodetail" sender:self.officeView];
    [self initBackBarButtonItem:self.officeView];
    if(tableView.tag==0){
        DocContentInfo *info=arr0[indexPath.row];
        info.type=@"0";
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr0;
        self.officeView.docContentInfo=info;
        //点点点点
        if (![arrOverManage containsObject:info.ID]) {
            [arrOverManage addObject:info.ID];
            [arrOverManage writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERMANAGE] atomically:NO];
        }
        
    }else if(tableView.tag==1){
        DocContentInfo *info=arr1[indexPath.row];
        info.type=@"1";
        self.officeView.docContentInfo=info;
        if (![arrEndManage containsObject:info.ID]) {
            [arrEndManage addObject:info.ID];
            [arrEndManage writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_ENDMANAGE] atomically:NO];
        }
        
        
    }else if(tableView.tag==2){
        DocContentInfo *info=arr2[indexPath.row];
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr2;
        info.type=@"2";
        self.officeView.docContentInfo=info;
        if (![arrOverHear containsObject:info.ID]) {
            [arrOverHear addObject:info.ID];
            [arrOverHear writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERHEAR] atomically:NO];
        }
        
    }else{
        DocContentInfo *info=arr3[indexPath.row];
        info.type=@"3";
        self.officeView.docContentInfo=info;
        if (![arrEndHear containsObject:info.ID]) {
            [arrEndHear addObject:info.ID];
            [arrEndHear writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_ENDMANAGE] atomically:NO];
        }
        
    }
    
    TemplateCell *cell =(TemplateCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imageMark.hidden=YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    NSInteger tempPage=0;
    NSInteger sumPage=0;
    if(tableView.tag==0){
        tempPage=[ToolUtils stringToNum:page0];
        tempPage++;
        if((arr0Count%20)==0){
            sumPage=arr0Count/20;
        }else{
            sumPage=(arr0Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.officeView.listview.reachedTheEnd=NO;
            [self.officeView.listview reloadDataPull];
        }else{
                page0=[ToolUtils numToString:tempPage];
                [packageData getDocList:self infoType:@"1" pages:page0 SELType:xmlNotifInfo];
        }
        
        
    }else if(tableView.tag==1){
        tempPage=[ToolUtils stringToNum:page1];
        tempPage++;
        if((arr1Count%20)==0){
            sumPage=arr1Count/20;
        }else{
            sumPage=(arr1Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.officeView.listview1.reachedTheEnd=NO;
            [self.officeView.listview1 reloadDataPull];
        }else{

                page1=[ToolUtils numToString:tempPage];
                [packageData alreadyDocList:self type:@"1" pageNum:page1 SELType:xmlNotifInfo1];
           
            
        }
    }else if(tableView.tag==2){
        tempPage=[ToolUtils stringToNum:page2];
        tempPage++;
        if((arr2Count%20)==0){
            sumPage=arr2Count/20;
        }else{
            sumPage=(arr2Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.officeView.listview2.reachedTheEnd=NO;
            [self.officeView.listview2 reloadDataPull];
        }else{
            
                page2=[ToolUtils numToString:tempPage];
                [packageData getDocList:self infoType:@"2" pages:page2 SELType:xmlNotifInfo2];
            
        }
    }else{
        tempPage=[ToolUtils stringToNum:page3];
        tempPage++;
        if((arr3Count%20)==0){
            sumPage=arr3Count/20;
        }else{
            sumPage=(arr3Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.officeView.listview3.reachedTheEnd=NO;
            [self.officeView.listview3 reloadDataPull];
        }else{

                page3=[ToolUtils numToString:tempPage];
                [packageData alreadyDocList:self type:@"2" pageNum:page3 SELType:xmlNotifInfo3];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
     [self.officeView.listview scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==1){
     [self.officeView.listview1 scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==2){
     [self.officeView.listview2 scrollViewDidPullScroll:scrollView];
    }else{
     [self.officeView.listview3 scrollViewDidPullScroll:scrollView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

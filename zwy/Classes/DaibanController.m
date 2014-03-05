//
//  DaibanController.m
//  zwy
//
//  Created by wangshuang on 10/21/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "DaibanController.h"
#import "TemplateCell.h"
#import "ToolUtils.h"
#import "Constants.h"
#import "DocContentInfo.h"
#import "MailDetail.h"
@implementation DaibanController{

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
    BOOL isUpdata;
    BOOL isUpdata1;
    BOOL isUpdata2;
    BOOL isUpdata3;
    NSInteger selecter;
    
    NSMutableArray *arrOverManage;
    NSMutableArray *arrOverHear;
    NSMutableArray *arrOpinionManage;
    NSMutableArray *arrOpinionHear;
    
    
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

        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERHEAR];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrOverHear =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrOverHear=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_OPINIONMANAGE];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrOpinionManage =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrOpinionManage=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_OPINIONHEAR];
        blPath=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blPath)arrOpinionHear =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrOpinionHear=[NSMutableArray new];
        
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


- (void)initWithData{
    arr0=nil;
    arr1=nil;
    arr2=nil;
    arr3=nil;
    
    page0=@"1";
    page1=@"1";
    page2=@"1";
    page3=@"1";
    
    
    _daibanView.listview.reachedTheEnd=YES;
    _daibanView.listview.backgroundColor=[UIColor whiteColor];
    
    _daibanView.listview1.reachedTheEnd=YES;
    _daibanView.listview1.backgroundColor=[UIColor whiteColor];
    
    _daibanView.listview2.reachedTheEnd=YES;
    _daibanView.listview2.backgroundColor=[UIColor whiteColor];
    
    _daibanView.listview3.reachedTheEnd=YES;
    _daibanView.listview3.backgroundColor=[UIColor whiteColor];
    

    
    arr0=[NSMutableArray new];
    arr1=[NSMutableArray new];
    arr2=[NSMutableArray new];
    arr3=[NSMutableArray new];
    self.daibanView.selecter.selectedSegmentIndex=0;
    [self segmentAction:self.daibanView.selecter];
      [self.daibanView.listview LoadDataBegin];
}

//页签选择
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:{
            //待办公文
            selecter=0;
            [self.daibanView.listview reloadDataPull];
            self.daibanView.listview.hidden=NO;
            self.daibanView.listview1.hidden=YES;
            self.daibanView.listview2.hidden=YES;
            self.daibanView.listview3.hidden=YES;
        }
            break;
        case 1:{
            //已办公文
            selecter=1;
            if(arr1.count==0){
                self.daibanView.listview1.separatorStyle = NO;
                [self.daibanView.listview1 reloadDataPull];
                [self.daibanView.listview1 LoadDataBegin];
            }else{
                [self.daibanView.listview1 reloadDataPull];
            }
            
            self.daibanView.listview.hidden=YES;
            self.daibanView.listview1.hidden=NO;
            self.daibanView.listview2.hidden=YES;
            self.daibanView.listview3.hidden=YES;
        }break;
        case 2:{
            //待审公文
            selecter=2;
            if(arr2.count==0){
                self.daibanView.listview2.separatorStyle = NO;
                [self.daibanView.listview2 reloadDataPull];
                [self.daibanView.listview2 LoadDataBegin];
            }else{
                [self.daibanView.listview2 reloadDataPull];
            }
            self.daibanView.listview.hidden=YES;
            self.daibanView.listview1.hidden=YES;
            self.daibanView.listview2.hidden=NO;
            self.daibanView.listview3.hidden=YES;
        }break;
        case 3:{
            //已审公文
            selecter=3;
            if(arr3.count==0){
                self.daibanView.listview3.separatorStyle = NO;
                [self.daibanView.listview3 reloadDataPull];
                [self.daibanView.listview3 LoadDataBegin];
            }else{
                [self.daibanView.listview3 reloadDataPull];
            }
            self.daibanView.listview.hidden=YES;
            self.daibanView.listview1.hidden=YES;
            self.daibanView.listview2.hidden=YES;
            self.daibanView.listview3.hidden=NO;
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
            self.daibanView.listview.separatorStyle = YES;
            _daibanView.listview.backgroundColor =[UIColor whiteColor];
        }else{
            _daibanView.listview.separatorStyle = NO;
            _daibanView.listview.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.daibanView.listview reloadDataPull];
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
            self.daibanView.listview1.separatorStyle = YES;
            _daibanView.listview1.backgroundColor =[UIColor whiteColor];
        }else{
_daibanView.listview1.separatorStyle = NO;
            _daibanView.listview1.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.daibanView.listview1 reloadDataPull];
}

//处理网络数据
-(void)handleData2:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata2) {
        [arr2 removeAllObjects];
        isUpdata2=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getPublicMailList:dic];
        if(list.resplist.count>0||arr2.count!=0){
            [arr2 addObjectsFromArray:list.resplist];
            arr2Count=list.rowCount;
            self.daibanView.listview2.separatorStyle = YES;
            _daibanView.listview2.backgroundColor =[UIColor whiteColor];
        }else{
//            [ToolUtils alertInfo:@"暂无数据"];
            _daibanView.listview2.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.daibanView.listview2 reloadDataPull];
}

//处理网络数据
-(void)handleData3:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    
    if (isUpdata3) {
        [arr3 removeAllObjects];
        
        isUpdata3=NO;
    }
    
    if(dic){
        RespList *list=[AnalysisData getAuditMailList:dic];
        if(list.resplist.count>0||arr3.count!=0){
            [arr3 addObjectsFromArray:list.resplist];
            arr3Count=list.rowCount;
            self.daibanView.listview3.separatorStyle = YES;
            _daibanView.listview3.backgroundColor =[UIColor whiteColor];
        }else{
//            [ToolUtils alertInfo:@"暂无数据"];
            _daibanView.listview3.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.daibanView.listview3 reloadDataPull];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


//判断是否需要下拉加载更多内容
- (NSInteger)tableViewReacherdTheEnd:(NSInteger)count{
    if (selecter==0) {
        if (count==arr0Count||count>arr0Count) {
            self.daibanView.listview.reachedTheEnd=YES;
        }else{
            self.daibanView.listview.reachedTheEnd=NO;
        }
    }else if (selecter==1) {
        if (count==arr1Count||count>arr1Count) {
            self.daibanView.listview.reachedTheEnd=YES;
        }else{
            self.daibanView.listview.reachedTheEnd=NO;
        }
    } else if(selecter==2){
        if (count==arr2Count||count>arr2Count) {
            self.daibanView.listview.reachedTheEnd=YES;
        }else{
            self.daibanView.listview.reachedTheEnd=NO;
        }
    }else{
        if (count==arr3Count||count>arr3Count) {
            self.daibanView.listview.reachedTheEnd=YES;
        }else{
            self.daibanView.listview.reachedTheEnd=NO;
        }
    }
    return count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret=0;
    if(tableView.tag==0){
        ret=arr0.count;
    }else if(tableView.tag==1){
        ret=arr1.count;
    }else if(tableView.tag==2){
        ret=arr2.count;
    }else{
        ret=arr3.count;
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"cell";
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //    TemplateCell *cell = [storyboard instantiateViewControllerWithIdentifier:@"templateCell"];
    TemplateCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    DocContentInfo *docinfo;
    PublicMailDetaInfo *mailInfo;
    if(tableView.tag==0){
        docinfo=arr0[indexPath.row];
        cell.title.text=docinfo.title;
        cell.time.text=docinfo.time;
        cell.content.text=@"非文本模式公文,请点击进入查看内容";
        if ([arrOverManage containsObject:docinfo.ID])cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==1){
        docinfo=arr1[indexPath.row];
        cell.title.text=docinfo.title;
        cell.time.text=docinfo.time;
        cell.content.text=@"非文本模式公文,请点击进入查看内容";
        if ([arrOverHear containsObject:docinfo.ID])cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==2){
        mailInfo=arr2[indexPath.row];
        cell.title.text=mailInfo.content;
        cell.time.text=mailInfo.senddate;
        cell.content.text=mailInfo.content;
        if ([arrOpinionManage containsObject:mailInfo.infoid])cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }else if(tableView.tag==3){
        mailInfo=arr3[indexPath.row];
        cell.title.text=mailInfo.content;
        cell.time.text=mailInfo.senddate;
        cell.content.text=mailInfo.content;
        if ([arrOpinionHear containsObject:mailInfo.infoid])cell.imageMark.hidden=YES;
        else cell.imageMark.hidden=NO;
        
    }
    
    
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
        [packageData getDocList:self infoType:@"2" pages:page1 SELType:xmlNotifInfo1];
    }else if(tableView.tag==2){
        isUpdata2=YES;
        page2=@"1";
        [packageData getPublicMailList:self Pages:page2 SELType:xmlNotifInfo2];
    }else{
        isUpdata3=YES;
        page3=@"1";
        [packageData getAuditMailList:self Pages:page3 SELType:xmlNotifInfo3];
    }
}

//处理后刷新列表
-(void)refreshListView:(NSInteger)row{
    //    if(selecter==0){
    //        [arr0 removeObjectAtIndex:row];
    //    }else{
    //        [arr1 removeObjectAtIndex:row];
    //    }
    [self.daibanView.listview reloadDataPull];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self initBackBarButtonItem:self.daibanView];
    if(tableView.tag==0){
        DocContentInfo *info=arr0[indexPath.row];
        info.type=@"0";
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr0;
        self.daibanView.docContentInfo=info;
        [self.daibanView performSegueWithIdentifier:@"daibantooffice" sender:self.daibanView];
        if (![arrOverManage containsObject:info.ID]) {
            [arrOverManage addObject:info.ID];
            [arrOverManage writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERMANAGE] atomically:NO];
        }
        
    }else if(tableView.tag==1){
        DocContentInfo *info=arr1[indexPath.row];
        info.type=@"2";
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr1;
        self.daibanView.docContentInfo=info;
        [self.daibanView performSegueWithIdentifier:@"daibantooffice" sender:self.daibanView];
        if (![arrOverHear containsObject:info.ID]) {
            [arrOverHear addObject:info.ID];
            [arrOverHear writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OVERHEAR] atomically:NO];
        }
        
    }else if(tableView.tag==2){
        PublicMailDetaInfo *info=arr2[indexPath.row];
        info.type=@"0";
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr2;
        self.daibanView.pubilcMailDetaInfo=info;
        [self.daibanView performSegueWithIdentifier:@"daibantomail" sender:self.daibanView];
        if (![arrOpinionManage containsObject:info.infoid]) {
            [arrOpinionManage addObject:info.infoid];
            [arrOpinionManage writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OPINIONMANAGE] atomically:NO];
        }
        
    }else{
        PublicMailDetaInfo *info=arr3[indexPath.row];
        info.row=indexPath.row;
        info.type=@"1";
        info.listview=tableView;
        info.row=indexPath.row;
        info.arr=arr3;
        self.daibanView.pubilcMailDetaInfo=info;
        [self.daibanView performSegueWithIdentifier:@"daibantomail" sender:self.daibanView];
        if (![arrOpinionHear containsObject:info.infoid]) {
            [arrOpinionHear addObject:info.infoid];
            [arrOpinionHear writeToFile:[DocumentsDirectory stringByAppendingPathComponent:PATH_OPINIONHEAR] atomically:NO];
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
            self.daibanView.listview.reachedTheEnd=NO;
            [self.daibanView.listview reloadDataPull];
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
            self.daibanView.listview1.reachedTheEnd=NO;
            [self.daibanView.listview1 reloadDataPull];
        }else{
            
            page1=[ToolUtils numToString:tempPage];
            [packageData getDocList:self infoType:@"2" pages:page1 SELType:xmlNotifInfo1];
            
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
            self.daibanView.listview2.reachedTheEnd=NO;
            [self.daibanView.listview2 reloadDataPull];
        }else{
            
            page2=[ToolUtils numToString:tempPage];
            [packageData getPublicMailList:self Pages:page2 SELType:xmlNotifInfo2];
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
            self.daibanView.listview3.reachedTheEnd=NO;
            [self.daibanView.listview3 reloadDataPull];
        }else{
            
            page3=[ToolUtils numToString:tempPage];
            [packageData getAuditMailList:self Pages:page3 SELType:xmlNotifInfo3];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
        [self.daibanView.listview scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==1){
        [self.daibanView.listview1 scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==2){
        [self.daibanView.listview2 scrollViewDidPullScroll:scrollView];
    }else{
        [self.daibanView.listview3 scrollViewDidPullScroll:scrollView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

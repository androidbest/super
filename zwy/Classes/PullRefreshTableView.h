//
//  PullRefreshTableView.h
//  ios6NewPull
//
//  Created by Mac on 13-9-13.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAContextMenuCell.h"

@class PullRefreshTableView;
@protocol PullRefreshDelegate <NSObject>

- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView;
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView;

/**************DAContextMenuCell***********************/
- (void)contextMenuCellDidSelectMoreOption:(PullRefreshTableView *)tableView  withCell:(DAContextMenuCell *)cell;
- (void)contextMenuCellDidSelectDeleteOption:(PullRefreshTableView *)tableView withCell:(DAContextMenuCell *)cell;
/**************DAContextMenuCell***********************/

@end
@interface PullRefreshTableView : UITableView<DAContextMenuCellDelegate>

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;


/**************DAContextMenuCell***********************/
@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property (assign, nonatomic) BOOL customEditing;
/**************DAContextMenuCell***********************/

@property (nonatomic ,assign) BOOL reachedTheEnd;//是否上拉加载更多
@property (nonatomic ,assign) BOOL isUpdData;//是否需要点击重新加载
@property (nonatomic ,strong)UIActivityIndicatorView * centerActivity;//中心指示灯
@property (nonatomic ,strong)UILabel * labelUpdata;

@property (assign ,nonatomic)id<PullRefreshDelegate>PDelegate;
-(void)scrollViewDidPullScroll:(UIScrollView *)scrollView;

/*刷新数据*/
- (void)reloadDataPull;

/*第一次加载数据*/
-(void)LoadDataBegin;
@end

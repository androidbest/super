//
//  MeettingController.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "MeettingView.h"
#import "ActionSheetView.h"
@interface MeettingController : BaseController<ActionSheetViewDetaSource>
@property (strong ,nonatomic)MeettingView * meettingView;
@property (strong ,nonatomic)NSMutableArray * arrDidAllPeople;
@end

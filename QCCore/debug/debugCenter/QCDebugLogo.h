//
//  QCDebugLogo.h
//  QCCore
//
//  Created by XuQian on 1/21/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCDebugLogo : UIView

+ (instancetype)logo;
- (id)init NS_UNAVAILABLE;
- (id)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)reloadView;

@end

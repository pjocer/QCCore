//
//  QCDebugLogo.m
//  QCCore
//
//  Created by XuQian on 1/21/16.
//  Copyright © 2016 qcwl. All rights reserved.
//

#import "QCDebugLogo.h"
#import "QCDebugController.h"
#import "QCAPIRequest.h"
#import "DebugManager.h"
#import "UIDevice+Hardware.h"

@implementation QCDebugLogo
{
    UILabel *roundView;
    UILabel *_memory;
}

+ (instancetype)logo
{
    static QCDebugLogo *logo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logo = [[QCDebugLogo alloc] _init];
    });
    return logo;
}

- (id)_init
{
    CGRect screen = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:CGRectMake(screen.size.width-65, screen.size.height/2, 55, 55)]) {
        self.backgroundColor = [UIColor clearColor];
        
        roundView = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        roundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        roundView.textAlignment = NSTextAlignmentCenter;
        roundView.font = [UIFont systemFontOfSize:13];
        roundView.textColor = [UIColor whiteColor];
        roundView.adjustsFontSizeToFitWidth = YES;
        roundView.minimumScaleFactor = 0.2;
        roundView.clipsToBounds = YES;
        roundView.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] CGColor];
        roundView.layer.borderWidth = 1;
        roundView.layer.cornerRadius = roundView.frame.size.width/2;
        roundView.layer.shadowColor = [[UIColor blackColor] CGColor];
        roundView.layer.shadowOffset = CGSizeMake(0, 0);
        roundView.layer.shadowRadius = 5;
        roundView.layer.shadowOpacity = 0.8;
        [self addSubview:roundView];
        
        _memory = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(roundView.frame), self.frame.size.width, 11)];
        _memory.textColor = [UIColor redColor];
        _memory.font = [UIFont systemFontOfSize:11];
        _memory.backgroundColor = [UIColor clearColor];
        _memory.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_memory];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadMemory) userInfo:nil repeats:YES];
        [timer fire];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        [self reloadLogoText];
    }
    return self;
}

- (void)reloadMemory
{
    _memory.text = [NSString stringWithFormat:@"%.1fMB",[[UIDevice currentDevice] usedMemory]/1024.0/1024.0];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self reloadLogoText];
}

- (void)reloadLogoText
{
    roundView.text = QCCurrentDomain().title;
}

#pragma mark - touch events

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    UIViewController *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if (root.presentedViewController && [root.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *controller = ((UINavigationController *)root.presentedViewController).viewControllers.firstObject;
        if ([controller isKindOfClass:[QCDebugController class]]) {
            return;
        }
    }
    
    QCDebugController *controller = [[QCDebugController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:navi animated:YES completion:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self calculateEndPosition:self.center];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    self.center = point;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.center = [self calculateEndPosition:point];
    }];
}

- (CGPoint)calculateEndPosition:(CGPoint)point
{
    CGPoint _resumePoint = CGPointZero;
    
    if (point.y < 80) {
        // stick to top
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            _resumePoint.x = point.x;
        }
        _resumePoint.y = 25 + self.frame.size.height/2;
    }else if (point.y > self.superview.frame.size.height - 80) {
        // stick to bottom
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            _resumePoint.x = point.x;
        }
        _resumePoint.y = self.superview.frame.size.height - 10 - self.frame.size.height/2;
    }else {
        // stick to left or right
        if (point.x < 10 + self.frame.size.width/2) {
            _resumePoint.x = 10 + self.frame.size.width/2;
        }else if (point.x > self.superview.frame.size.width - 10 - self.frame.size.width/2) {
            _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
        }else {
            if (point.x < self.superview.frame.size.width/2) {
                _resumePoint.x = 10 + self.frame.size.width/2;
            }else {
                _resumePoint.x = self.superview.frame.size.width - 10 - self.frame.size.width/2;
            }
        }
        if (point.y < 20 + self.frame.size.height/2) {
            _resumePoint.y = 20 + self.frame.size.height/2;
        }else if (point.y > self.superview.frame.size.height - 10 - self.frame.size.height/2) {
            _resumePoint.y = self.superview.frame.size.height - 10 - self.frame.size.height/2;
        }else {
            _resumePoint.y = point.y;
        }
    }
    return _resumePoint;
}

@end

//
//  KLNotification.m
//  KLNotification
//
//  Created by 刘昌大 on 2023/5/5.
//

#import "KLNotification.h"

@interface KLNotification ()

@property (nonatomic, copy) NSNotificationName name;

@property (nonatomic, assign) id object;

@property (nonatomic, copy) void (^notifyHandler)(NSDictionary *userInfo);

@property (nonatomic, weak) NSOperationQueue *queue;

@property (nonatomic, assign) BOOL observed;


@property (nonatomic, copy) void (^removeHandler)(void);

@end

@implementation KLNotification

- (instancetype)initWithName:(NSNotificationName)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (KLNotification * _Nonnull (^)(id _Nonnull))withObject {
    KLNotification * (^withObject)(id) = ^(id object) {
        self.object = object;
        return self;
    };
    return withObject;
}

- (void (^)(void (^ _Nonnull)(NSDictionary *)))notified {
    void (^onNoti)(void (^)(NSDictionary *)) = ^(void (^handler)(NSDictionary *)) {
        if (handler != nil) {
            self.notifyHandler = handler;
            if (self.observed) {
                [NSNotificationCenter.defaultCenter removeObserver:self];
            }
            self.observed = YES;
            if (!self.queue) {
                self.queue = NSOperationQueue.currentQueue;
            }
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didNotified:) name:self.name object:self.object];
        }
    };
    return onNoti;
}

- (void)didNotified:(NSNotification *)noti {
    if (self.notifyHandler) {
        if (!self.queue) {
            self.queue = NSOperationQueue.mainQueue;
        }
        [self.queue addOperationWithBlock:^{
            self.notifyHandler(noti.userInfo);
        }];
    }
}

- (void (^)(void))remove {
    void (^remove)(void) = ^{
        if (self.observed) {
            self.observed = NO;
            [NSNotificationCenter.defaultCenter removeObserver:self];
        }
        if (self.removeHandler) {
            self.removeHandler();
            self.removeHandler = nil;
        }
    };
    return remove;
}

- (void)dealloc {
    if (self.observed) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        self.observed = NO;
    }
    NSLog(@"KLNotification dealloc");
}

@end

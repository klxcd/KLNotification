//
//  NSObject+KLNotification.m
//  KLNotification
//
//  Created by 刘昌大 on 2023/5/5.
//

#import "NSObject+KLNotification.h"
#import <objc/runtime.h>

@interface KLNotification ()

@property (nonatomic, copy) void (^removeHandler)(void);

@end

@interface NSObject ()

@property (nonatomic, strong, readonly) NSMutableDictionary<NSNotificationName,KLNotification *> *kl_notifications;

@end

@implementation NSObject (KLNotification)

- (NSMutableDictionary<NSNotificationName,KLNotification *> *)kl_notifications {
    @synchronized (self) {
        NSMutableDictionary<NSNotificationName,KLNotification *> *notifications = objc_getAssociatedObject(self, @selector(kl_notifications));
        if (notifications == nil) {
            notifications = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, @selector(kl_notifications), notifications, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return notifications;
    }
}

- (KLNotification * _Nonnull (^)(NSNotificationName _Nonnull))kl_noti {
    KLNotification *(^noti)(NSNotificationName) = ^(NSNotificationName name) {
        @synchronized (self) {
            if ([self.kl_notifications.allKeys containsObject:name]) {
                return [self.kl_notifications objectForKey:name];
            }
            KLNotification *notification  = [[KLNotification alloc] initWithName:name];
            [self.kl_notifications setObject:notification forKey:name];
            __weak typeof(self) weakSelf = self;
            notification.removeHandler = ^{
                [weakSelf.kl_notifications removeObjectForKey:name];
            };
            return notification;
        }
    };
    return noti;
}

@end

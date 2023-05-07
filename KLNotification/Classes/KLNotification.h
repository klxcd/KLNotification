//
//  KLNotification.h
//  KLNotification
//
//  Created by 刘昌大 on 2023/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLNotification : NSObject

@property (nonatomic, copy, readonly) NSNotificationName name;

@property (nonatomic, copy, readonly) KLNotification * (^withObject)(id object);

@property (nonatomic, copy, readonly) void (^notified)(void (^)(NSDictionary *userInfo));

@property (nonatomic, copy, readonly) void (^remove)(void);

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithName:(NSNotificationName)name;

@end

NS_ASSUME_NONNULL_END

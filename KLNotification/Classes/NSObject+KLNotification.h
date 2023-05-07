//
//  NSObject+KLNotification.h
//  KLNotification
//
//  Created by 刘昌大 on 2023/5/5.
//

#import <Foundation/Foundation.h>
#import "KLNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KLNotification)

@property (nonatomic, copy, readonly) KLNotification *(^kl_noti)(NSNotificationName name);

@end

NS_ASSUME_NONNULL_END

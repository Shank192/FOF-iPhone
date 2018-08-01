//
//  ReachabilityManager.h
//  FOF
//
//  Created by Developer on 23/10/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

+(BOOL)isReachable;

@end


//
//  ReachabilityManager.m
//  FOF
//
//  Created by Developer on 23/10/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

#pragma -
#pragma mark Reachability Manager

+(BOOL)isReachable{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"Please check your network connection");
        return NO;
    }
    
    else
    {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if(status == NotReachable)
        {
            NSLog(@"No internet");
            return NO;
        }
        else if (status == ReachableViaWiFi)
        {
            NSLog(@"Connected to WiFi");
            return YES;
        }
        else if (status == ReachableViaWWAN)
        {
            NSLog(@"Connected to 3G");
            return YES;
        }
    }
        //    CFArrayRef myArray = CNCopySupportedInterfaces();
        //    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        //    //    NSLog(@"SSID: %@",CFDictionaryGetValue(myDict, kCNNetworkInfoKeySSID));
        //    NSString *networkName = CFDictionaryGetValue(myDict, kCNNetworkInfoKeySSID);
        //    NSLog(@"%@ show network name",networkName);
    if (networkStatus == NotReachable)
    {
        NSLog(@"Please check your network connection");
        return NO;
    }else{
        return YES;
    }
}


@end

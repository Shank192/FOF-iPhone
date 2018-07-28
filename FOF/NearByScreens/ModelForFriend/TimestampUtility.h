//
//  TimestampUtility.h
//  FOF
//
//  Created by Developer on 13/09/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TimestampUtility : NSObject

-(NSString*)timeStampToTimeConversion:(NSString*)timeStamp;
-(NSString*)timeDiffeernceFromNowToDate:(NSDate*)aDate;
-(NSInteger)currentTimeConvertedToTimeStamp;

@end

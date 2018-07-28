//
//  TimestampUtility.m
//  FOF
//
//  Created by Developer on 13/09/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import "TimestampUtility.h"

@implementation TimestampUtility

#pragma mark Time stamp conversion

-(NSString*)timeStampToTimeConversion:(NSString*)timeStamp{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSTimeInterval _interval=[timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSString *time = [self timeDiffeernceFromNowToDate:date];
    return time;
}

-(NSString*)timeDiffeernceFromNowToDate:(NSDate*)aDate{
    NSString *current = [self currentDateString];
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:current];
    NSDate *date1 = date;  //now date
    NSDate *date2 = aDate;  //timestamp date
    NSTimeInterval secondsBetween = [date1 timeIntervalSinceDate:date2];
    NSInteger ti = (NSInteger)secondsBetween;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (seconds==0 && minutes==0 && hours==0) {
        return @"Just Now";
    }
    else if (hours>0){
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
        if([today day] == [otherDay day] && [today month] == [otherDay month] && [today year] == [otherDay year])
        {
            return [NSString stringWithFormat:@"%ld hr. %2ld min. ago",(long)hours,(long)minutes];
        }
        else
        {
//            NSString *strAmPm;
            if (today.day-otherDay.day == 1) {

                NSString *minitSecond = [self otherDateHoursString:date2];
                return [NSString stringWithFormat:@"Yesterday %@",minitSecond];
            }
            int monthNumber = otherDay.month;
            NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
            NSString *monthName = [[dateformat monthSymbols] objectAtIndex:(monthNumber-1)];
            monthName = [monthName substringWithRange:NSMakeRange(0, 3)];
            if ([today year] != [otherDay year]) {
                NSInteger yr=today.year=otherDay.year;
                return [NSString stringWithFormat:@"%ld %@ %ld",otherDay.day,monthName,yr];
            }
            NSString *minitSecond = [self otherDateHoursString:date2];
            return [NSString stringWithFormat:@"%ld %@ %@",(long)otherDay.day,monthName,minitSecond];
        }
    }
    else if (minutes > 0)
    {
        return [NSString stringWithFormat:@"%2ld min. ago",(long)minutes];
    }
    else{
        return [NSString stringWithFormat:@"%2ld sec. ago",(long)seconds];
    }
    return [NSString stringWithFormat:@"%2ld min. ago",(long)minutes];
}

-(NSInteger)currentTimeConvertedToTimeStamp{
    NSString *current = [self currentDateString];
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:current];
    NSTimeInterval since1970 = [date timeIntervalSince1970]; // January 1st 1970
    NSInteger result = since1970;
    return result;
}

-(NSString*)currentDateString{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    return dateString;
}

-(NSString*)otherDateHoursString:(NSDate*)otherDate{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm a"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *dateString = [df stringFromDate:otherDate];
    return dateString;
}

@end

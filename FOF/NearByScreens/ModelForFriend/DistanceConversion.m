//
//  DistanceConversion.m
//  FOF
//
//  Created by Developer on 25/09/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import "DistanceConversion.h"

@implementation DistanceConversion

#pragma mark Km to Ml. And Ml. to Km. conversionn

+(NSInteger)mileToKilometerConvresion:(NSUInteger)miles{
    
    //    90 miles ÷ 5 = 18.
    //    90 - 18 = 72.
    //    72 x 2 = 144 kilometers.
    //    miles=80;
    
    NSInteger km=miles/5;
    km=miles-km;
    km=km*2;
    return km;
}

+(NSInteger)kilometersToMilesConversion:(NSUInteger)kilometers{
    NSInteger Ml=kilometers/2;
    NSInteger cal=Ml/4;
    Ml=Ml+cal;
    return Ml;
}


@end

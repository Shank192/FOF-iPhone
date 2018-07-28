//
//  GooglemapCall.h
//  FOF
//
//  Created by Developer on 22/11/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ReachabilityManager.h"
#import "DistanceConversion.h"


@interface GooglemapCall : NSObject

{
    NSMutableArray *arrReviews;
    int n;
    float latVal;
    float lngVal;
    
}
+(GooglemapCall*)sharedGoogleMapApi;
-(void)getPlaceDetailWithPlaceName:(NSString*)place apiKey:(NSString*)apiKey radiusInKms:(NSUInteger)radius restKeyWord:(NSString*)restKeyWord requiredRestaurantDetail:(BOOL)isRestaurantDetailRequred nextPageTokenReference:(NSString*)token withCompletionHandler:(void (^)(NSArray *arrPlaceDetails, NSString *errorMessage, NSArray *arrTokenResult, NSString* nextPageToken,CLLocationCoordinate2D loc, NSInteger radius, NSString *keyWord))completionHandler;

-(void)FindFromFilteredAPIpassLatValue:(float)lattitude lanValue:(float)longitude keyWord:(NSString*)keyWord radius:(NSInteger)radius apiKey:(NSString*)apiKey withCompletionHandler:(void (^) (NSArray *arrPlaceDetails ,NSString *errorMessage))completionHandler;

+(void)autocompleteApiPassApiKey:(NSString*)key searchString:(NSString*)searchStr lat:(CGFloat)lat lng:(CGFloat)lng radius:(CGFloat)radius withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler;

+(void)getLocationFromLat:(CGFloat)lattitude long:(CGFloat)longitude withCompletionHandler:(void (^) (NSDictionary *dictPlaceDetail, NSString *errorMessage))completionHandler;

-(void)distanceMatrixWithSource:(NSString*)source destination:(NSString*)destination withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler;

-(void)distanceMatrixWithSourceCoords:(NSArray*)source destinationCoords:(NSArray*)destination withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler;

+(void)getReviewDetailFromRefID:(NSString*)refUrl withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler;


@property (strong,nonatomic) NSMutableArray *arrPlaceDetails;

@end

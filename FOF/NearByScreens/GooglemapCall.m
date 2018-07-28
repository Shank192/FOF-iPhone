//
//  GooglemapCall.m
//  FOF
//
//  Created by Developer on 22/11/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import "GooglemapCall.h"
#import "FOF-Bridging-Header.h"
#import "FOF-Swift.h"


@implementation GooglemapCall

static GooglemapCall *sharedGoogleMap;

+(GooglemapCall*)sharedGoogleMapApi{
    if (!sharedGoogleMap) {
        sharedGoogleMap = [[GooglemapCall alloc] init];
    }
    return sharedGoogleMap;
}

-(void)getPlaceDetailWithPlaceName:(NSString*)place apiKey:(NSString*)apiKey radiusInKms:(NSUInteger)radius restKeyWord:(NSString*)restKeyWord requiredRestaurantDetail:(BOOL)isRestaurantDetailRequred nextPageTokenReference:(NSString*)token withCompletionHandler:(void (^)(NSArray *arrPlaceDetails, NSString *errorMessage, NSArray *arrTokenResult, NSString* nextPageToken,CLLocationCoordinate2D loc, NSInteger radius, NSString *keyWord))completionHandler{

    CLLocationCoordinate2D nilLocation = CLLocationCoordinate2DMake(0, 0);
    if (![ReachabilityManager isReachable]) {
//        [[self delegate]zeroResultError:@"No Internet Connection"];
        completionHandler(nil,@"No Internet Connection",nil,nil,nilLocation,0,nil);
        return;
    }
    NSDictionary *aDict;
   
    
    NSString *strdistanceUnit = appDel.userDetail.distanceUnit;
    if ([strdistanceUnit isEqualToString:@"Mi"]) {
        radius = [DistanceConversion mileToKilometerConvresion:radius];
    }
    radius = radius*1000;
    
  //  NSLog(@"radius:%ld",radius);
    
    _arrPlaceDetails =[[NSMutableArray alloc]init];
    arrReviews=[[NSMutableArray alloc]init];
    if (token) {
        NSString *urlStr;
        if (restKeyWord==nil || [restKeyWord isEqualToString:@""]) {
            urlStr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%lu&type=restaurant&pagetoken=%@&key=%@",latVal,lngVal,(unsigned long)radius,token,GMAP_API_KEY];
        }else{
            urlStr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%lu&type=restaurant&keyword=%@&pagetoken=%@&key=%@",latVal,lngVal,(unsigned long)radius,restKeyWord,token,GMAP_API_KEY];
        }
        urlStr = [[NSString stringWithFormat:@"%@",urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF32StringEncoding];
     //   NSLog(@"strUrlPlace:%@",urlStr);
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    completionHandler(nil,[error localizedDescription],nil,nil,nilLocation,0,nil);
                    return;
                }
                NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if (![aDict[@"status"] isEqualToString:@"OK"]) {
                    completionHandler(nil,aDict[@"status"],nil,nil,nilLocation,0,nil);
                }
                else{
                    NSArray *arrResult=[aDict valueForKey:@"results"];
                    NSString *nextPage=aDict[@"next_page_token"];
                    
                    NSString *key = restKeyWord;
                    if (!key) {
                        key = @"";
                    } completionHandler(_arrPlaceDetails,nil,arrResult,nextPage,CLLocationCoordinate2DMake(latVal, lngVal),radius,key);
                    [_arrPlaceDetails addObject:aDict];
                }
            });
        }];
        [task resume];
        return;
    }
    NSString *str=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=%@",place,apiKey];
    NSURL *url=[NSURL URLWithString:str];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data!=nil && !error) {
            NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSString *strCheckError=[aDict valueForKey:@"status"];
            if (![strCheckError isEqualToString:@"OK"]) {
                completionHandler(nil,aDict[@"status"],nil,nil,nilLocation,0,nil);
                latVal= appDel.userLocation.latitude;
                lngVal= appDel.userLocation.longitude;
            }
            else
            {
                latVal= [[[[[[aDict valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] floatValue];
                lngVal= [[[[[[aDict valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] floatValue];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (latVal!=0 && lngVal!=0) {
                    [_arrPlaceDetails addObject:aDict];
                    
                    if (isRestaurantDetailRequred) {
                        completionHandler(_arrPlaceDetails,nil,nil,nil,CLLocationCoordinate2DMake(latVal, lngVal),radius,restKeyWord);
                        
                    }
                    else{
                        completionHandler(_arrPlaceDetails,nil,nil,nil,nilLocation,0,nil);
                    }
                }
            });
        }
        //error
        else{
            completionHandler(nil,[aDict valueForKey:@"status"],nil,nil,nilLocation,0,nil);;
        }
    }];
    [task resume];
    
}

#pragma mark -
#pragma mark - Nearby api

-(void)FindFromFilteredAPIpassLatValue:(float)lattitude lanValue:(float)longitude keyWord:(NSString*)keyWord radius:(NSInteger)radius apiKey:(NSString*)apiKey withCompletionHandler:(void (^) (NSArray *arrPlaceDetails ,NSString *errorMessage))completionHandler
{
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connection");
        return;
    }
    NSString *str2;
    if (!keyWord) {
        keyWord=@"";
    }
    str2=[NSString
          stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%ld&type=restaurant&keyword=%@&key=%@",lattitude,longitude,(long)radius,keyWord,apiKey];
   // NSLog(@"restUrl:%@",str2);
    NSURL *url2=[NSURL URLWithString:str2];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session2=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *newTask=[session2 dataTaskWithURL:url2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil,[error localizedDescription]);;
            return;
        }
        NSDictionary *anewDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //handle zero result
        if (![[anewDict valueForKey:@"status"] isEqualToString:@"OK"]) {
            //give zero result Alert
            completionHandler(nil,[anewDict valueForKey:@"status"]);
        }
        else{
            [_arrPlaceDetails addObject:anewDict];
            completionHandler(_arrPlaceDetails,nil);
        }
    }];
    [newTask resume];
}

+(void)getLocationFromLat:(CGFloat)lattitude long:(CGFloat)longitude withCompletionHandler:(void (^) (NSDictionary *dictPlaceDetail, NSString *errorMessage))completionHandler{
    
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connection");
        return;
    }
    NSString *str=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@",lattitude,longitude,GMAP_API_KEY];
    NSURL *url=[NSURL URLWithString:str];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (![aDict[@"status"] isEqualToString:@"OK"]) {
                completionHandler(nil,aDict[@"status"]);
                return ;
            }
            completionHandler(aDict,nil);
        }
        else{
          //  NSLog(@"%@",[error description]);
            completionHandler(nil,[error localizedDescription]);
        }
    }];
    [task resume];
    
}

+(void)autocompleteApiPassApiKey:(NSString*)key searchString:(NSString*)searchStr lat:(CGFloat)lat lng:(CGFloat)lng radius:(CGFloat)radius withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler{
    
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connection");
        return;
    }
    NSString *str=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=%@&location=%f,%f&radius=%f",searchStr,key,lat,lng,radius];
    NSURL *url=[NSURL URLWithString:str];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            completionHandler(aDict,nil);
        }
        else{
          //  NSLog(@"%@",[error description]);
            completionHandler(nil,[error description]);
        }
    }];
    [task resume];
}

-(void)distanceMatrixWithSource:(NSString*)source destination:(NSString*)destination withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler;{
    
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connetion");
        return;
    }
    
    NSURLSessionConfiguration *aConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *aSession=[NSURLSession sessionWithConfiguration:aConfig];
    NSString *str=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=%@&destinations=%@&key=%@",source,destination,GMAP_API_KEY];
    NSURL *url=[NSURL URLWithString:str];
    NSURLSessionDataTask *aTask=[aSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            completionHandler(nil,[error localizedDescription]);
            return ;
        }
        NSDictionary *refDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        [arrReviews addObject:refDict];
        completionHandler(refDict,nil);
    }];
    [aTask resume];
}

-(void)distanceMatrixWithSourceCoords:(NSArray*)source destinationCoords:(NSArray*)destination withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler{
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connection");
        return;
    }
    //encode source
    NSString *strOriginLat=[self stringByAddingPercentEncodingForFormData:YES aString:source[0]];
    NSString *strOriginLng=[self stringByAddingPercentEncodingForFormData:YES aString:source[1]];
    NSString *strEncodedOrigin=[NSString stringWithFormat:@"%@,%@",strOriginLat,strOriginLng];
    //encode destination
    NSString *strForEncode;
    for (int i=0; i<destination.count; i++) {
        if (i==0) {
            strForEncode=destination[0];
            continue;
        }
        strForEncode=[strForEncode stringByAppendingString:destination[i]];
    }
    NSString *strEncodedDestiny=[self stringByAddingPercentEncodingForFormData:YES aString:strForEncode];
    NSString *str=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=%@&destinations=%@&key=%@",strEncodedOrigin,strEncodedDestiny,GMAP_API_KEY];
    NSURLSessionConfiguration *aConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *aSession=[NSURLSession sessionWithConfiguration:aConfig];
    NSURL *url=[NSURL URLWithString:str];
    NSURLSessionDataTask *aTask=[aSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            completionHandler(nil,[error localizedDescription]);
            return;
        }
        NSDictionary *refDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        completionHandler(refDict,nil);
      //  NSLog(@"%@",refDict);
    }];
    [aTask resume];
    
}

+(void)getReviewDetailFromRefID:(NSString*)refUrl withCompletionHandler:(void (^) (NSDictionary *response, NSString *errorMessage))completionHandler{
    if (![ReachabilityManager isReachable]) {
        completionHandler(nil,@"No Internet Connection");
        return;
    }
    NSURLSessionConfiguration *aConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *aSession=[NSURLSession sessionWithConfiguration:aConfig];
    NSString *strUrl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@",refUrl,GMAP_API_KEY];
    NSURL *aUrl=[NSURL URLWithString:strUrl];
    NSURLSessionDataTask *aTask=[aSession dataTaskWithURL:aUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *refDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (![refDict[@"status"] isEqualToString:@"OK"]) {
                completionHandler(nil,refDict[@"status"]);
            }
            completionHandler(refDict,nil);

        }else{
           // NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [aTask resume];
}

#pragma mark -
#pragma mark - encode URL

- (nullable NSString *)stringByAddingPercentEncodingForFormData:(BOOL)plusForSpace aString:(NSString*)aStr{
    NSString *unreserved = @"*-._";
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                      alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    if (plusForSpace) {
        [allowed addCharactersInString:@" "];
    }
    NSString *encoded = [aStr stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    if (plusForSpace) {
        encoded = [encoded stringByReplacingOccurrencesOfString:@" "
                                                     withString:@"+"];
    }
    return encoded;
}
@end

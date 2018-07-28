//
//  RestDistanceManage.m
//  FOF
//
//  Created by Developer on 04/10/17.
//  Copyright © 2017 ngeleousera. All rights reserved.
//

#import "RestDistanceManage.h"
#import "FOF-Bridging-Header.h"
#import "CommonCFile.h"
#import "FOF-Swift.h"

@implementation RestDistanceManage

-(id)init{
    return self;
}

-(void)currentTotalCounts:(NSInteger)counts nextPageToken:(NSString*)nextPageToken{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *address;
        
        
        
//        if (!app.strSearchedPlace) {
        address = @"Dheeraj Enclave, Wadala West, Wadala, Mumbai, Maharashtra 400031, India";//app.strCurrentPlace;
//        }
//        else{
//            address = app.strSearchedPlace;
//        }
        address=[self stringByAddingPercentEncodingForFormData:YES aString:address];
        
        NSString *strDistance = @"";
        
//        if (!app.strRestuarantDistance) {
//            strDistance = @"3";
//        }
//        else{
//            strDistance = app.strRestuarantDistance;
//        }
        //Set keyword
        
        NSString *strKeyword;
//        if (app.strSearchedCatagory) {
//            strKeyword = app.strSearchedCatagory;
//        }
//        else{
            strKeyword = nil;
//        }
        strKeyword = [self stringByAddingPercentEncodingForFormData:YES aString:strKeyword];
        
        //            [apiMethods PlaceAPIpassPlaceName:address apiKey:GMAP_API_KEY radiusInKms:strDistance.integerValue restKeyWord:strKeyword requiredRestaurantDetail:YES nextPageTokenReference:nextPageToken];
//        if (!address) {
//            [app locateLocationManager:_srvc];
//        }
        [self callPlaceDetailBlockWithAddress:address radius:strDistance.integerValue keyWord:strKeyword requiredRestDetail:YES nextPageToken:nextPageToken];
    });
}

#pragma mark -
#pragma mark Restaurants to array

-(void)addDetailToRestDetailArray:(NSDictionary*)restDetail orArrDetail:(NSArray*)arrDetail{
    if (!_mutArrRestDetail) {
        _mutArrRestDetail=[[NSMutableArray alloc]init];
        _mutArrCoords=[[NSMutableArray alloc]init];
        _arrDestinyCoords=[[NSMutableArray alloc] init];
        _dictSortDistance = [[NSMutableDictionary alloc]init];
    }
    
    NSArray *arr;
    if (restDetail) {
        arr = restDetail[@"results"];
    }
    else{
        arr=arrDetail;
    }
    for (int n=0; n<arr.count; n++) {
        if ([arr[n][@"types"] containsObject:@"spa"] || [arr[n][@"types"] containsObject:@"lodging"]) {
            //not to add
        }
        else
        {
            NSString *strPhotoRef=arr[n][@"photos"][0][@"photo_reference"];
            if (!strPhotoRef) {
                strPhotoRef=@"";
            }
            NSDictionary *dicLocation=arr[n][@"geometry"][@"location"];
            NSString *str = [NSString stringWithFormat:@"%@,%@|",dicLocation[@"lat"],dicLocation[@"lng"]];
            [_arrDestinyCoords addObject:str];
            [_mutArrCoords addObject:@{@"lat":dicLocation[@"lat"],@"lan":dicLocation[@"lng"]}];
            NSString *strLat=arr[n][@"geometry"][@"location"][@"lat"];
            NSString *strLng=arr[n][@"geometry"][@"location"][@"lng"];
            NSString *priceLevel=arr[n][@"price_level"];
            NSInteger priceLevelInt = 0;
            if (priceLevel) {
                priceLevelInt = priceLevel.integerValue;
            }
            NSString *strOpenNow = arr[n][@"opening_hours"][@"open_now"];
            if (strOpenNow==nil) {
                strOpenNow=@"0";
            }
            NSNumber *rating = arr[n][@"rating"];
            if (!rating) {
                rating = [NSNumber numberWithFloat:0.0f];
            }
            if (!arr[n][@"name"]) {
                [[self delegate] reloadAllRestaurants];
                return;
            }
            NSDictionary *adict = @{@"RestName":arr[n][@"name"],
                                    @"Time":@"time",
                                    @"Rating":rating,
                                    @"PhotoUrl":strPhotoRef,
                                    @"lattitude":strLat,
                                    @"longitude":strLng,
                                    @"vicinity":arr[n][@"vicinity"],
                                    @"price_level":[NSNumber numberWithInteger:priceLevelInt],
                                    @"isSelected":@YES,
                                    @"posInList":@0,
                                    @"Selected":@"No",
                                    @"phoneNumber":@"",
                                    @"placeid":arr[n][@"place_id"],
                                    @"timeToReach":@"",
                                    @"timings":@"",
                                    @"url":@"",
                                    @"website":@"",
                                    @"websiteUrl":@"",
                                    @"open_now":strOpenNow,
                                    @"formatted_phone_number":@"",
                                    @"description":@"",
                                    @"cuisine":@"",
                                    @"reference":arr[n][@"reference"],
                                    @"duration":@"",
                                    @"value":@""
                                    };
            [_mutArrRestDetail addObject:adict.mutableCopy];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *sourceLat;
        NSString *sourceLng;
        
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (app.searchedLocation.latitude != 0.000000 && app.searchedLocation.longitude != 0.000000 && !self->_isLocationEmpty) {
            
            sourceLat = [NSString stringWithFormat:@"%f",appDel.searchedLocation.latitude];
            sourceLng = [NSString stringWithFormat:@"%f",appDel.searchedLocation.longitude];
            
        }
        else
        {
            sourceLat=[NSString stringWithFormat:@"%f",appDel.userLocation.latitude];
            sourceLng=[NSString stringWithFormat:@"%f",appDel.userLocation.longitude];
        }
//        [apiMethods distanceMatrixAPISourceCoords:@[sourceLat,sourceLng] destinationCoordsArray:_arrDestinyCoords];
        if (self->_mutArrRestDetail.count==0) {
            [[self delegate]finalRestaurantsWithDistance:_mutArrRestDetail andTokenstring:nil];
        }else{
             [self callDistanceMatrixWithSourceArray:@[sourceLat,sourceLng] destinationArray:_arrDestinyCoords];
        }
       
    });
}

#pragma mark -
#pragma mark Restaurant detail api

-(void)callRestViewApi{
    //    NSString *strSearchedPlace = appDel.strSearchedPlace;
    //    NSString *strSearchedCatagory = appDel.strSearchedCatagory;
    //    NSString *strCurrentPlace = appDel.strCurrentPlace;
    //    NSString *strRestuarantDistance = appDel.strRestuarantDistance;
    //
    //    NSLog(@"%@,%@,%@,%@",strSearchedPlace,strSearchedCatagory,strCurrentPlace,strRestuarantDistance);
    //Set address
}

#pragma mark -
#pragma mark DiatnceMatrix delegate

-(void)distnaceMatrix:(NSDictionary *)dictDistanceMatrix errorMessage:(NSString *)errorMessage{
}

#pragma mark encode URL

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


#pragma mark Gmap Api delegates

-(void)getDetailOfPlace:(NSArray*)arrPlaceDetail errorMessage:(NSString*)errorMessage;{
    
    //NSLog(@"%@",arrPlaceDetail);
    
    //NSArray *placeDetail=[arrPlaceDetail objectAtIndex:0];
    
    if (arrPlaceDetail[0][@"next_page_token"]) {
        strToken = arrPlaceDetail[0][@"next_page_token"];
    }else{
        if (arrPlaceDetail.count == 2) {
            strToken = arrPlaceDetail[1][@"next_page_token"];
        }
    }
    
    NSDictionary *restDetail=[arrPlaceDetail objectAtIndex:1];
    
    [self addDetailToRestDetailArray:restDetail orArrDetail:nil];
    
}

-(void)tokenresult:(NSArray *)arrTokekenResult strNextToken:(NSString *)nextPageToken{
    
    strToken = nextPageToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDetailToRestDetailArray:nil orArrDetail:arrTokekenResult];
    });
}

-(void)callPlaceDetailBlockWithAddress:(NSString*)address radius:(NSInteger)radius keyWord:(NSString*)keyWord requiredRestDetail:(BOOL)isReqired nextPageToken:(NSString*)nextPage{
    [gmapApi getPlaceDetailWithPlaceName:address apiKey:GMAP_API_KEY radiusInKms:radius restKeyWord:keyWord requiredRestaurantDetail:isReqired nextPageTokenReference:nextPage withCompletionHandler:^(NSArray *arrPlaceDetails, NSString *errorMessage, NSArray *arrTokenResult, NSString *nextPageToken, CLLocationCoordinate2D loc, NSInteger radius, NSString *keyWord) {
        if (arrTokenResult) {
            [self tokenresult:arrTokenResult strNextToken:nextPage];
        }
        else
        {
            if (nextPage) {
                radius=radius/1000;
            }
            if (radius==0) {
                radius=1000;
            }
            [gmapApi FindFromFilteredAPIpassLatValue:loc.latitude lanValue:loc.longitude keyWord:keyWord radius:radius apiKey:GMAP_API_KEY withCompletionHandler:^(NSArray *arrPlaceDetails, NSString *errorMessage) {
                if (!errorMessage) {
                    [self getDetailOfPlace:arrPlaceDetails errorMessage:errorMessage];
                }
                else
                {
                    [self getDetailOfPlace:nil errorMessage:errorMessage];
//                    [[HUDIndicatorManage shredHudIndicator] stopHudIndicator];
                }
            }];
        }
    }];
}

-(void)callDistanceMatrixWithSourceArray:(NSArray*)source destinationArray:(NSArray*)destination{
    [gmapApi distanceMatrixWithSourceCoords:source destinationCoords:destination withCompletionHandler:^(NSDictionary *response, NSString *errorMessage) {
        NSArray *arrRows = response[@"rows"];
        NSArray *arrRestDistances;
        if (arrRows.count!=0) {
            arrRestDistances=arrRows[0][@"elements"];
            if ([[arrRestDistances firstObject][@"status"] isEqualToString:@"NOT_FOUND"]) {
//                [[HUDIndicatorManage shredHudIndicator] stopHudIndicator];
                return;
            }
            int j = 0;
            if (_mutArrCoords.count != 0) {
                for (int n = 0; n<arrRestDistances.count; n++) {
                    NSString *strKey = [NSString stringWithFormat:@"%@,%@",_mutArrCoords[n][@"lat"],_mutArrCoords[n][@"lan"]];
                    NSString *value = [NSString stringWithFormat:@"%@,%@",arrRestDistances[n][@"duration"][@"value"],arrRestDistances[n][@"duration"][@"text"]];
                    if ([_dictSortDistance.allKeys containsObject:strKey]) {
                        if (_isFirstSearch) {
                            j++;
                            strKey = [NSString stringWithFormat:@"%@00%d,%@00%d",_mutArrCoords[n][@"lat"],j,_mutArrCoords[n][@"lan"],j];
                        }
                    }
                    [_dictSortDistance setObject:value forKey:strKey];
                }
            }
            
            if (_mutArrRestDetail.count != _dictSortDistance.allKeys.count)
            {
                //[[self delegate] setToZeroResults];
                if ([_delegate respondsToSelector:@selector(stopIndicator)]) {
                     [[self delegate] stopIndicator];
                }
                return;
            }
            for (int n = 0; n<_dictSortDistance.allKeys.count; n++) {
                NSString *str = [NSString stringWithFormat:@"%@,%@",_mutArrRestDetail[n][@"lattitude"],_mutArrRestDetail[n][@"longitude"]];
                NSString *aValue = [_dictSortDistance valueForKey:str];
                NSArray *arr = [aValue componentsSeparatedByString:@","];
                NSString *val = arr[0];
                NSString *duration = arr[1];
                _mutArrRestDetail[n][@"value"] = @(val.integerValue);
                _mutArrRestDetail[n][@"duration"] = duration;
            }
        }
        if (_isFirstSearch) {
            _isFirstSearch = NO;
        }
        if (_mutArrRestDetail.count == _dictSortDistance.allKeys.count) {
            [[self delegate]finalRestaurantsWithDistance:_mutArrRestDetail andTokenstring:strToken];
        }
        else{
//            NSLog(@"%@",_mutArrRestDetail);
//            NSLog(@"%@",_dictSortDistance);
//            NSLog(@"%@",_mutArrCoords);
        }
    }];
}




@end

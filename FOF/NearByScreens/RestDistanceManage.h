//
//  RestDistanceManage.h

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GooglemapCall.h"

@protocol RestDistanceManageDelegate <NSObject>

-(void)finalRestaurantsWithDistance:(NSArray*)restaurants andTokenstring:(NSString*)token;
-(void)stopIndicator;
-(void)reloadAllRestaurants;
-(void)setToZeroResults;
@end

@interface RestDistanceManage : NSObject
{
    NSString *strToken;
    
}

#pragma mark - properties

@property (nonatomic, weak) id<RestDistanceManageDelegate>delegate;

@property (nonatomic,strong) NSMutableArray *mutArrRestDetail;
@property (nonatomic,strong) NSMutableDictionary *dictSortDistance;
@property (nonatomic,strong) NSMutableArray *mutArrCoords;
@property (nonatomic,strong) NSMutableArray *arrDestinyCoords;
@property (nonatomic,assign) BOOL isFirstSearch;
@property (assign, nonatomic)BOOL isLocationEmpty;

#pragma mark - Other Methods

-(void)currentTotalCounts:(NSInteger)counts nextPageToken:(NSString*)nextPageToken;

@end

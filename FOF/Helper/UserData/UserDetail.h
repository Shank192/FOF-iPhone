//
//  UserDetail.h
//
//  Created by   on 19/12/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserDetail : NSObject <NSCoding, NSCopying>


@property (nonatomic, strong) NSString *devicetoken;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *devicetype;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *profilepic4;
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *socialId;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, strong) NSString *isreviewed;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) NSString *testbuds;
@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *isShowLocation;
@property (nonatomic, strong) NSString *profilepic3;
@property (nonatomic, strong) NSString *searchMinAge;
@property (nonatomic, strong) NSString *ethnicity;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *refercode;
@property (nonatomic, assign) BOOL isregistered;
@property (nonatomic, strong) NSString *updatedat;
@property (nonatomic, strong) NSString *profilepic2;
@property (nonatomic, strong) NSString *profilepic9;
@property (nonatomic, strong) NSString *isReceiveInvitationNotifications;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *searchMaxAge;
@property (nonatomic, strong) NSString *profilepic1;
@property (nonatomic, strong) NSString *profilepic8;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *distanceUnit;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *occupation;
@property (nonatomic, strong) NSString *profilepic7;
@property (nonatomic, strong) NSString *showme;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *profilepic6;
@property (nonatomic, strong) NSString *createdat;
@property (nonatomic, strong) NSString *isspam;
@property (nonatomic, strong) NSString *isReceiveMessagesNotifications;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *profilepic5;
@property (nonatomic, strong) NSString *searchDistance;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

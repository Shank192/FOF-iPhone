//
//  UserDetail.m
//
//  Created by   on 19/12/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "UserDetail.h"


NSString *const kUserDetailDevicetoken = @"devicetoken";
NSString *const kUserDetailLastName = @"last_name";
NSString *const kUserDetailDevicetype = @"devicetype";
NSString *const kUserDetailId = @"id";
NSString *const kUserDetailProfilepic4 = @"profilepic4";
NSString *const kUserDetailEducation = @"education";
NSString *const kUserDetailSocialId = @"social_id";
NSString *const kUserDetailRelationship = @"relationship";
NSString *const kUserDetailIsreviewed = @"isreviewed";
NSString *const kUserDetailLocationString = @"location_string";
NSString *const kUserDetailTestbuds = @"testbuds";
NSString *const kUserDetailSessionid = @"sessionid";
NSString *const kUserDetailLocation = @"location";
NSString *const kUserDetailIsShowLocation = @"is_show_location";
NSString *const kUserDetailProfilepic3 = @"profilepic3";
NSString *const kUserDetailSearchMinAge = @"search_min_age";
NSString *const kUserDetailEthnicity = @"ethnicity";
NSString *const kUserDetailDob = @"dob";
NSString *const kUserDetailRefercode = @"refercode";
NSString *const kUserDetailIsregistered = @"isregistered";
NSString *const kUserDetailUpdatedat = @"updatedat";
NSString *const kUserDetailProfilepic2 = @"profilepic2";
NSString *const kUserDetailProfilepic9 = @"profilepic9";
NSString *const kUserDetailIsReceiveInvitationNotifications = @"is_receive_invitation_notifications";
NSString *const kUserDetailEmail = @"email";
NSString *const kUserDetailSearchMaxAge = @"search_max_age";
NSString *const kUserDetailProfilepic1 = @"profilepic1";
NSString *const kUserDetailProfilepic8 = @"profilepic8";
NSString *const kUserDetailAboutMe = @"about_me";
NSString *const kUserDetailAccessToken = @"access_token";
NSString *const kUserDetailAccountType = @"account_type";
NSString *const kUserDetailDistanceUnit = @"distance_unit";
NSString *const kUserDetailMobile = @"mobile";
NSString *const kUserDetailFirstName = @"first_name";
NSString *const kUserDetailOccupation = @"occupation";
NSString *const kUserDetailProfilepic7 = @"profilepic7";
NSString *const kUserDetailShowme = @"showme";
NSString *const kUserDetailGender = @"gender";
NSString *const kUserDetailProfilepic6 = @"profilepic6";
NSString *const kUserDetailCreatedat = @"createdat";
NSString *const kUserDetailIsspam = @"isspam";
NSString *const kUserDetailIsReceiveMessagesNotifications = @"is_receive_messages_notifications";
NSString *const kUserDetailReference = @"reference";
NSString *const kUserDetailPassword = @"password";
NSString *const kUserDetailProfilepic5 = @"profilepic5";
NSString *const kUserDetailSearchDistance = @"search_distance";


@interface UserDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserDetail

@synthesize devicetoken = _devicetoken;
@synthesize lastName = _lastName;
@synthesize devicetype = _devicetype;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize profilepic4 = _profilepic4;
@synthesize education = _education;
@synthesize socialId = _socialId;
@synthesize relationship = _relationship;
@synthesize isreviewed = _isreviewed;
@synthesize locationString = _locationString;
@synthesize testbuds = _testbuds;
@synthesize sessionid = _sessionid;
@synthesize location = _location;
@synthesize isShowLocation = _isShowLocation;
@synthesize profilepic3 = _profilepic3;
@synthesize searchMinAge = _searchMinAge;
@synthesize ethnicity = _ethnicity;
@synthesize dob = _dob;
@synthesize refercode = _refercode;
@synthesize isregistered = _isregistered;
@synthesize updatedat = _updatedat;
@synthesize profilepic2 = _profilepic2;
@synthesize profilepic9 = _profilepic9;
@synthesize isReceiveInvitationNotifications = _isReceiveInvitationNotifications;
@synthesize email = _email;
@synthesize searchMaxAge = _searchMaxAge;
@synthesize profilepic1 = _profilepic1;
@synthesize profilepic8 = _profilepic8;
@synthesize aboutMe = _aboutMe;
@synthesize accessToken = _accessToken;
@synthesize accountType = _accountType;
@synthesize distanceUnit = _distanceUnit;
@synthesize mobile = _mobile;
@synthesize firstName = _firstName;
@synthesize occupation = _occupation;
@synthesize profilepic7 = _profilepic7;
@synthesize showme = _showme;
@synthesize gender = _gender;
@synthesize profilepic6 = _profilepic6;
@synthesize createdat = _createdat;
@synthesize isspam = _isspam;
@synthesize isReceiveMessagesNotifications = _isReceiveMessagesNotifications;
@synthesize reference = _reference;
@synthesize password = _password;
@synthesize profilepic5 = _profilepic5;
@synthesize searchDistance = _searchDistance;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        
        
            self.devicetoken = [self objectOrNilForKey:kUserDetailDevicetoken fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kUserDetailLastName fromDictionary:dict];
            self.devicetype = [self objectOrNilForKey:kUserDetailDevicetype fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kUserDetailId fromDictionary:dict];
            self.profilepic4 = [self objectOrNilForKey:kUserDetailProfilepic4 fromDictionary:dict];
            self.education = [self objectOrNilForKey:kUserDetailEducation fromDictionary:dict];
            self.socialId = [self objectOrNilForKey:kUserDetailSocialId fromDictionary:dict];
            self.relationship = [self objectOrNilForKey:kUserDetailRelationship fromDictionary:dict];
            self.isreviewed = [self objectOrNilForKey:kUserDetailIsreviewed fromDictionary:dict];
            self.locationString = [self objectOrNilForKey:kUserDetailLocationString fromDictionary:dict];
            self.testbuds = [self objectOrNilForKey:kUserDetailTestbuds fromDictionary:dict];
            self.sessionid = [self objectOrNilForKey:kUserDetailSessionid fromDictionary:dict];
            self.location = [self objectOrNilForKey:kUserDetailLocation fromDictionary:dict];
            self.isShowLocation = [self objectOrNilForKey:kUserDetailIsShowLocation fromDictionary:dict];
            self.profilepic3 = [self objectOrNilForKey:kUserDetailProfilepic3 fromDictionary:dict];
            self.searchMinAge = [self objectOrNilForKey:kUserDetailSearchMinAge fromDictionary:dict];
            self.ethnicity = [self objectOrNilForKey:kUserDetailEthnicity fromDictionary:dict];
            self.dob = [self objectOrNilForKey:kUserDetailDob fromDictionary:dict];
            self.refercode = [self objectOrNilForKey:kUserDetailRefercode fromDictionary:dict];
            self.isregistered = [[self objectOrNilForKey:kUserDetailIsregistered fromDictionary:dict] boolValue];
            self.updatedat = [self objectOrNilForKey:kUserDetailUpdatedat fromDictionary:dict];
            self.profilepic2 = [self objectOrNilForKey:kUserDetailProfilepic2 fromDictionary:dict];
            self.profilepic9 = [self objectOrNilForKey:kUserDetailProfilepic9 fromDictionary:dict];
            self.isReceiveInvitationNotifications = [self objectOrNilForKey:kUserDetailIsReceiveInvitationNotifications fromDictionary:dict];
            self.email = [self objectOrNilForKey:kUserDetailEmail fromDictionary:dict];
            self.searchMaxAge = [self objectOrNilForKey:kUserDetailSearchMaxAge fromDictionary:dict];
            self.profilepic1 = [self objectOrNilForKey:kUserDetailProfilepic1 fromDictionary:dict];
            self.profilepic8 = [self objectOrNilForKey:kUserDetailProfilepic8 fromDictionary:dict];
            self.aboutMe = [self objectOrNilForKey:kUserDetailAboutMe fromDictionary:dict];
            self.accessToken = [self objectOrNilForKey:kUserDetailAccessToken fromDictionary:dict];
            self.accountType = [self objectOrNilForKey:kUserDetailAccountType fromDictionary:dict];
            self.distanceUnit = [self objectOrNilForKey:kUserDetailDistanceUnit fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kUserDetailMobile fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kUserDetailFirstName fromDictionary:dict];
            self.occupation = [self objectOrNilForKey:kUserDetailOccupation fromDictionary:dict];
            self.profilepic7 = [self objectOrNilForKey:kUserDetailProfilepic7 fromDictionary:dict];
            self.showme = [self objectOrNilForKey:kUserDetailShowme fromDictionary:dict];
            self.gender = [self objectOrNilForKey:kUserDetailGender fromDictionary:dict];
            self.profilepic6 = [self objectOrNilForKey:kUserDetailProfilepic6 fromDictionary:dict];
            self.createdat = [self objectOrNilForKey:kUserDetailCreatedat fromDictionary:dict];
            self.isspam = [self objectOrNilForKey:kUserDetailIsspam fromDictionary:dict];
            self.isReceiveMessagesNotifications = [self objectOrNilForKey:kUserDetailIsReceiveMessagesNotifications fromDictionary:dict];
            self.reference = [self objectOrNilForKey:kUserDetailReference fromDictionary:dict];
            self.password = [self objectOrNilForKey:kUserDetailPassword fromDictionary:dict];
            self.profilepic5 = [self objectOrNilForKey:kUserDetailProfilepic5 fromDictionary:dict];
            self.searchDistance = [self objectOrNilForKey:kUserDetailSearchDistance fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.devicetoken forKey:kUserDetailDevicetoken];
    [mutableDict setValue:self.lastName forKey:kUserDetailLastName];
    [mutableDict setValue:self.devicetype forKey:kUserDetailDevicetype];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kUserDetailId];
    [mutableDict setValue:self.profilepic4 forKey:kUserDetailProfilepic4];
    [mutableDict setValue:self.education forKey:kUserDetailEducation];
    [mutableDict setValue:self.socialId forKey:kUserDetailSocialId];
    [mutableDict setValue:self.relationship forKey:kUserDetailRelationship];
    [mutableDict setValue:self.isreviewed forKey:kUserDetailIsreviewed];
    [mutableDict setValue:self.locationString forKey:kUserDetailLocationString];
    [mutableDict setValue:self.testbuds forKey:kUserDetailTestbuds];
    [mutableDict setValue:self.sessionid forKey:kUserDetailSessionid];
    [mutableDict setValue:self.location forKey:kUserDetailLocation];
    [mutableDict setValue:self.isShowLocation forKey:kUserDetailIsShowLocation];
    [mutableDict setValue:self.profilepic3 forKey:kUserDetailProfilepic3];
    [mutableDict setValue:self.searchMinAge forKey:kUserDetailSearchMinAge];
    [mutableDict setValue:self.ethnicity forKey:kUserDetailEthnicity];
    [mutableDict setValue:self.dob forKey:kUserDetailDob];
    [mutableDict setValue:self.refercode forKey:kUserDetailRefercode];
    [mutableDict setValue:[NSNumber numberWithBool:self.isregistered] forKey:kUserDetailIsregistered];
    [mutableDict setValue:self.updatedat forKey:kUserDetailUpdatedat];
    [mutableDict setValue:self.profilepic2 forKey:kUserDetailProfilepic2];
    [mutableDict setValue:self.profilepic9 forKey:kUserDetailProfilepic9];
    [mutableDict setValue:self.isReceiveInvitationNotifications forKey:kUserDetailIsReceiveInvitationNotifications];
    [mutableDict setValue:self.email forKey:kUserDetailEmail];
    [mutableDict setValue:self.searchMaxAge forKey:kUserDetailSearchMaxAge];
    [mutableDict setValue:self.profilepic1 forKey:kUserDetailProfilepic1];
    [mutableDict setValue:self.profilepic8 forKey:kUserDetailProfilepic8];
    [mutableDict setValue:self.aboutMe forKey:kUserDetailAboutMe];
    [mutableDict setValue:self.accessToken forKey:kUserDetailAccessToken];
    [mutableDict setValue:self.accountType forKey:kUserDetailAccountType];
    [mutableDict setValue:self.distanceUnit forKey:kUserDetailDistanceUnit];
    [mutableDict setValue:self.mobile forKey:kUserDetailMobile];
    [mutableDict setValue:self.firstName forKey:kUserDetailFirstName];
    [mutableDict setValue:self.occupation forKey:kUserDetailOccupation];
    [mutableDict setValue:self.profilepic7 forKey:kUserDetailProfilepic7];
    [mutableDict setValue:self.showme forKey:kUserDetailShowme];
    [mutableDict setValue:self.gender forKey:kUserDetailGender];
    [mutableDict setValue:self.profilepic6 forKey:kUserDetailProfilepic6];
    [mutableDict setValue:self.createdat forKey:kUserDetailCreatedat];
    [mutableDict setValue:self.isspam forKey:kUserDetailIsspam];
    [mutableDict setValue:self.isReceiveMessagesNotifications forKey:kUserDetailIsReceiveMessagesNotifications];
    [mutableDict setValue:self.reference forKey:kUserDetailReference];
    [mutableDict setValue:self.password forKey:kUserDetailPassword];
    [mutableDict setValue:self.profilepic5 forKey:kUserDetailProfilepic5];
    [mutableDict setValue:self.searchDistance forKey:kUserDetailSearchDistance];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
//    if ([object isEqual:[NSNull null]]) {
//
//    }
    return [object isEqual:[NSNull null]] ? @"" : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.devicetoken = [aDecoder decodeObjectForKey:kUserDetailDevicetoken];
    self.lastName = [aDecoder decodeObjectForKey:kUserDetailLastName];
    self.devicetype = [aDecoder decodeObjectForKey:kUserDetailDevicetype];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kUserDetailId];
    self.profilepic4 = [aDecoder decodeObjectForKey:kUserDetailProfilepic4];
    self.education = [aDecoder decodeObjectForKey:kUserDetailEducation];
    self.socialId = [aDecoder decodeObjectForKey:kUserDetailSocialId];
    self.relationship = [aDecoder decodeObjectForKey:kUserDetailRelationship];
    self.isreviewed = [aDecoder decodeObjectForKey:kUserDetailIsreviewed];
    self.locationString = [aDecoder decodeObjectForKey:kUserDetailLocationString];
    self.testbuds = [aDecoder decodeObjectForKey:kUserDetailTestbuds];
    self.sessionid = [aDecoder decodeObjectForKey:kUserDetailSessionid];
    self.location = [aDecoder decodeObjectForKey:kUserDetailLocation];
    self.isShowLocation = [aDecoder decodeObjectForKey:kUserDetailIsShowLocation];
    self.profilepic3 = [aDecoder decodeObjectForKey:kUserDetailProfilepic3];
    self.searchMinAge = [aDecoder decodeObjectForKey:kUserDetailSearchMinAge];
    self.ethnicity = [aDecoder decodeObjectForKey:kUserDetailEthnicity];
    self.dob = [aDecoder decodeObjectForKey:kUserDetailDob];
    self.refercode = [aDecoder decodeObjectForKey:kUserDetailRefercode];
    self.isregistered = [aDecoder decodeBoolForKey:kUserDetailIsregistered];
    self.updatedat = [aDecoder decodeObjectForKey:kUserDetailUpdatedat];
    self.profilepic2 = [aDecoder decodeObjectForKey:kUserDetailProfilepic2];
    self.profilepic9 = [aDecoder decodeObjectForKey:kUserDetailProfilepic9];
    self.isReceiveInvitationNotifications = [aDecoder decodeObjectForKey:kUserDetailIsReceiveInvitationNotifications];
    self.email = [aDecoder decodeObjectForKey:kUserDetailEmail];
    self.searchMaxAge = [aDecoder decodeObjectForKey:kUserDetailSearchMaxAge];
    self.profilepic1 = [aDecoder decodeObjectForKey:kUserDetailProfilepic1];
    self.profilepic8 = [aDecoder decodeObjectForKey:kUserDetailProfilepic8];
    self.aboutMe = [aDecoder decodeObjectForKey:kUserDetailAboutMe];
    self.accessToken = [aDecoder decodeObjectForKey:kUserDetailAccessToken];
    self.accountType = [aDecoder decodeObjectForKey:kUserDetailAccountType];
    self.distanceUnit = [aDecoder decodeObjectForKey:kUserDetailDistanceUnit];
    self.mobile = [aDecoder decodeObjectForKey:kUserDetailMobile];
    self.firstName = [aDecoder decodeObjectForKey:kUserDetailFirstName];
    self.occupation = [aDecoder decodeObjectForKey:kUserDetailOccupation];
    self.profilepic7 = [aDecoder decodeObjectForKey:kUserDetailProfilepic7];
    self.showme = [aDecoder decodeObjectForKey:kUserDetailShowme];
    self.gender = [aDecoder decodeObjectForKey:kUserDetailGender];
    self.profilepic6 = [aDecoder decodeObjectForKey:kUserDetailProfilepic6];
    self.createdat = [aDecoder decodeObjectForKey:kUserDetailCreatedat];
    self.isspam = [aDecoder decodeObjectForKey:kUserDetailIsspam];
    self.isReceiveMessagesNotifications = [aDecoder decodeObjectForKey:kUserDetailIsReceiveMessagesNotifications];
    self.reference = [aDecoder decodeObjectForKey:kUserDetailReference];
    self.password = [aDecoder decodeObjectForKey:kUserDetailPassword];
    self.profilepic5 = [aDecoder decodeObjectForKey:kUserDetailProfilepic5];
    self.searchDistance = [aDecoder decodeObjectForKey:kUserDetailSearchDistance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_devicetoken forKey:kUserDetailDevicetoken];
    [aCoder encodeObject:_lastName forKey:kUserDetailLastName];
    [aCoder encodeObject:_devicetype forKey:kUserDetailDevicetype];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kUserDetailId];
    [aCoder encodeObject:_profilepic4 forKey:kUserDetailProfilepic4];
    [aCoder encodeObject:_education forKey:kUserDetailEducation];
    [aCoder encodeObject:_socialId forKey:kUserDetailSocialId];
    [aCoder encodeObject:_relationship forKey:kUserDetailRelationship];
    [aCoder encodeObject:_isreviewed forKey:kUserDetailIsreviewed];
    [aCoder encodeObject:_locationString forKey:kUserDetailLocationString];
    [aCoder encodeObject:_testbuds forKey:kUserDetailTestbuds];
    [aCoder encodeObject:_sessionid forKey:kUserDetailSessionid];
    [aCoder encodeObject:_location forKey:kUserDetailLocation];
    [aCoder encodeObject:_isShowLocation forKey:kUserDetailIsShowLocation];
    [aCoder encodeObject:_profilepic3 forKey:kUserDetailProfilepic3];
    [aCoder encodeObject:_searchMinAge forKey:kUserDetailSearchMinAge];
    [aCoder encodeObject:_ethnicity forKey:kUserDetailEthnicity];
    [aCoder encodeObject:_dob forKey:kUserDetailDob];
    [aCoder encodeObject:_refercode forKey:kUserDetailRefercode];
    [aCoder encodeBool:_isregistered forKey:kUserDetailIsregistered];
    [aCoder encodeObject:_updatedat forKey:kUserDetailUpdatedat];
    [aCoder encodeObject:_profilepic2 forKey:kUserDetailProfilepic2];
    [aCoder encodeObject:_profilepic9 forKey:kUserDetailProfilepic9];
    [aCoder encodeObject:_isReceiveInvitationNotifications forKey:kUserDetailIsReceiveInvitationNotifications];
    [aCoder encodeObject:_email forKey:kUserDetailEmail];
    [aCoder encodeObject:_searchMaxAge forKey:kUserDetailSearchMaxAge];
    [aCoder encodeObject:_profilepic1 forKey:kUserDetailProfilepic1];
    [aCoder encodeObject:_profilepic8 forKey:kUserDetailProfilepic8];
    [aCoder encodeObject:_aboutMe forKey:kUserDetailAboutMe];
    [aCoder encodeObject:_accessToken forKey:kUserDetailAccessToken];
    [aCoder encodeObject:_accountType forKey:kUserDetailAccountType];
    [aCoder encodeObject:_distanceUnit forKey:kUserDetailDistanceUnit];
    [aCoder encodeObject:_mobile forKey:kUserDetailMobile];
    [aCoder encodeObject:_firstName forKey:kUserDetailFirstName];
    [aCoder encodeObject:_occupation forKey:kUserDetailOccupation];
    [aCoder encodeObject:_profilepic7 forKey:kUserDetailProfilepic7];
    [aCoder encodeObject:_showme forKey:kUserDetailShowme];
    [aCoder encodeObject:_gender forKey:kUserDetailGender];
    [aCoder encodeObject:_profilepic6 forKey:kUserDetailProfilepic6];
    [aCoder encodeObject:_createdat forKey:kUserDetailCreatedat];
    [aCoder encodeObject:_isspam forKey:kUserDetailIsspam];
    [aCoder encodeObject:_isReceiveMessagesNotifications forKey:kUserDetailIsReceiveMessagesNotifications];
    [aCoder encodeObject:_reference forKey:kUserDetailReference];
    [aCoder encodeObject:_password forKey:kUserDetailPassword];
    [aCoder encodeObject:_profilepic5 forKey:kUserDetailProfilepic5];
    [aCoder encodeObject:_searchDistance forKey:kUserDetailSearchDistance];
}

- (id)copyWithZone:(NSZone *)zone {
    UserDetail *copy = [[UserDetail alloc] init];
    
    
    
    if (copy) {

        copy.devicetoken = [self.devicetoken copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.devicetype = [self.devicetype copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.profilepic4 = [self.profilepic4 copyWithZone:zone];
        copy.education = [self.education copyWithZone:zone];
        copy.socialId = [self.socialId copyWithZone:zone];
        copy.relationship = [self.relationship copyWithZone:zone];
        copy.isreviewed = [self.isreviewed copyWithZone:zone];
        copy.locationString = [self.locationString copyWithZone:zone];
        copy.testbuds = [self.testbuds copyWithZone:zone];
        copy.sessionid = [self.sessionid copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.isShowLocation = [self.isShowLocation copyWithZone:zone];
        copy.profilepic3 = [self.profilepic3 copyWithZone:zone];
        copy.searchMinAge = [self.searchMinAge copyWithZone:zone];
        copy.ethnicity = [self.ethnicity copyWithZone:zone];
        copy.dob = [self.dob copyWithZone:zone];
        copy.refercode = [self.refercode copyWithZone:zone];
        copy.isregistered = self.isregistered;
        copy.updatedat = [self.updatedat copyWithZone:zone];
        copy.profilepic2 = [self.profilepic2 copyWithZone:zone];
        copy.profilepic9 = [self.profilepic9 copyWithZone:zone];
        copy.isReceiveInvitationNotifications = [self.isReceiveInvitationNotifications copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.searchMaxAge = [self.searchMaxAge copyWithZone:zone];
        copy.profilepic1 = [self.profilepic1 copyWithZone:zone];
        copy.profilepic8 = [self.profilepic8 copyWithZone:zone];
        copy.aboutMe = [self.aboutMe copyWithZone:zone];
        copy.accessToken = [self.accessToken copyWithZone:zone];
        copy.accountType = [self.accountType copyWithZone:zone];
        copy.distanceUnit = [self.distanceUnit copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.occupation = [self.occupation copyWithZone:zone];
        copy.profilepic7 = [self.profilepic7 copyWithZone:zone];
        copy.showme = [self.showme copyWithZone:zone];
        copy.gender = [self.gender copyWithZone:zone];
        copy.profilepic6 = [self.profilepic6 copyWithZone:zone];
        copy.createdat = [self.createdat copyWithZone:zone];
        copy.isspam = [self.isspam copyWithZone:zone];
        copy.isReceiveMessagesNotifications = [self.isReceiveMessagesNotifications copyWithZone:zone];
        copy.reference = [self.reference copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
        copy.profilepic5 = [self.profilepic5 copyWithZone:zone];
        copy.searchDistance = [self.searchDistance copyWithZone:zone];
    }
    
    return copy;
}


@end

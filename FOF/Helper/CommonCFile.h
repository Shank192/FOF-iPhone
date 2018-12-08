//
//  CommonCFile.h
//  FOF
//
//  Created by 360dts on 28/07/18.
//  Copyright © 2018 360dts. All rights reserved.
//

#ifndef CommonCFile_h
#define CommonCFile_h


#define iphone5orSE self.view.frame.size.height == 568
#define iphone6or7 self.view.frame.size.height == 667
#define iphone7plus self.view.frame.size.height == 736

#define deleteCoreData 1  // 1 = no delete, 0 = delete all

#define gmapApi ((GooglemapCall*)[GooglemapCall sharedGoogleMapApi])


#define UNSEL_CLR [UIColor colorWithRed:0.88 green:0.87 blue:0.87 alpha:1.0];
#define SEL_CLR [UIColor colorWithRed:0.22 green:0.18 blue:0.18 alpha:1.0];

#define kAppTitle @"FriendsOFood"
#define lightPinkCOlor @"#ffc9d1"

#define kInviteUrl @"http://www.friendsoverfoods.com/invite.php"
#define LAT_VAL 23.035
#define LAN_VAL 72.5293

#define GMAP_API_KEY @"AIzaSyDAzrcVKzabhf0u0zb7j_mvvfcG5Xlibl4"


#define profpic(picnum, userid) [NSString stringWithFormat:@"http://entrega.in/projects/fof/api/uploads/%ldprofilepic%ld.",userid,picnum];

#define URL_PROFPIC @"http://entrega.in/projects/fof/api/"

//In testbud screen

#define TAG_FONT [UIFont fontWithName:@"Montserrat-Regular" size:14.5]

#define TAG_SEL_CLR [Colors colorFromHexString:@"#a32e43"]

#define ERROR_TITLE @"Error"

#define FOF_TITLE @"FOF"

//In detail cell

#define TAG_CLR_DETAIL_CELL [Colors colorFromHexString:@"#8e8e8e"];


#define FONT_LIGHT @"Montserrat-Light"
#define FONT_REGULAR @"Montserrat-Regular"
#define FONT_MEDIUM @"Montserrat-Medium"


#define appDel ((AppDelegate*)[[UIApplication sharedApplication]delegate])


#endif /* CommonCFile_h */

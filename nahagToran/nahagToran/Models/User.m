//
//  User.m
//  nahagToran
//
//  Created by AppGate  Inc on 15/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "User.h"

@implementation User
-(User*)parsUserromDict:(NSDictionary*)dict
{
    User*user=[[User alloc]init];
    user.CallID = [dict objectForKey:@"CallID"];
     user.Destination = [dict objectForKey:@"Destination"];
    user.ImageFile = [dict objectForKey:@"ImageFile"];
    user.Origin = [dict objectForKey:@"Origin"];
    user.countDestination = [dict objectForKey:@"countDestination"];
    user.userFullName= [dict objectForKey:@"userFullName"];
    user.userPhone = [dict objectForKey:@"userPhone"];
    user.destinationLatitude = [dict objectForKey:@"destinationLatitude"];
    user.destinationLongitude = [dict objectForKey:@"destinationLongitude"];
    user.originLatitude = [dict objectForKey:@"originLatitude"];
    user.originLongitude = [dict objectForKey:@"originLongitude"];
    user.sumPayment = [dict objectForKey:@"sumPayment"];
    user.distance = [dict objectForKey:@"distance"];
   
    
    return user;
}
@end

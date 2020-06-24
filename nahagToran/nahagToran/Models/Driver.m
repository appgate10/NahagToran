//
//  Driver.m
//  nahagToran
//
//  Created by AppGate  Inc on 15/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "Driver.h"

@implementation Driver
-(NSMutableArray*)parseJobsSearchList:(NSArray*)arr
{
    NSMutableArray*arry=[[NSMutableArray alloc]init];
    for (NSDictionary*dic in arr) {
     //   [arry addObject:[self parsFeedFromSearchJobID:dic]];
    }
    return arry;
}

-(Driver*)parsDriverFromDict:(NSDictionary*)dict
{
    
    Driver*driver=[[Driver alloc]init];
    driver.IDDriver = [dict objectForKey:@"IDDriver"];
     driver.driverFullName = [dict objectForKey:@"driverFullName"];
    driver.driverPhone = [dict objectForKey:@"driverPhone"];
    driver.ImageFile = [dict objectForKey:@"ImageFile"];
    driver.lastLatitude = [dict objectForKey:@"lastLatitude"];
    driver.lastLongitude= [dict objectForKey:@"lastLongitude"];
    driver.DriverRating = [dict objectForKey:@"DriverRating"];
    driver.userGender = [dict objectForKey:@"userGender"];
    driver.UserOriginLat = [dict objectForKey:@"UserOriginLat"];
    driver.UserOriginLng = [dict objectForKey:@"UserOriginLng"];
    driver.UserDestinationLat = [dict objectForKey:@"UserDestinationLat"];
    driver.UserDestinationLng = [dict objectForKey:@"UserDestinationLng"];
    driver.travelCount = [dict objectForKey:@"travelCount"];
     driver.Age = [dict objectForKey:@"Age"];
   
    
    return driver;
}
@end

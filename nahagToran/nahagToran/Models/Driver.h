//
//  Driver.h
//  nahagToran
//
//  Created by AppGate  Inc on 15/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Driver : NSObject
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSNumber *IDDriver;
@property (nonatomic,strong)NSString* driverFullName;
@property (nonatomic,strong)NSString* driverPhone;
@property (nonatomic,strong)NSString* ImageFile;
@property (nonatomic,strong) NSString* lastLatitude;
@property (nonatomic,strong) NSString* lastLongitude;
@property (nonatomic,strong)NSString* DriverRating;
@property (nonatomic,strong)NSNumber *userGender;//": "32.0621739",
@property (nonatomic,strong)NSNumber *UserOriginLat;
@property (nonatomic,strong)NSNumber *UserOriginLng;//": "32.0621739",
@property (nonatomic,strong)NSNumber * UserDestinationLat;//": 31.9326305389404,
@property (nonatomic,strong)NSNumber *UserDestinationLng;//: 35.0232696533203,
@property (nonatomic,strong)NSNumber *travelCount;
@property (nonatomic,strong) NSNumber* Age;
-(Driver*)parsDriverFromDict:(NSDictionary*)dict;
//@property  BOOL show_phone;
//@property BOOL residential_option;
//@property BOOL favorite_job;

@end

NS_ASSUME_NONNULL_END

//
//  User.h
//  nahagToran
//
//  Created by AppGate  Inc on 15/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSNumber *CallID;
@property (nonatomic,strong)NSString* Destination;
@property (nonatomic,strong)NSString* ImageFile;
@property (nonatomic,strong)NSString* Origin;
@property (nonatomic,strong) NSNumber* countDestination;
@property (nonatomic,strong) NSString* userFullName;
@property (nonatomic,strong)NSString* userPhone;
@property (nonatomic,strong)NSNumber *destinationLatitude;//": "32.0621739",
@property (nonatomic,strong)NSNumber *destinationLongitude;
@property (nonatomic,strong)NSNumber *originLatitude;//": "32.0621739",
@property (nonatomic,strong)NSNumber *originLongitude;
@property (nonatomic,strong) NSNumber* sumPayment;
@property (nonatomic,strong) NSNumber* distance;
-(User*)parsUserromDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END

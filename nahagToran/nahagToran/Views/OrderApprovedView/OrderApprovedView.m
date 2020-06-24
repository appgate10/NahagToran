//
//  OrderApprovedView.m
//  nahagToran
//
//  Created by AppGate  Inc on 12/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "OrderApprovedView.h"

@implementation OrderApprovedView {
    NSTimer *timerMinute;
     int duration;
    CLLocationCoordinate2D coordinate,lastCoordinate,destinationCoor,userCoord;
     NSTimer *timer;
     NSString *phone;
     NSInteger driverID;
     NSArray *annotations;
     NSInteger numberRate;
     NSDictionary *dic;
}

- (id)init : (void(^)(BOOL doneBlock))blockReturn
{
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
        _currentBlock = blockReturn;
    }
    return self;
}

-(void)setPage {
    if(self.callID)
    {
         [self getDriverDetails];
       // [self setDriverDetails];
    }
    _imgProfile.layer.cornerRadius = 6;
    _btnCancel.hidden = _btnCancel2.hidden = NO;
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_activityIndicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:self.activityIndicator];
    [self bringSubviewToFront:self.activityIndicator];
    
    timerMinute = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerTick) userInfo:nil repeats:NO];

    _lblTravels.text = [Methods GetString:@"travels"];
    _lblTravelOnWay.text = [Methods GetString:@"driver_on_way"];
    _lblOrderApproved.text = [Methods GetString:@"order_apprved"];
    _lblArrivalTime.text = [Methods GetString:@"arrival_time"];
    [_btnCancel setTitle:[Methods GetString:@"cancel"] forState:UIControlStateNormal];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: _lblRates.attributedText];
    
        [text addAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:@"OpenSansHebrew-Bold" size:_lblRates.font.pointSize],
        NSForegroundColorAttributeName:[UIColor colorWithString:@"58B02F"]
        } range:NSMakeRange(0, 1)];
    
    [_lblRates setAttributedText: text];
}
-(void)getDriverDetails
{
    [ServiceConnector UserGetTravelData:[NSString stringWithFormat:@"%ld", self.callID] andReturn:^(NSDictionary *json) {
                        if(json)
                        {
                            self.driver = [[Driver alloc]init];
                                   self.driver = [self.driver parsDriverFromDict:json];
      [self setDriverDetails];
//                         DriverMainPage *view = [[DriverMainPage alloc]init];
//                                       view.isEnterDriving = true;
//                                        view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//                                                           [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];

                        }
                        else
                        {
    //                        HomeVC *view = [[HomeVC alloc]init];
    //                        self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
    //                        self.window.rootViewController = self.rootNav;
                        }
                    }];
}
-(void)setDriverDetails
{
        APP_DELEGATE.currentDriver = self.driver;
    self.lblDriverName.text = self.driver.driverFullName;
    self.lblAgeGender.text = [self.driver.Age stringValue];
    NSString *genderDetails = @"";
    if([self.driver.userGender intValue]== 1)
    {
        genderDetails = [Methods GetString:@"male"];
        
    }
    else
    {
           genderDetails = [Methods GetString:@"female"];
    }
       self.lblAgeGender.text = [NSString stringWithFormat:@"(%@,%@}",genderDetails,[self.driver.Age stringValue]];
    if(self.driver.ImageFile != [NSNull null])
    {
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:self.driver.ImageFile]];
    }
    self->phone = self.driver.driverPhone;
    self.lblTravelsNum.text = [self.driver.travelCount stringValue];
    float avgRate = [self.driver.DriverRating floatValue];
                  for (int i = 1; i<=avgRate; i++) {
                      UIImageView *img  = (UIImageView *)[self viewWithTag:i];
                      img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"Small_Star_On",APP_DELEGATE.end4]];
                  }
                  for (int i = avgRate+1; i<=5; i++) {
                      UIImageView *img  = (UIImageView *)[self viewWithTag:i];
                      img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",@"Small_Star_Off",APP_DELEGATE.end4]];
                  }
                  self->destinationCoor = CLLocationCoordinate2DMake([self.driver.UserDestinationLat  doubleValue],[self.driver.UserDestinationLng doubleValue]);
                  self->driverID = [self.driver.IDDriver integerValue];
                  CLLocationCoordinate2D driverCoord;
                  driverCoord = CLLocationCoordinate2DMake([self.driver.lastLatitude doubleValue],[self.driver.lastLongitude doubleValue]);
                  self->userCoord = CLLocationCoordinate2DMake([self.driver.UserOriginLat doubleValue],[self.driver.UserOriginLng doubleValue]);
                  //[self loadMap];
                  CGRect frame = CGRectMake(0, [Methods sizeForDevice:74], [Methods sizeForDevice:375], [Methods sizeForDevice:620]);
   // sel.frame = frame;
    self->lastCoordinate = CLLocationCoordinate2DMake([self.driver.lastLatitude doubleValue],[self.driver.lastLongitude doubleValue]);
       [self getPolylineRoute:driverCoord toDestination:self->userCoord isFirst:true];
    
                  if(self.showNavToDestination == true)//אם הגיע מבחוץ והוא תו״כ נסיעה
                  {
                      [self setNavToDestination];
                  }
                  else
                  {
                      //self.viewAimation.hidden = false;
                      CGRect frame = CGRectMake(0, [Methods sizeForDevice:172], [Methods sizeForDevice:375], [Methods sizeForDevice:495]);
                     // self.mapView.frame = frame;
                     // [self showViewDetailsAnim];
                      //לקבל מגוגל את המרחק והזמן בין 2 נקודות
                   
}
}
    //MARK: - Timer methods to show way on map
-(void)showWayFromDriverToUser{
        //הצגת זמן ההגעה
        int minutes = duration / 60;
        int seconds = duration % 60;
    self.lblArrivalHour.text = [NSString stringWithFormat:@"%@%d:%@%d",minutes<10?@"0":@"",minutes,seconds<10?@"0":@"",seconds];
        
        if(self->duration <= 0)
        {
            self.viewTimeArrive.hidden = true;
            self.btnCancel.hidden = true;
        }
        else if(self->duration%60 == 0)
        {
//            [self getPolylineRoute:lastCoordinate toDestination:CLLocationCoordinate2DMake(userCoord.latitude,userCoord.longitude) isFirst:true];
        }
        if(self->duration < 60)
        {
            self.btnCancel.hidden = true;
        }
        if(self->duration == 30)
        {
//            PopupGetOutView *view = [[PopupGetOutView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//            }];
//            view.strImgDriver = dic[IMAGE_FILE];
//            [view setView];
//            [self.view addSubview:view];
        }
        duration--;
        /*
        if(driverID > 0)
        {
            [ServiceConnector getDriverLocation:driverID callID:_callID andReturn:^(NSDictionary *json) {
                if(json)
                {
                    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:json];
                    BOOL isTravel = [[dic valueForKey:@"IsTravel"] boolValue];
                    if(isTravel == true)//אם פתאום הנהג עשה נוסע במונית
                    {
                        self.showNavToDestination = true;
                        [self setNavToDestination];
                    }
                    else
                    {
                        CLLocationCoordinate2D driverLocation;
                        driverLocation = CLLocationCoordinate2DMake([dic[@"Latitude"] doubleValue],[dic[@"Longitude"] doubleValue]);
                        
                        NSLog(@"[arrT addObject:[[CLLocation alloc] initWithLatitude:%f longitude:%f]];",driverLocation.latitude,driverLocation.longitude);
                        
    //                    float degrees= RADIANS_TO_DEGREES([self angleFromCoordinate:self->lastCoordinate toCoordinate:driverLocation]);
                        if(!self->annotations)
                        {
    //                        if(degrees > 0)//כדי שיציג את המרקרים רק כשיש 2 נקודות בשביל הנהג לחישוב הכיוון של המונית,אחרת היה כמה שניות שהמונית עמדה במיקום הדיפולטיבי ורק כשהתקבלה עוד נקודה זה השתנה
    //                        {
                                GMSMarker *point = [[GMSMarker alloc] init];
                                point.position = self->userCoord;
                                point.zIndex = 1;
                                point.map = self->mapView;
                                point.icon = [UIImage imageNamed:[NSString stringWithFormat:@"Me%@",APP_DELEGATE.end4]];
                                
                                GMSMarker *point2 = [[GMSMarker alloc] init];
                            //מכיון שאת אתחול האייקון לא מבצעים פה גם האתחולים הבאים לא מתבצעים במתודה זו כדי שלא יציג את האייקון הדיפולטיבי
    //                            point2.map = self->mapView;//later
    //                            point2.position = driverLocation;//later
                                // אתחול האייקון מתבצע רק במתודה setAnnotation ולא פה כדי שיציג את האייקון מיד בכיוון הנכון
                                //                            point2.icon = [UIImage imageNamed:[NSString stringWithFormat:@"Taxi_Icon%@",APP_DELEGATE.end4]];
                                self->annotations=[[NSArray alloc] initWithObjects:point,point2, nil];
                                [self setAnnotations:self->lastCoordinate andCord2:driverLocation];
    //                        }
                        }
                        else
                        {
                            ((GMSMarker *)[self->annotations objectAtIndex:0]).position = self->userCoord;
                            ((GMSMarker *)[self->annotations objectAtIndex:1]).position = driverLocation;
                            [self setAnnotations:self->lastCoordinate andCord2:driverLocation];
                        }
                        self->lastCoordinate = CLLocationCoordinate2DMake([dic[@"Latitude"] doubleValue],[dic[@"Longitude"] doubleValue]);
                    }
                }
            }];
        }
         */
    }

- (IBAction)btnPhoneClicked:(id)sender {
}
- (IBAction)btnCancelClicked:(id)sender {
    [self cancelTravel];
}
- (IBAction)btnCancel2Clicked:(id)sender {
    [self cancelTravel];
}

-(void) timerTick {
    [timerMinute invalidate];
    timerMinute = nil;
    self.btnCancel.hidden = self.btnCancel2.hidden = YES;
   //TODO
    [ServiceConnector SetUserINOrigin:[NSString stringWithFormat:@"%ld", self.callID] andReturn:^(NSString *result)
           {
         if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
             [Methods showToastView:@"נסיעה עודכנה בהצלחה"];
             //TODO
       }
       }];
}
    -(void)loadMap
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userCoord.latitude
                                                                longitude:userCoord.longitude
                                                                     zoom:16];
        CGRect frame = CGRectMake(0, [Methods sizeForDevice:121], [Methods sizeForDevice:375], [APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"]?691:[Methods sizeForDevice:546]);
//        mapView = [GMSMapView mapWithFrame:frame camera:camera];
//        mapView.myLocationEnabled = NO;
//        [self.view addSubview:mapView];
//        [self.view sendSubviewToBack:mapView];
    }
-(void)cancelTravel {
    //ביטול הנסיעה תוך דקה מהזמן שנהג לקח אותה
    [_activityIndicator startAnimating];
    [ServiceConnector TravelCancelByUser:^(NSString *result) {
        [self.activityIndicator stopAnimating];
        if (result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
            self->_currentBlock(false);
            [self removeFromSuperview];
        }
    }];
}

-(void) getPolylineRoute: (CLLocationCoordinate2D)origin toDestination: (CLLocationCoordinate2D)toDestination isFirst:(BOOL)isFirst
{
    NSString *stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=driving&key=%@",origin.latitude,origin.longitude,toDestination.latitude,toDestination.longitude,API_KEY];
    
    [self getJsonDataFromURL:stringUrl completionBlock:^(NSDictionary *response) {
        if(response)
        {
            NSArray *routes = [response objectForKey:@"routes"];
            if (routes.count > 0) {
                NSDictionary *firstRoute = [routes objectAtIndex:0];
                NSArray *aaa = [firstRoute objectForKey:@"legs"];
                NSDictionary *durationDic = [aaa[0] objectForKey:@"duration"];
                self->duration = [[durationDic valueForKey:@"value"] intValue];
           [self showWayFromDriverToUser];
                if(!self->timerMinute)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->timerMinute = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                       target:self
                                                                     selector:@selector(timerTick)
                                                                     userInfo:nil
                                                                      repeats:YES];
                    });
                }
            }
        }
        else
        {
            SHOW_ALERT(@"תקלת תקשורת, לא ניתן לעדכן את זמן ההגעה ולהציג את מיקומך על המפה");
        }
    }];
}
-(void) getJsonDataFromURL:(NSString *)urlString completionBlock:(void(^)(NSDictionary* response))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    if ([NSURL URLWithString:urlString] != nil) {
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(data != nil)
            {
                NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                completion(jsonResponse);
            }
            else
            {
                completion(nil);
            }
        }];
        [dataTask resume];
    }
}



@end

 //
//  CGConnector.m
//  Drincare
//
//  Created by AppGate  Inc on 17.4.2016.
//  Copyright © 2016 appgate. All rights reserved.
//

#import "CGConnector.h"

@implementation CGConnector

////test
NSString * terminal_id = @"0963655";
NSString * user = @"israeli";
NSString * password = @"I!fr43s!34" ;
NSString * cg_gateway_url = @"https://cguat2.creditguard.co.il/xpo/Relay";
//mid=@"14931"

////real------------
//NSString * terminal_id= @"8805382";
//NSString * user=@"appgate";;
//NSString * password=@"iidH@20C";
//NSString * mid=@"13748";
//NSString * cg_gateway_url=@"https://cgpay6.creditguard.co.il/xpo/Relay";

+(void)AuthenticationCreditGuardWithTotal:(NSDictionary *)dic andReturn:(APIResponse)completion{
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"<ashrait>"];
    [postString appendString:@"<request>"];
    [postString appendString:@"<command>doDeal</command>"];
    [postString appendString:@"<requestId></requestId>"];
    [postString appendString:@"<version>2000</version>"];
    [postString appendFormat:@"<language>%@</language>",[Methods isHebrew:@""]?@"HEB":@"ENG"];
    [postString appendString:@"<mayBeDuplicate>0</mayBeDuplicate>"];
    [postString appendString:@"<doDeal>"];
    [postString appendFormat:@"<terminalNumber>%@</terminalNumber>",terminal_id];
    [postString appendFormat:@"<cardNo>%@</cardNo>",[dic objectForKey:@"cardNum"]];
    [postString appendFormat:@"<cardExpiration>%@</cardExpiration>",[dic objectForKey:@"date"]];
    [postString appendFormat:@"<cvv>%@</cvv>",[dic objectForKey:@"cvv"]];
    [postString appendFormat:@"<id>%@</id>",[dic objectForKey:@"Id"]];
    [postString appendString:@"<transactionType>Debit</transactionType>"];
    [postString appendString:@"<creditType>RegularCredit</creditType>"];
    [postString appendString:@"<currency>ILS</currency>"];
    [postString appendString:@"<transactionCode>Phone</transactionCode>"];
    [postString appendString:@"<validation>Token</validation>"];
    [postString appendString:@"<dealerNumber></dealerNumber>"];
    [postString appendFormat:@"<user>%@</user>",user];
    [postString appendString:@"</doDeal>"];
    [postString appendString:@"</request>"];
    [postString appendString:@"</ashrait>"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:user forKey:@"user"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:postString forKey:@"int_in"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = serializer;
    
    [manager POST:cg_gateway_url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
        NSString* newStr = [NSString stringWithUTF8String:[responseObject bytes]];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"<?xml version='1.0' encoding='ISO-8859-8'?>" withString:@""];
        NSDictionary * dicIn = [NSDictionary dictionaryWithXMLString:newStr];
        NSDictionary * xmlBig = [dicIn objectForKey:@"response"];
        if ([[xmlBig objectForKey:@"result"] isEqualToString:@"000"]) {
            NSDictionary * xml = [xmlBig objectForKey:@"doDeal"];
            [APP_DELEGATE.shared_userDefaults setObject:[xml objectForKey:@"cardId"] forKey:USER_CARD_ID];
            [APP_DELEGATE.shared_userDefaults setObject:[xml objectForKey:@"cardNo"] forKey:USER_CARD_NUM];
//            [APP_DELEGATE.shared_userDefaults setObject:[[xml objectForKey:@"cardNo"] stringByReplacingOccurrencesOfString:@"x" withString:@"•"] forKey:USER_CARD_NUM];
            [APP_DELEGATE.shared_userDefaults setObject:[xml objectForKey:@"cardExpiration"] forKey:USER_CARD_TOKEF];
            //2do
            [APP_DELEGATE.shared_userDefaults setObject:[self companyImage:[[[xml objectForKey:@"creditCompany"] objectForKey:@"__text"]lowercaseString] ] forKey:USER_CARD_TYPE];
            //2do --
//            [APP_DELEGATE.shared_userDefaults setObject:[dic objectForKey:@"mail"] forKey:USER_CARD_MAIL];
//            [APP_DELEGATE.shared_userDefaults setObject:[dic objectForKey:@"name"] forKey:USER_CARD_NAME];
            NSLog(@"xml %@",xml);
            completion(@"ok");
        }else{
            completion([xmlBig objectForKey:@"userMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSDictionary dictionaryWithXMLData:errorData];
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{
    
    /* handle namespaces here if you want */
    
    NSLog(@"sdfghjkl %@",elementName);
}


+(void)DoDealWithTotal:(NSDecimalNumber *)total dealerNumber:(NSString *)dealer request:(NSString *)requestID dic:(NSDictionary*)dic andReturn:(APIResponse)completion{
    
    int first = [total intValue];
    int others = [total intValue];
    int numPayments = [[dic objectForKey:@"MaxPaymentsNumber"] intValue];
    int second = first / numPayments;
    others = second;
    first = first - (others * (numPayments-1));
    
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"<ashrait>"];
    [postString appendString:@"<request>"];
    
    [postString appendString:@"<command>doDeal</command>"];
    [postString appendFormat:@"<requestId>%@</requestId>",requestID];
    [postString appendString:@"<version>1001</version>"];
    [postString appendFormat:@"<language>%@</language>",@"HEB"];
    [postString appendString:@"<mayBeDuplicate>0</mayBeDuplicate>"];
    
    [postString appendString:@"<doDeal>"];
    
    [postString appendFormat:@"<terminalNumber>%@</terminalNumber>",terminal_id];
    [postString appendFormat:@"<cardNo>%@</cardNo>",[dic objectForKey:@"cardNumber"]];
    [postString appendFormat:@"<cardExpiration>%@</cardExpiration>",[dic objectForKey:@"date"]];
    [postString appendFormat:@"<cvv>%@</cvv>",[dic objectForKey:@"cvv"]];
    [postString appendFormat:@"<id>%@</id>",[dic objectForKey:@"TZ"]];
    [postString appendString:@"<transactionType>Debit</transactionType>"];
    [postString appendFormat:@"<creditType>%@</creditType>",(numPayments > 1)?@"Payments":@"RegularCredit"];
    if (numPayments > 1) {
        [postString appendFormat:@"<numberOfPayments>%d</numberOfPayments>",numPayments > 1?numPayments - 1:numPayments];
        [postString appendFormat:@"<firstPayment>%d</firstPayment>",first];
        [postString appendFormat:@"<periodicalPayment>%d</periodicalPayment>",second];
    }

    [postString appendString:@"<currency>ILS</currency>"];
    [postString appendString:@"<transactionCode>Phone</transactionCode>"];
    [postString appendFormat:@"<total>%@</total>",total];
    [postString appendString:@"<validation>AutoComm</validation>"];
//    [postString appendFormat:@"<dealerNumber>%@</dealerNumber>",dealer];
    
    [postString appendFormat:@"<user>%@</user>",user];
    [postString appendString:@"</doDeal>"];
    [postString appendString:@"</request>"];
    [postString appendString:@"</ashrait>"];
    
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:user forKey:@"user"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:postString forKey:@"int_in"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer * serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = serializer;
    
    [manager POST:cg_gateway_url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"<?xml version='1.0' encoding='ISO-8859-8'?>" withString:@""];
        
        NSDictionary * xmlBig = [[NSDictionary dictionaryWithXMLString:newStr]objectForKey:@"response"];
        if ([[xmlBig objectForKey:@"result"] isEqualToString:@"000"]) {
            completion(newStr);
        }
        else
        {
            completion([xmlBig objectForKey:@"userMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
    }];
}

+(NSString *)companyImage:(NSString *)company{
    NSArray * array = [NSArray arrayWithObjects:@"isracard",@"visa",@"diners",@"amex",@"jcb",@"alphacard", nil];
    if (![array containsObject:company] || [company isEqualToString:@"jcb"]) {
        company = @"isracard";
    }
    return company;
}

@end

//
//  NetworkHandler.h
//  
//
//  Created by Bhavuk Jain on 01/02/16.
//  Copyright © 2016 Bhavuk Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject
+(nonnull instancetype)sharedInstance;
-(void)composeGetRequestWithMethod:(NSString*_Nullable)method paramas:(NSDictionary  * _Nullable )paramas onComplition:(nullable void (^)(BOOL succeeded, id  _Nullable response))completionBlock;
-(void)cancelRequest;
@end

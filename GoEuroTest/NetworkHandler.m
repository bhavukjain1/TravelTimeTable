//
//  NetworkHandler.m
//
//
//  Created by Bhavuk Jain on 01/02/16.
//  Copyright © 2016 Bhavuk Jain. All rights reserved.
//

#import "NetworkHandler.h"
#import "AFHTTPSessionManager.h"


#define BASE_URL @"https://api.myjson.com/bins/"

@interface NetworkHandler()
@property(nonatomic,strong)  AFHTTPSessionManager *httpClient;
@end
@implementation NetworkHandler

static NetworkHandler *networkHandler;

+ (instancetype)sharedInstance {
	if (!networkHandler) {
		networkHandler  = [[self alloc] init];
	}
	
	return networkHandler;
}

-(void)composeRequestWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, id  _Nullable  response))completionBlock
{
    
    
    //NSURL *url = [NSURL URLWithString:BASE_URL];
    _httpClient = [AFHTTPSessionManager manager];
    
    
//    _httpClient.requestSerializer = [AFHTTPRequestSerializer serializer];
//    _httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,method];
    
    [_httpClient POST:url parameters:paramas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        completionBlock(YES,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Network Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [controller addAction:okAction];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        UIViewController *rootController = window.rootViewController;
        
        [rootController presentViewController:controller animated:true completion:nil];
        
        
        
        completionBlock(NO,nil);
    }];
    
 

}





-(void)composeGetRequestWithMethod:(NSString*)method paramas:(NSDictionary*)paramas onComplition:(void (^)(BOOL succeeded, id  _Nullable  response))completionBlock
{
    
    
    _httpClient = [AFHTTPSessionManager manager];
    _httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    _httpClient.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,method];
    
    [_httpClient GET:url parameters:paramas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Network Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [controller addAction:okAction];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        UIViewController *rootController = window.rootViewController;
        
        [rootController presentViewController:controller animated:true completion:nil];
        completionBlock(NO,@{});
    }];
}

-(void)cancelRequest{
    
    [[_httpClient operationQueue] cancelAllOperations];
}

@end

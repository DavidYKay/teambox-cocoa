//
//  TeamboxEngineConnection.m
//  Teambox
//
//  Created by Alejandro JL on 25/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxConnection.h"

@interface  TeamboxConnection (Private)

- (id)initWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;
- (id)initWithAuthenticateWithUsername:(NSString *)username andPassword:(NSString *)password url:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;

@end

@implementation TeamboxConnection

@synthesize request;

+ (id)getDataWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	id request = [[self alloc] initWithURL:url type:type delegate:theDelegate];
	return request = nil;
}

+ (id)authenticateWithUsername:(NSString *)username andPassword:(NSString *)password url:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	id request = [[self alloc] initWithAuthenticateWithUsername:username andPassword:password url:url type:type delegate:theDelegate];
	return request = nil;

}

+ (id)postCommentWithUrl:(NSURL *)url comment:(NSString *)comment delegate:(NSObject *)theDelegate{
	comment = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><comment><body>%@</body></comment>", comment];
	id request = [[self alloc] initWithUrlAndPostData:url delegate:theDelegate postData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
	return request = nil;
}

- (id)initWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		delegate = theDelegate;
		typeGet = type;
		request = [ASIHTTPRequest requestWithURL:url];
		[request setDelegate:self];
		[request setShouldRedirect:NO];
		if (![typeGet isEqualToString:@"file"]) {
			[request addRequestHeader:@"Accept" value:@"application/json"];
			[request addRequestHeader:@"Content-Type" value:@"application/json"];
			#if TARGET_OS_IPHONE
				[request addRequestHeader:@"User-Agent" value:@"Teambox cocoa touch"];
			#else
				[request addRequestHeader:@"User-Agent" value:@"Teambox Mac"];
			#endif
		}
	
		[request setDidStartSelector:@selector (requestStart:)];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		[request startAsynchronous];
	}
    return self;
}

-(id)initWithUrlAndPostData:(NSURL *)url delegate:(NSObject *)theDelegate postData:(NSData*)postData {
	if (self = [super init]) {
		delegate = theDelegate;
		request = [ASIHTTPRequest requestWithURL:url];
		typeGet = @"Comment";
		[request setDelegate:self];
		
		[request addRequestHeader:@"Accept" value:@"application/xml"];
		[request addRequestHeader:@"Content-Type" value:@"application/xml"];
		#if TARGET_OS_IPHONE
			[request addRequestHeader:@"User-Agent" value:@"Teambox cocoa touch"];
		#else
			[request addRequestHeader:@"User-Agent" value:@"Teambox Mac"];
		#endif
		
		[request appendPostData:postData];
		[request setDidStartSelector:@selector (requestStart:)];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		[request startAsynchronous];
	}

	return self;
}
- (id)initWithAuthenticateWithUsername:(NSString *)username andPassword:(NSString *)password url:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		delegate = theDelegate;
		typeGet = type;
		request = [ASIHTTPRequest requestWithURL:url];
		[request setDelegate:self];
		[request setShouldRedirect:NO];
		[request setUsername:username];
		[request setPassword:password];
		[request setDidStartSelector:@selector (requestStart:)];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		[request startAsynchronous];
	}
    
    return self;
}

- (void)requestStart:(ASIHTTPRequest *)request {
	
}

- (void)requestDone:(ASIHTTPRequest *)request {
	int statusCode;
	if ([typeGet isEqualToString:@"Login"]){
		statusCode = [self.request responseStatusCode];
		if (statusCode==302) {
			[delegate errorAuthentication];
		}else
			if ([self.request responseStatusCode] == 200)
					[delegate finishedConnectionLogin];
				else
					[delegate errorConnectionLogin:nil];
	} else {
		NSLog(@"XML %@",[self.request responseString]);
		[delegate finishedGetData:[self.request responseData] withType:typeGet];
	}
	
}

- (void)requestWentWrong:(ASIHTTPRequest *)request {
	NSError *error = [self.request error];
	int statusCode = [self.request responseStatusCode];
	if (statusCode==302) {
		[delegate errorAuthentication];
	}else {
		if ([typeGet isEqualToString:@"Login"])
			[delegate errorConnectionLogin:error];

	}

	}

@end

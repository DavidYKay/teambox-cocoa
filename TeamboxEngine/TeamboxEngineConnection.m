//
//  TeamboxEngineConnection.m
//  Teambox
//
//  Created by Alejandro JL on 25/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineConnection.h"

@interface  TeamboxEngineConnection (Private)

- (id)initWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;

@end

@implementation TeamboxEngineConnection

@synthesize request;

+ (id)getDataWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	id request = [[self alloc] initWithURL:url type:type delegate:theDelegate];
	return request = nil;
	
}

- (id)initWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		delegate = theDelegate;
		typeGet = type;
		request = [ASIHTTPRequest requestWithURL:url];
		[request setDelegate:self];
		if (![typeGet isEqualToString:@"file"])
			[request addRequestHeader:@"Accept" value:@"application/xml"];
		
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
	[delegate finishedGetData:[self.request responseData] withType:typeGet];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request {
	NSError *error = [self.request error];
}

@end

//
//  TeamboxEngineConnection.h
//  Teambox
//
//	Created by 
//			Alejandro Julián López
//			Eduardo Hernández Cano
//  on 25/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"
#import "ASIHTTPRequest.h"
#import "TeamboxEngineConnectionDelegate.h"

@interface TeamboxEngineConnection : NSObject {
	NSObject <TeamboxEngineConnectionDelegate> *delegate;
	ASIHTTPRequest *request;
	NSString *typeGet;
}

@property (nonatomic, retain) ASIHTTPRequest *request;
+ (id)getDataWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;

@end
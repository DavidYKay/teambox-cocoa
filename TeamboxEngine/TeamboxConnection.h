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
#import "TeamboxConnectionDelegate.h"

@interface TeamboxConnection : NSObject {
	NSObject <TeamboxConnectionDelegate> *delegate;
	ASIHTTPRequest *request;
	NSString *typeGet;
}

@property (nonatomic, retain) ASIHTTPRequest *request;
+ (id)getDataWithURL:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;
+ (id)authenticateWithUsername:(NSString *)username andPassword:(NSString *)password url:(NSURL *)url type:(NSString *)type delegate:(NSObject *)theDelegate;
+ (id)postCommentWithUrl:(NSURL *)url comment:(NSString *)comment delegate:(NSObject *)theDelegate;
-(id)initWithUrlAndPostData:(NSURL *)url delegate:(NSObject *)theDelegate postData:(NSData*)postData;
@end
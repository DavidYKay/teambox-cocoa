//
//  TeamboxEngineKeychain.m
//  Teambox-Engine
//
//  Created by Alejandro JL on 27/03/10.
//  Copyright 2010 Teambox. All rights reserved.
//
#if TARGET_OS_MAC
#import "TeamboxEngineKeychain.h"
#import <Security/Security.h>

@interface TeamboxEngineKeychain (PrivateMethods)

+ (BOOL)existanceOfKeychainForUsername:(NSString *)username;
+ (NSString *)getPasswordFromSecKeychainItemRef:(SecKeychainItemRef)item;
@end

@implementation TeamboxEngineKeychain

+ (BOOL)storePasswordForUsername: (NSString *)username Password:(NSString *)password error:(NSError **)error {
	SecKeychainAttribute attributes[3];
	SecKeychainAttributeList list;
	SecKeychainItemRef item;
	OSStatus status;
	
	attributes[0].tag = kSecAccountItemAttr;
	attributes[0].data = (void *)[username UTF8String];
	attributes[0].length = [username length];
	
	attributes[1].tag = kSecLabelItemAttr;
	attributes[1].data = (void *)[@"Teambox Mac" UTF8String];
	attributes[1].length = [@"Teambox Mac" length];
	
	attributes[2].tag = kSecServiceItemAttr;
	attributes[2].data = (void *)[@"Teambox password data" UTF8String];
	attributes[2].length = [@"Teambox password data" length];
	
	list.count = 3;
	list.attr = attributes;
	
		//review if it already exists
	if (![self existanceOfKeychainForUsername:username]) {
		
		status = SecKeychainItemCreateFromContent(kSecGenericPasswordItemClass, &list, [password length], [password UTF8String], NULL,NULL,&item);
	}else {
		SecKeychainSearchRef search;
		OSErr result;
		
		result = SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
		SecKeychainSearchCopyNext (search, &item);
		status = SecKeychainItemModifyContent(item, &list, [password length], [password UTF8String]);
		CFRelease(search);
	}
	
	if (status != 0)
		NSLog(@"Error code: %d", (int)status);
	
	CFRelease (item);
	return !status;
}

+ (BOOL)existanceOfKeychainForUsername:(NSString *)username {
	SecKeychainSearchRef search;
	SecKeychainItemRef item;
	SecKeychainAttributeList list;
	SecKeychainAttribute attributes[3];
    OSErr result;
    int numberOfItemsFound = 0;
	
	attributes[0].tag = kSecAccountItemAttr;
    attributes[0].data = (void *)[username UTF8String];
    attributes[0].length = [username length];
    
    attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = (void *)[@"Teambox Mac" UTF8String];
    attributes[1].length = [@"Teambox Mac" length];
	
	attributes[2].tag = kSecServiceItemAttr;
    attributes[2].data = (void *)[@"Teambox password data" UTF8String];
    attributes[2].length = [@"Teambox password data" length];
	
    list.count = 3;
    list.attr = attributes;
	
    result = SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
	
    if (result != noErr) {
        NSLog (@"status %d from SecKeychainSearchCreateFromAttributes\n", result);
    }
    
	while (SecKeychainSearchCopyNext (search, &item) == noErr) {
        CFRelease (item);
        numberOfItemsFound++;
    }
	
	NSLog(@"%d items found\n", numberOfItemsFound);
    CFRelease (search);
	if (numberOfItemsFound > 0)
		return YES;
	
	return NO;
}

+ (NSString *)getPasswordForUsername:(NSString *)username error:(NSError **)error {
	UInt32 passwordLength;
	void *passwordData;
	SecKeychainItemRef loginItem;
	passwordData = nil;
	SecKeychainFindGenericPassword(NULL, 6, APP_CNAME, 
									   [username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
									   [username cStringUsingEncoding:NSASCIIStringEncoding], 
									   &passwordLength, &passwordData, &loginItem);
	NSString *passwod = [[NSString alloc] initWithBytes:passwordData length:passwordLength encoding:NSASCIIStringEncoding];
	return [[NSString alloc] initWithBytes:passwordData length:passwordLength encoding:NSASCIIStringEncoding];
}

+ (NSString *)getPasswordFromSecKeychainItemRef:(SecKeychainItemRef)item {
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
    OSStatus status;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
	
    list.count = 4;
    list.attr = attributes;
	
    status = SecKeychainItemCopyContent (item, NULL, &list, &length, 
                                         (void **)&password);
    if (status == noErr) {
        if (password != NULL) {
            char passwordBuffer[1024];
			
            if (length > 1023) {
                length = 1023;
            }
            strncpy (passwordBuffer, password, length);
			
            passwordBuffer[length] = '\0';
			return [NSString stringWithUTF8String:passwordBuffer];
        }
		
        SecKeychainItemFreeContent (&list, password);
		
    }
	printf("Error = %d\n", (int)status);
	return @"Error getting password";
}


+ (void)deleteKeyForUsername:(NSString *)username error:(NSError **)error {
	
}

@end
#endif

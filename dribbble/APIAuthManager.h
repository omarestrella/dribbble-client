//
// Created by Omar Estrella on 11/15/14.
// Copyright (c) 2014 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthManager.h"

NSString static *baseUrl = @"https://api.dribbble.com/v1";
NSString static *clientId = @"6767af960a29bbc938b08548e2ee7bc8e97845471bc6eb07dfc87c8ab06eb16f";
NSString static *secret = @"6d1d8e47e363c2945e271ca6cb111b8726ed33503d9998ceb2862de5c104f286";
NSString static *redirectUri = @"dribbble://auth";

@interface APIAuthManager : AuthManager

@property (nonatomic, strong) AFHTTPRequestOperationManager *afManager;

@end
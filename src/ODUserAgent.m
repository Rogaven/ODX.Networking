// ODUserAgent.m
//
// Copyright (c) 2009-2015  Alexey Nazaroff, AJR
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <ODX.Core/ODStringify.h>
#import <ODX.Core/ODDispatch.h>
#import "ODUserAgent.h"

static const NSString * const kCFBundleShortVersionString = @"CFBundleShortVersionString";

@implementation ODUserAgent

// User-Agent Header;
// see: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
+ (NSString *)userAgent {
    static NSString *userAgent = nil;
    ODDispatchOnce((^{
        NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
 
        NSString *exec = dict[(__bridge NSString *) kCFBundleExecutableKey] ?:
                         dict[(__bridge NSString *) kCFBundleIdentifierKey];

        NSString *ver = dict[kCFBundleShortVersionString] ?:
                        dict[(__bridge NSString *) kCFBundleVersionKey];

//        ODCompilerIgnorePush(-Wgnu)
        #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
            userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", exec, ver,
                         [[UIDevice currentDevice] model],
                         [[UIDevice currentDevice] systemVersion],
                         [[UIScreen mainScreen] scale]];
        #elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
            userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@; Scale/%0.2f)", exec, ver,
                         [[NSProcessInfo processInfo] operatingSystemVersionString]],
                         [NSScreen backingScaleFactor];
        #endif
//        ODCompilerIgnorePop
    }));
    
    return userAgent;
}

@end

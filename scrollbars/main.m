//
//  main.m
//  scrollbars
//
//  Created by Brandon LeBlanc on 11/5/16.
//  Copyright © 2016 Brandon LeBlanc. All rights reserved.
//

#import <Foundation/Foundation.h>

void usage(NSString * name);
void changeScrollBarAction(CFStringRef setting);

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSString * name = [NSString stringWithUTF8String:argv[0]];

    if (argc != 2) {
      usage(name);
      return 1;
    }

    NSSet<NSString *> * settings = [NSSet setWithObjects:
                                    @"Automatic",
                                    @"WhenScrolling",
                                    @"Always",
                                    nil];

    NSString * parameter = [NSString stringWithUTF8String:argv[1]];
    if ([parameter characterAtIndex:0] == '-') {
      parameter = [parameter substringFromIndex:1];
    }

    if ([settings containsObject:parameter]) {
      changeScrollBarAction((__bridge CFStringRef)(parameter));
    } else {
      usage(name);
    }
  }
  return 0;
}

void usage(NSString * name) {
  NSLog(@"Usage: %@ [ -Automatic | -WhenScrolling | -Always ]", name);
}

void changeScrollBarAction(CFStringRef setting) {
  CFPreferencesSetValue(CFSTR("AppleShowScrollBars"),
                        setting,
                        kCFPreferencesAnyApplication,
                        kCFPreferencesCurrentUser,
                        kCFPreferencesAnyHost);

  CFPreferencesSynchronize(kCFPreferencesAnyApplication,
                           kCFPreferencesCurrentUser,
                           kCFPreferencesAnyHost);

  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"AppleShowScrollBarsSettingChanged"
                                                                 object:nil];
}

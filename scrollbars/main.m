//
//  main.m
//  scrollbars
//
//  Created by Brandon LeBlanc on 11/5/16.
//  Copyright © 2016 Brandon LeBlanc. All rights reserved.
//

#import <Foundation/Foundation.h>

void usage(NSString * name) __attribute__((noreturn));
void changeScrollBarAction(CFStringRef setting);

const NSString * settings[] = {
  @"Automatic",
  @"WhenScrolling",
  @"Always"
};

const size_t settingsCount = sizeof(settings)/sizeof(NSString *);

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSString * name = [NSString stringWithUTF8String:argv[0]];

    if (argc != 2)
      usage(name);

    NSSet<NSString *> * validSettings = [NSSet setWithObjects:settings count:settingsCount];

    NSString * parameter = [NSString stringWithUTF8String:argv[1]];
    if ([parameter characterAtIndex:0] == '-') {
      parameter = [parameter substringFromIndex:1];
    }

    if ([validSettings containsObject:parameter])
      changeScrollBarAction((__bridge CFStringRef)(parameter));
    else
      usage(name);
  }

  return 0;
}

void usage(NSString * name) {
  NSRange loc = [name rangeOfString:@"/" options:NSBackwardsSearch];
  if (loc.length > 0)
    name = [name substringFromIndex:loc.location + loc.length];

  NSMutableString * body = NSMutableString.string;

  for (int idx = 0; idx < settingsCount; ++idx) {
    if (idx != 0)
      [body appendString:@" | "];

    [body appendFormat:@"-%@", settings[idx]];
  }

  NSLog(@"Usage: %@ [ %@ ]", name, body);
  exit(1);
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

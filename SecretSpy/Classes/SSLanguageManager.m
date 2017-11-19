//
//  SCLocalizationManager.m
//  picsart
//
//  Created by hovhannes safaryan on 5/2/13.
//  Copyright (c) 2013 Socialin Inc. All rights reserved.
//

#import "SSLanguageManager.h"


@implementation SSLanguageManager {
}

+ (SSLanguageManager *)sharedInstance {
    static SSLanguageManager *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[SSLanguageManager alloc] init];
    });
    
    return __sharedInstance; 
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *path = [mainBundle pathForResource:self.selectedLanguage ofType:@"lproj"];
        NSBundle *bundleWithPath = [NSBundle bundleWithPath:path];
        BOOL isMainBundleNil = mainBundle == nil;
        BOOL isPathNil = path == nil;
        BOOL isBundleWithPathNil = bundleWithPath == nil;
        if (isMainBundleNil) {
            [NSException raise:@"Main bundle is nil" format:@"%@",@(isMainBundleNil)];
        }
        if (isPathNil && ![self.selectedLanguage isEqual:kSCLanguageNan]) {
            [NSException raise:@"Path is nil" format:@"%@",@(isPathNil)];
        }
        if (isBundleWithPathNil && ![self.selectedLanguage isEqual:kSCLanguageNan]) {
            [NSException raise:@"Bundle with path is nil" format:@"%@",@(isBundleWithPathNil)];
        }
    }
    return self;
}

-(NSString*) localizedString:(NSString*) key {
    if ([self.selectedLanguage isEqualToString:kSCLanguageNan]) {
        return key;
    }
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:self.selectedLanguage ofType:@"lproj"];
    NSString *locStr = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:@"" table:nil];
    //NSString* locStr = [mainBundle localizedStringForKey:key value:@"" table:nil];
    
    if([key isEqualToString:locStr] && [self.selectedLanguage isEqualToString:kSCEnglish] == NO){
        locStr = [[NSBundle bundleWithPath:[mainBundle pathForResource:kSCEnglish ofType:@"lproj"]] localizedStringForKey:key value:@"" table:nil];
    }
    
    
    
    return locStr;
}

-(BOOL)isSelectedAsianLanguage {
    return [self.selectedLanguage isEqualToString:kSCChinese] || [self.selectedLanguage isEqualToString:kSCJapanese];
}

-(BOOL)isSystemLanguage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kSCLanguageKey]==nil;
}

@synthesize selectedLanguage = _selectedLanguage;
- (void)setSelectedLanguage:(NSString*)key {
    if (![self isLanguageSupported:key]) {
        NSLog(@"language %@ is not supported", key);
        return;
    }
    if ([_selectedLanguage isEqualToString:key]) {
        NSLog(@"language %@ is the selected one", key);
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([kSCSystemLanguage isEqualToString:key]) {
        _selectedLanguage = nil;
        [userDefaults removeObjectForKey:kSCLanguageKey];
    } else {
        _selectedLanguage = key;
        NSString *supportedLanguage = [self supportedLanguageFromLanguage:key];
        if (supportedLanguage) {
            _selectedLanguage = supportedLanguage;
        }
        [userDefaults setObject:_selectedLanguage forKey:kSCLanguageKey];
    }    
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSCNotificationLanguageChanged object:self];
}
- (NSString*)selectedLanguage {
    if(_selectedLanguage) return _selectedLanguage;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _selectedLanguage = [userDefaults stringForKey:kSCLanguageKey];
    if (_selectedLanguage == nil) {
        __block NSString *supportedLanguage = nil;
        [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(NSString * _Nonnull curPreffered, NSUInteger idx, BOOL * _Nonnull stop) {
            supportedLanguage = [self supportedLanguageFromLanguage:curPreffered];
            if (supportedLanguage != nil) {
                *stop = YES;
            }
            
        }];
        if (supportedLanguage != nil) {
            _selectedLanguage = supportedLanguage;
        }else {
          _selectedLanguage = kSCEnglish;  
        }
    }
    return _selectedLanguage;
}

- (NSArray*)supportedLanguages {
    // @"zh-Hant" must be before @"zh"
    // we are checking with contains because there are cases like this:
    // zh-Hant-US
    return @[kSCLanguageNan,
             kSCEnglish,
             kSCGerman,
             kSCFrench,
             kSCItalian,
             kSCJapanese,
             kSCKorean,
             kSCPolish,
             kSCRussian,
             kSCSpanish,
             kSCArabic,
             kSCTurkish,
             kSCChineseT,
             kSCChinese,
             kSCHindi,
             kSCIndonesian,
             kSCThai,
             kSCBengali,
             kSCPortuguese,
             kSCArmenian,
             kSCVietnamese
             ];
}

- (BOOL)isLanguageSupported:(NSString*)language {
    if ([kSCSystemLanguage isEqualToString:language]) {
        return YES;
    }
    return [self supportedLanguageFromLanguage:language] != nil;
}

- (NSString *)supportedLanguageFromLanguage:(NSString *)language {
    // First checking for equality
    for (NSString* cur in [self supportedLanguages]) {
        if ([language isEqual:cur]) {
            return cur;
        }
    }
    
    // Checking for the best suited language
    for (NSString* cur in [self supportedLanguages]) {
        if ([language rangeOfString:cur].location == 0) {
            return cur;
        }
    }
    
    return nil;
}

- (BOOL)isCurrentLanguageRightToLeft {
    if ([self.selectedLanguage isEqualToString:kSCArabic]) {
        return YES;
    }
    return NO;
}

@end

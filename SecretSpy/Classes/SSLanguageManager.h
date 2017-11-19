//
//  SCLocalizationManager.h
//  picsart
//
//  Created by hovhannes safaryan on 5/2/13.
//  Copyright (c) 2013 Socialin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSCSystemLanguage   @"system"
#define kSCLanguageNan      @"nan"
#define kSCEnglish          @"en"
#define kSCGerman           @"de"
#define kSCFrench           @"fr"
#define kSCItalian          @"it"
#define kSCJapanese         @"ja"
#define kSCKorean           @"ko"
#define kSCPolish           @"pl"
#define kSCRussian          @"ru"
#define kSCSpanish          @"es"
#define kSCArabic           @"ar"
#define kSCTurkish          @"tr"
#define kSCChinese          @"zh"
#define kSCChineseT         @"zh-Hant"
#define kSCHindi            @"hi"
#define kSCIndonesian       @"id"
#define kSCThai             @"th"
#define kSCBengali          @"bn"
#define kSCPortuguese       @"pt"
#define kSCArmenian         @"hy"
#define kSCVietnamese       @"vi"


#define kSCNotificationLanguageChanged @"kSCNotificationLanguageChanged"
#define kSCLanguageKey @"kSCSelectedLanguage"

@interface SSLanguageManager : NSObject

+ (SSLanguageManager *)sharedInstance;

@property(nonatomic,strong) NSString* selectedLanguage;
@property(nonatomic,readonly) BOOL isSystemLanguage;

-(NSString*)localizedString:(NSString*) key;
-(BOOL)isSelectedAsianLanguage;
- (BOOL)isCurrentLanguageRightToLeft;

@end

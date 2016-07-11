//
//  SpeechToAudioFileConverter.h
//  SpeechToAudioFile
//
//  Created by Wolfgang Schreurs on 17/04/16.
//  Copyright © 2016 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechToAudioFileConverter : NSObject

- (void)writeText:(NSString *)text
withVoiceLanguage:(NSString *)voiceLanguage // use an identifier like th-TH
            toUrl:(NSURL *)url;

@end

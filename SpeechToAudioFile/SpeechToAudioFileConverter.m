//
//  SpeechToAudioFileConverter.m
//  SpeechToAudioFile
//
//  Created by Wolfgang Schreurs on 17/04/16.
//  Copyright © 2016 Wolfgang Schreurs. All rights reserved.
//

#import "SpeechToAudioFileConverter.h"

#import <AppKit/AppKit.h>

@interface SpeechToAudioFileConverter () <NSSpeechSynthesizerDelegate>

@end

@implementation SpeechToAudioFileConverter

- (void)writeText:(NSString *)text withVoiceLanguage:(NSString *)voiceLanguage toUrl:(NSURL *)url {
    NSString *voice = nil;
    
    NSString *recommendedLanguage = [self languageForString:text];
    if ([voiceLanguage hasPrefix:recommendedLanguage] == NO) {
        NSLog(@"WARNING: The chosen voice language '%@' might not give good results for text '%@', the text is probably best spoken with a '%@' language.", voiceLanguage, text, recommendedLanguage);
    }
        
    for (NSString *availableVoice in [NSSpeechSynthesizer availableVoices]) {
        NSDictionary *voiceAttributes = [NSSpeechSynthesizer attributesForVoice:availableVoice];
        if ([[voiceAttributes valueForKey:@"VoiceLanguage"] isEqualToString:voiceLanguage]) {
            voice = availableVoice;
            break;
        }
    }
    
    if (voice == nil) {
        NSLog(@"Could not find a voice for language '%@'", voiceLanguage);
    } else {
        NSSpeechSynthesizer *speechSynthesizer = [[NSSpeechSynthesizer alloc] initWithVoice:voice];
        speechSynthesizer.delegate = self;
        
        if (![speechSynthesizer startSpeakingString:text toURL:url]) {
            NSLog(@"Could not write text '%@' to URL: '%@'", text, url);
        }
    }
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
    if (!finishedSpeaking) {
        NSLog(@"did not finish speak text");
    }
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender
 didEncounterErrorAtIndex:(NSUInteger)characterIndex
                 ofString:(NSString *)string
                  message:(NSString *)message {
    
    NSLog(@"encountered error at index %tu of string '%@', message: '%@'", characterIndex, string,
          message);
}

- (NSString *)languageForString:(NSString *)text {
    NSString *language = nil;
    
    CFIndex maxIndex = fminf(text.length, 100);
    CFRange textRange = CFRangeMake(0, maxIndex);
    language = (NSString *) CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, textRange));
    
    return language;
}

@end

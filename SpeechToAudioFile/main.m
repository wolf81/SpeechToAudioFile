//
//  main.m
//  SpeechToAudioFile
//
//  Created by Wolfgang Schreurs on 17/04/16.
//  Copyright © 2016 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechToAudioFileConverter.h"

typedef NS_ENUM(NSUInteger, Argument) {
    ArgumentNone,
    ArgumentText,
    ArgumentLanguage,
    ArgumentOutputFile,
    ArgumentFlag,
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        __block NSString *filePath = nil;
        __block NSString *text = nil;
        __block NSString *voiceLanguage = nil;
        
        __block Argument expectedArgument = ArgumentFlag;
        
        __block BOOL expectedValueOmitted = NO;
        
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        [arguments enumerateObjectsUsingBlock:^(id  _Nonnull argument, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([argument hasPrefix:@"-"] && expectedArgument == ArgumentFlag) {
                if (expectedArgument == ArgumentFlag) {
                    if ([argument isEqualToString:@"-t"]) {
                        expectedArgument = ArgumentText;
                    } else if ([argument isEqualToString:@"-o"]) {
                        expectedArgument = ArgumentOutputFile;
                    } else if ([argument isEqualToString:@"-l"]) {
                        expectedArgument = ArgumentLanguage;
                    } else {
                        expectedArgument = ArgumentNone;
                        NSLog(@"invalid flag: %@, use -t (for text), -l (for language) and -o (for output file)", argument);
                    }
                } else {
                    NSLog(@"expected a flag, got value: %@", argument);
                }
            } else {
                if (expectedArgument != ArgumentFlag && expectedArgument != ArgumentNone) {
                    if ([argument hasPrefix:@"-"]) {
                        expectedValueOmitted = YES;
                        *stop = YES;
                    }
                    
                    switch (expectedArgument) {
                        case ArgumentText: {
                            text = argument;
                        } break;
                        case ArgumentOutputFile: {
                            filePath = argument;
                        } break;
                        case ArgumentLanguage: {
                            voiceLanguage = argument;
                        } break;
                            
                        default: {
                        } break;
                    }
                }
                
                if (idx < 6) {
                    expectedArgument = ArgumentFlag;
                } else {
                    expectedArgument = ArgumentNone;
                }
            }
        }];
        
        if (expectedValueOmitted) {
            NSLog(@"Expected a value, instead got a flag.");
            return 0;
        }
        
//        NSLog(@"%@ %@ %@", text, voiceLanguage, filePath);
        
        if (!text) {
            NSLog(@"Please add a -t parameter with the text to speak, i.e.: -t \"Hallo met Xander\".");
            return 0;
        }
        
        if (!voiceLanguage) {
            NSLog(@"Please add a -l parameter with the voice language to use, i.e.: -l \"nl-NL\".");
            return 0;
        }
        
        if (!filePath) {
            NSLog(@"Please add a -o parameter with the destination path for the file, i.e.: -o \"/Users/Menno/Desktop/temp.aiff\".");
            return 0;
        }
        
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        if (!fileUrl) {
            NSLog(@"Invalid path: %@", filePath);
        }
        
        SpeechToAudioFileConverter *converter = [SpeechToAudioFileConverter new];
        [converter writeText:text withVoiceLanguage:voiceLanguage toUrl:fileUrl];
    }
    return 0;
}

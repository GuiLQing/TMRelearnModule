#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SGSingleAudioPlayer.h"
#import "SGSpeechSynthesizerManager.h"
#import "SGVocabularyAnswerView.h"
#import "SGVocabularyDictationView.h"
#import "SGVocabularyKeyboardView.h"
#import "SGVocabularySpellingView.h"
#import "SGVocabularyTools.h"
#import "SGVocabularyVoiceView.h"
#import "UIImage+SGVocabularyResource.h"

FOUNDATION_EXPORT double SGToolsVersionNumber;
FOUNDATION_EXPORT const unsigned char SGToolsVersionString[];


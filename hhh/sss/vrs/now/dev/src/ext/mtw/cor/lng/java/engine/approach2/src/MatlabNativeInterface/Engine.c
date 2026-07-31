#include <jni.h>
#include "MatlabNativeInterface_Engine.h"
#include <stdio.h>
#include "engine.h"

#define DEFAULT_BUFFERSIZE 65536

Engine* ep;

char outputBuffer[DEFAULT_BUFFERSIZE];

JNIEXPORT void JNICALL 
Java_MatlabNativeInterface_Engine_open(JNIEnv *env, jobject obj, const jstring startcmd) {
  const char *c_string = (*env)->GetStringUTFChars(env, startcmd, 0);
  if (!(ep = engOpen(c_string))) {
    jclass exception;
    (*env)->ReleaseStringUTFChars(env, startcmd, c_string);
    exception = (*env)->FindClass(env, "java/io/IOException");
    if (exception == 0) return;
    (*env)->ThrowNew(env, exception, "Opening Matlab failed.");
    return;
  }
  (*env)->ReleaseStringUTFChars(env, startcmd, c_string);
	/* indicate that output should not be discarded but stored in */
	/* outputBuffer */
  engOutputBuffer(ep, outputBuffer, DEFAULT_BUFFERSIZE);
}

JNIEXPORT void JNICALL 
Java_MatlabNativeInterface_Engine_close(JNIEnv *env, jobject obj) {
	if (engClose(ep) == 1) {
	  jclass exception;
    exception = (*env)->FindClass(env, "java/io/IOException");
    if (exception == 0) return;
    (*env)->ThrowNew(env, exception, "Closing Matlab failed.");
    return;
  }
}

JNIEXPORT void JNICALL
Java_MatlabNativeInterface_Engine_evalString(JNIEnv *env, jobject obj, const jstring j_string) {
  const char *c_string;
	c_string = (*env)->GetStringUTFChars(env, j_string, 0);
  if (engEvalString(ep, c_string) != 0) {
	  jclass exception;
    exception = (*env)->FindClass(env, "java/io/IOException");
    if (exception == 0) return;
    (*env)->ThrowNew(env, exception, "Error while sending/receiving data.");
	}
  (*env)->ReleaseStringUTFChars(env, j_string, c_string);
}

JNIEXPORT jstring JNICALL
Java_MatlabNativeInterface_Engine_getOutputString(JNIEnv *env, jobject obj, jint numberOfChars) {
  char *c_string;
	jstring j_string;
	if (numberOfChars > DEFAULT_BUFFERSIZE) {
		numberOfChars = DEFAULT_BUFFERSIZE;
	}
  c_string = (char *) malloc ( sizeof(char)*(numberOfChars+1) );
	c_string[numberOfChars] = 0;
  strncpy(c_string, outputBuffer, numberOfChars);
	j_string = (*env)->NewStringUTF(env, c_string);
	free(c_string);
  return j_string;
}


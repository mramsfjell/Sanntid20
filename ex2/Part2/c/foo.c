#include <pthread.h>
#include <stdio.h>
#include <string.h>

int i = 0;
pthread_mutex_t i_mutex;

// Note the return type: void*
void* incrementingThreadFunctionSafe(){
    for (int j = 0; j < 1000000; j++) {
	pthread_mutex_lock(&i_mutex);
	i++;
	pthread_mutex_unlock(&i_mutex);
    }
    return NULL;
}

void* decrementingThreadFunctionSafe(){
    for (int j = 0; j < 1000000; j++) {
	pthread_mutex_lock(&i_mutex);
	i--;
	pthread_mutex_unlock(&i_mutex);

    }
    return NULL;
}

void* incrementingThreadFunction(){
    for (int j = 0; j < 1000000; j++) {
	i++;
    }
    return NULL;
}

void* decrementingThreadFunction(){
    for (int j = 0; j < 1000000; j++) {
	i--;
    }
    return NULL;
}

int main(int argc, char *argv[]){
    // Using a mutex because there is only a single resource being shared by two threads
    pthread_t incrementingThread, decrementingThread;
    pthread_mutex_init(&i_mutex, NULL);

    // Added ability to run the program without the mutex by specifying "no_mutex" in bash
    char no_mutex_str[9];
    strcpy(no_mutex_str, "no_mutex");
    
    int data_race_protection = 1;
    if(argc > 1) data_race_protection = strcmp(argv[1], no_mutex_str); // returns 0 if strings match
   
    if(data_race_protection == 0) {
    	pthread_create(&incrementingThread, NULL, incrementingThreadFunction, NULL);
    	pthread_create(&decrementingThread, NULL, decrementingThreadFunction, NULL);
    } else {
        pthread_create(&incrementingThread, NULL, incrementingThreadFunctionSafe, NULL);
        pthread_create(&decrementingThread, NULL, decrementingThreadFunctionSafe, NULL);
    }

    pthread_join(incrementingThread, NULL);
    pthread_join(decrementingThread, NULL);
    
    printf("The magic number is: %d\n", i);
    return 0;
}

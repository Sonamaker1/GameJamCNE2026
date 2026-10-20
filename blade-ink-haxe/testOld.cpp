#define IMPLEMENT_API
#include <hx/CFFI.h>
#include <hx/CFFIPrime.h>


#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <bink.h>
#include <cwalk.h>
#include <test.h>
#include <filesystem>
#include <iostream>

#define BINK_HAXE_NOT_FOUND 404
#define BINK_HAXE_CAN_CONTINUE 302
#define BINK_HAXE_CHOICE_FOUND 200
#define BINK_HAXE_CHOICE_MADE 201
#define BINK_HAXE_PARTIAL_CHOICE 206
#define BINK_HAXE_UNKNOWN 321
#define BINK_HAXE_FAILURE 417
#define BINK_HAXE_TEAPOT 418
#define BINK_HAXE_END 204

static char *cur_err_msg;
static char *cur_global_buffer;
static int cur_step_code = 0;
static int cur_choice_index = -1;
static int next_choice = -1;
static BINK_Story *cur_global_story;

int cplusplus_example_only_main_loop(BINK_Story *story, char *err_msg, int do_step, int index);
void haxe_init_story(const char* filename, char *err_msg);

extern "C" {
    value sum(value a, value b)
    {

        if( !val_is_int(a) || !val_is_int(b) ) return val_null;
        return alloc_int(val_int(a) + val_int(b));
    }

    value getStringTest(value a)
    {
        if( !val_is_buffer(a) ) return val_null;
        return a;
    }

    HxString stringVal(HxString inString)
    {
        printf("String : %s (%d)\n", inString.c_str(), inString.size());
        return HxString("Ok");
    }

    HxString getCurrentBuffer()
    {
        return HxString(cur_global_buffer);
    }

    void clearCurrentBuffer()
    {
        bink_cstring_free(cur_global_buffer);
        cur_global_buffer = NULL;
    }

    value getCurrentStep()
    {
        return alloc_int(cur_step_code);
    }


    void setNextChoice(value a)
    {
        next_choice =  val_int(a);
    }

    value getChoiceIndex()
    {
        return alloc_int(cur_choice_index);
    }

    HxString getCurrentError()
    {
        if(cur_err_msg != NULL){
            return HxString(cur_err_msg);
        }
        return HxString("no errors");
    }

    bool globalHasError()
    {
        if(cur_err_msg != NULL){
            return true;
        }
        return false;
    }

    HxString initGlobalStory(HxString inString){
        haxe_init_story(inString.c_str(), cur_err_msg);
        return HxString("Ok");
    }

    int globalStorySingleStep(){
        if(cur_global_story!=NULL){
            if(cur_step_code == BINK_HAXE_PARTIAL_CHOICE){
                //printf("iterating choice %d to check %d\n", choice_index, choice_index+1);
                cur_choice_index++;
            }
            else if(cur_step_code == BINK_HAXE_CHOICE_MADE){
                //printf("resetting choice %d\n", choice_index);
                cur_choice_index = -1;
            }

            cur_step_code = cplusplus_example_only_main_loop(cur_global_story, cur_err_msg, cur_step_code, cur_choice_index);
        }
        else{
            cur_step_code = BINK_HAXE_UNKNOWN;
        }

        return cur_step_code;
    }

    void doThings()
    {
        int ret = doStuff();
    }
}
DEFINE_PRIM( sum, 2 );
DEFINE_PRIM( getStringTest, 1 );
DEFINE_PRIM( doThings, 0 );
DEFINE_PRIM( setNextChoice, 1 );
DEFINE_PRIM(clearCurrentBuffer, 0);
DEFINE_PRIME1(stringVal);

DEFINE_PRIME0(getCurrentBuffer);
DEFINE_PRIME0(getCurrentError);
DEFINE_PRIME0(globalHasError);

DEFINE_PRIME0(globalStorySingleStep);
DEFINE_PRIME0(getCurrentStep);
DEFINE_PRIME1(initGlobalStory);

void finish(int rc, BINK_Story *story, char *err_msg) {
    bink_cstring_free(err_msg);
    bink_story_free(story);
    //do not close the host process this time, but do cleanup
    //exit(rc);
}

void check_ret(int ret, BINK_Story *story, char *err_msg) {
    if (ret != BINK_OK) {
        if(err_msg != NULL)
            perror(err_msg);
        
        finish(EXIT_FAILURE, story, err_msg);
    }
}

char* read_json_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open file");
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    fseek(file, 0, SEEK_SET);

    char* jsonString = (char*)malloc(fileSize + 1);
    if (!jsonString) {
        perror("Memory allocation failed");
        fclose(file);
        return NULL;
    }

    size_t bytesRead = fread(jsonString, 1, fileSize, file);
    if ((long)bytesRead != fileSize) {
        perror("Failed to read file");
        free(jsonString);
        fclose(file);
        return NULL;
    }

    jsonString[fileSize] = '\0';

    fclose(file);

    return jsonString;
}

void assert_cont(BINK_Story *story, char *expected) {
    char *err_msg = NULL;
    char *line = NULL;

    int ret = bink_story_cont(story, &line, &err_msg);
    check_ret(ret, story, err_msg);

    if (strcmp(line, expected) != 0) {
        printf("expected: %s, found: %s\n", expected, line);
        finish(EXIT_FAILURE, NULL, NULL);
    }

    bink_cstring_free(line);
}

void init_story(BINK_Story **story, const char* filename, char *err_msg){
    uint32_t ret = BINK_OK;
    printf("Story is starting.\n");
    char *json_string = read_json_file(filename);
    if(json_string == NULL)
        exit(EXIT_FAILURE);

    ret = bink_story_new(story, json_string, &err_msg);
    check_ret(ret, *story, err_msg);
    free(json_string);
}


bool helper_can_continue(BINK_Story **story, char *err_msg){
    bool can_continue;
    uint32_t ret = BINK_OK;
    ret = bink_story_can_continue(*story, &can_continue, &err_msg);
    check_ret(ret, *story, err_msg);
    return can_continue;
}

char* helper_story_continue(BINK_Story **story, char *err_msg){
    char *line = NULL;
    uint32_t ret = BINK_OK;
    ret = bink_story_cont(*story, &line, &err_msg);
    check_ret(ret, *story, err_msg);
    return line;
}

//size_t helper_story_get_choices_length(BINK_Story *story) {

//}

void helper_story_make_choice(BINK_Story **story, int choice_to_make, char *err_msg){
    uint32_t ret = BINK_OK;
    ret = bink_story_choose_choice_index(*story, choice_to_make, &err_msg);
    check_ret(ret, *story, err_msg);
}

int select_story_by_id(){
    return 0;
}

BINK_Story * helper_create_story(const char* filename, char *err_msg){
    BINK_Story *story = NULL;
    init_story(&story, filename, err_msg);
    return story;
}

void haxe_init_story(const char* filename, char *err_msg){
    if(cur_global_story != NULL){
        //Fail the currently running story to free memory.
        finish(EXIT_FAILURE, cur_global_story, err_msg);
        cur_global_story = NULL; 
    }
    init_story(&cur_global_story, filename, err_msg);
}


int cplusplus_example_only_input_prompter(int len){
    int newChoice = -1;
    while(newChoice > len || newChoice < 1){
        char inputLine[256]; 
        printf("Input> ");
        if (fgets(inputLine, sizeof(inputLine), stdin)) {
            if (1 == sscanf(inputLine, " %d", &newChoice)) {
                printf(" < input received: %d\n", newChoice);
            }
        }
    }
    return newChoice;
}

// set the global string buffer pointer
void set_last_text(char*){
    
} 

// Whatever haxe uses for string
/*
char* get_last_text(){

}
*/

char* cplusplus_example_only_secondary_loop(BINK_Story *story, char *err_msg){
    char *line = NULL;
    line = helper_story_continue(&story, err_msg);
    return line;  
}

/*
#define BINK_HAXE_NOT_FOUND 404
#define BINK_HAXE_CAN_CONTINUE 302
#define BINK_HAXE_CHOICE_MADE 200
#define BINK_HAXE_PARTIAL_CHOICE 206
#define BINK_HAXE_UNKNOWN 321
#define BINK_HAXE_FAILURE 417
#define BINK_HAXE_TEAPOT 418
#define BINK_HAXE_END 204
*/

int cplusplus_example_only_main_loop(BINK_Story *story, char *err_msg, int do_step, int index){
    //system("clear");
    bool can_continue = helper_can_continue(&story, err_msg);

    if (do_step == BINK_HAXE_CAN_CONTINUE || can_continue) {
        char *line = NULL;

        if(cur_global_buffer != NULL){
            bink_cstring_free(cur_global_buffer); 
            cur_global_buffer = NULL;
        }
    
        line = cplusplus_example_only_secondary_loop(story, err_msg);
        
        int len_line = strlen(line);

        //printf("%.*s\n", len_line-1, line);

        // We'll need to hold onto this until the next step ends
        cur_global_buffer = line;
        
        can_continue = helper_can_continue(&story, err_msg);    
        
        if(can_continue){
            return BINK_HAXE_CAN_CONTINUE;
        }
        else{
            return BINK_HAXE_CHOICE_FOUND;
        }
    }

    if( do_step == BINK_HAXE_CHOICE_FOUND){
        if(cur_global_buffer != NULL){
            bink_cstring_free(cur_global_buffer); 
            cur_global_buffer = NULL;
        }
        return BINK_HAXE_PARTIAL_CHOICE;
    }
    
    if (do_step == BINK_HAXE_PARTIAL_CHOICE) {
        bool end = false;
        
        // kinda inefficient to keep allocating a choices object but idk what else to do  
        // Obtain and print choices
        // size_t len = helper_story_get_choices_length(story);
        BINK_Choices *choices = NULL;
        uint32_t ret = BINK_OK;
        char *err_msg = NULL;
        size_t len = 0;

        ret = bink_story_get_current_choices(story, &choices, &len, &err_msg);
        check_ret(ret, story, err_msg);

        if (index < len){
            //char *text = NULL;

            if(cur_global_buffer != NULL){
                bink_cstring_free(cur_global_buffer); 
                cur_global_buffer = NULL;
            }
            
            char *err_msg = NULL;
            int ret = bink_choices_get_text(choices, index, &cur_global_buffer, &err_msg);
            if (ret != BINK_OK) {
                finish(EXIT_FAILURE, NULL, err_msg);
                len = index; // index+1 of last valid choice
            }

            //TODO: deconstruct for loop and get the values of text to haxe somehow 
            // printf("[ %lu. ] %s\n", index+1, cur_global_buffer);
            //bink_cstring_free(text); 
            //cur_global_buffer = text;
            bink_choices_free(choices);
            return BINK_HAXE_PARTIAL_CHOICE;
        }
        
        bink_choices_free(choices);
        
        end = len == 0;

        if (!end) {
            printf("\n");
            if(next_choice < 0){
                int newChoice = cplusplus_example_only_input_prompter(len);
                helper_story_make_choice(&story, newChoice-1, err_msg);
            }
            else{
                helper_story_make_choice(&story, next_choice, err_msg);
                next_choice = -1;
            }
            return BINK_HAXE_CHOICE_MADE;
        }

        return BINK_HAXE_END;
    }
    
    return BINK_HAXE_UNKNOWN;
}


int doStuff() {
    char *err_msg = NULL;

	printf("Starting path is: ");
    std::cout << std::filesystem::current_path();
    printf("\n");
    BINK_Story *story = helper_create_story("./mods/BinkTest/stories/test.ink.json", err_msg);
    int choice_index = -1;
    int return_code = cplusplus_example_only_main_loop(story, err_msg, BINK_HAXE_TEAPOT, choice_index);
    
    // Test. This while loop will be fully handled on the haxe side when I'm done.
    while(return_code != BINK_HAXE_END && return_code != BINK_HAXE_FAILURE && return_code != BINK_HAXE_UNKNOWN){
        if(return_code == BINK_HAXE_PARTIAL_CHOICE){
            //printf("iterating choice %d to check %d\n", choice_index, choice_index+1);
            choice_index++;
        }
        else if(return_code==BINK_HAXE_CHOICE_MADE){
            //printf("resetting choice %d\n", choice_index);
            choice_index = -1;
        }
        return_code = cplusplus_example_only_main_loop(story, err_msg, return_code, choice_index);
        
    }
    
    printf("\nStories ended ok.\n");
    finish(EXIT_SUCCESS, story, err_msg);
    return 0;
}

int main(void){
    return doStuff();
}

#define IMPLEMENT_API
#include <hx/CFFI.h>


#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <bink.h>

extern "C" {
    value sum(value a, value b)
    {

        if( !val_is_int(a) || !val_is_int(b) ) return val_null;
        return alloc_int(val_int(a) + val_int(b));
    }
}
DEFINE_PRIM( sum, 2 );


void finish(int rc, BINK_Story *story, char *err_msg) {
    bink_cstring_free(err_msg);
    bink_story_free(story);
    exit(rc);
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

void helper_can_continue(BINK_Story **story, bool *ret_continue, char *err_msg){
    uint32_t ret = BINK_OK;
    ret = bink_story_can_continue(*story, ret_continue, &err_msg);
    check_ret(ret, *story, err_msg);
}

char* helper_story_continue(BINK_Story **story, char *err_msg){
    char *line = NULL;
    uint32_t ret = BINK_OK;
    ret = bink_story_cont(*story, &line, &err_msg);
    check_ret(ret, *story, err_msg);
    return line;
}

void helper_story_continue_free(char * line){
    bink_cstring_free(line);
}

size_t helper_story_get_choices_length(BINK_Story *story) {
    BINK_Choices *choices = NULL;
    uint32_t ret = BINK_OK;
    char *err_msg = NULL;
    size_t len = 0;

    ret = bink_story_get_current_choices(story, &choices, &len, &err_msg);
    check_ret(ret, story, err_msg);

    for (size_t i=0; i < len; i++) {
        char *text = NULL;
        char *err_msg = NULL;
        int ret = bink_choices_get_text(choices, i, &text, &err_msg);
        if (ret != BINK_OK) {
            finish(EXIT_FAILURE, NULL, err_msg);
            return i; // index+1 of last valid choice
        }

        //TODO: deconstruct for loop and get the values of text to haxe somehow 
        printf("%lu. %s\n", i+1, text);
        bink_cstring_free(text);
    }
    
    bink_choices_free(choices);
    return len; //len is the only value still important to main loop after printing
}

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

int cplusplus_example_only_input_prompter(int len){
    int newChoice = -1;
    while(newChoice > len || newChoice < 1){
        char inputLine[256]; 
        printf("Input> ");
        if (fgets(inputLine, sizeof(inputLine), stdin)) {
            if (1 == sscanf(inputLine, " %d", &newChoice)) {
                printf(" < input received: %d\n\n", newChoice);
            }
        }
    }
    return newChoice;
}

void cplusplus_example_only_main_loop(BINK_Story *story, char *err_msg){
    char *line = NULL;
    bool end = false;
    while(!end) {
        system("clear");
        bool can_continue;
        helper_can_continue(&story, &can_continue, err_msg);
        
        while (can_continue) {
            line = helper_story_continue(&story, err_msg);
            puts(line);
            helper_story_continue_free(line);
            helper_can_continue(&story, &can_continue, err_msg);        
        }

        // Obtain and print choices
        size_t len = helper_story_get_choices_length(story);
        end = len == 0;

        if (!end) {
            printf("\n");
            int newChoice = cplusplus_example_only_input_prompter(len);
            helper_story_make_choice(&story, newChoice-1, err_msg);
        }
    }
}

bool haxe_deconstructed_loop(BINK_Story *story, char *err_msg){
    char *line = NULL;
    bool end = false;
    system("clear");
    bool can_continue;
    helper_can_continue(&story, &can_continue, err_msg);
    
    while (can_continue) {
        line = helper_story_continue(&story, err_msg);
        puts(line);
        helper_story_continue_free(line);
        helper_can_continue(&story, &can_continue, err_msg);        
    }

    // Obtain and print choices
    size_t len = helper_story_get_choices_length(story);
    end = len == 0;

    if (!end) {
        printf("\n");
        int newChoice = cplusplus_example_only_input_prompter(len);
        helper_story_make_choice(&story, newChoice-1, err_msg);
    }
    return end;
}

int main(void) {
    char *err_msg = NULL;
    BINK_Story *story = helper_create_story("./test.ink.json", err_msg);
    bool end = haxe_deconstructed_loop(story, err_msg);

    // Test. This while loop will be fully handled on the haxe side when I'm done.
    while(!end){
        end = haxe_deconstructed_loop(story, err_msg);
    }
    
    printf("Stories ended ok.\n");
    finish(EXIT_SUCCESS, story, err_msg);
}

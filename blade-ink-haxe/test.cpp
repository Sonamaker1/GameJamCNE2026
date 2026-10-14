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

void print_choices(BINK_Choices *choices, size_t len) {
    for (size_t i=0; i < len; i++) {
        char *text = NULL;
        char *err_msg = NULL;
        int ret = bink_choices_get_text(choices, i, &text, &err_msg);
        if (ret != BINK_OK) {
            finish(EXIT_FAILURE, NULL, err_msg);
        }

        printf("%lu. %s\n", i+1, text);
        bink_cstring_free(text);
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


int main(void) {
    uint32_t ret = BINK_OK;
    BINK_Story *story = NULL;
    BINK_Choices *choices = NULL;
    char *err_msg = NULL;
    char *line = NULL;
    printf("Story is starting.\n");
    char *json_string = read_json_file("./test.ink.json");
    if(json_string == NULL)
        exit(EXIT_FAILURE);

    ret = bink_story_new(&story, json_string, &err_msg);
    check_ret(ret, story, err_msg);
    free(json_string);

    bool end = false;

    while(!end) {
        system("clear");
        bool can_continue;
        ret = bink_story_can_continue(story, &can_continue, &err_msg);
        check_ret(ret, story, err_msg);

        while (can_continue) {
            ret = bink_story_cont(story, &line, &err_msg);
            check_ret(ret, story, err_msg);
            puts(line);
            bink_cstring_free(line);

            ret = bink_story_can_continue(story, &can_continue, &err_msg);
            check_ret(ret, story, err_msg);
        }

        // Obtain and print choices
        int newChoice = 1000;
        size_t len = 0;
        ret = bink_story_get_current_choices(story, &choices, &len, &err_msg);
        check_ret(ret, story, err_msg);
        //printf("Num. choices: %lu\n", len);

        if (len !=0) {
            print_choices(choices, len);
            printf("\n");
            bink_choices_free(choices);
            int newChoice = -1;
            while(newChoice > len || newChoice < 1){
                char line[256];
                printf("Input> ");
                if (fgets(line, sizeof(line), stdin)) {
                    if (1 == sscanf(line, " %d", &newChoice)) {
                        printf(" < input received: %d\n\n", newChoice);
                    }
                }
            }
            ret = bink_story_choose_choice_index(story, newChoice-1, &err_msg);
            check_ret(ret, story, err_msg);
        } else {
            end = true;
        }

        

    }

    printf("Story ended ok.\n");

    finish(EXIT_SUCCESS, story, err_msg);
}

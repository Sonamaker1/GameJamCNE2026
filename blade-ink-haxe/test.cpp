#define IMPLEMENT_API
#include <hx/CFFI.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#define BINK_HAXE_NOT_FOUND 404
#define BINK_HAXE_CAN_CONTINUE 302
#define BINK_HAXE_CHOICE_FOUND 200
#define BINK_HAXE_PARTIAL_CHOICE 206
#define BINK_HAXE_UNKNOWN 321
#define BINK_HAXE_FAILURE 417
#define BINK_HAXE_TEAPOT 418
#define BINK_HAXE_END 204

extern "C" {
    value sum(value a, value b)
    {

        if( !val_is_int(a) || !val_is_int(b) ) return val_null;
        return alloc_int(val_int(a) + val_int(b));
    }

    value teapot(value a)
    {
        if( !val_is_int(a) ) return val_null;
        return alloc_int(BINK_HAXE_TEAPOT);
    }
}
DEFINE_PRIM( sum, 2 );
DEFINE_PRIM( teapot, 1 );



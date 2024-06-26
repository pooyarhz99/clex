/*==============================================================================
A C/C++/Objective-C preprocessor + lexer + parser.

CONVENTIONS:
	App namespace:
	Contains the functuinality of this program. Any programmer who wants to work
	on this project and extend it, debug it, or refactor and clean it up, can
	use these stuff to make their life easier. Or don't...it's just some
	unrelated utilities, use your own stuff or libraries if you want. */

#include <Foundation/Foundation.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
//#include "sal.h"

using namespace std;


/******************************************************************************/
/*                               Configurations                               */
/******************************************************************************/

#define ALLOCATION_SIZE 8192    // the default page size of the application, independent of the OS page size
#define SHOW_DEBUG_INFO 1       // whether to output extra debug info to stdout or not, values can be 0 or 1

#pragma GCC diagnostic ignored "-fpermissive" // disables -fpermissive flag, gives a compile error in GCC 4.7+


/******************************************************************************/
/*                               Internal Types                               */
/******************************************************************************/

// TODO(pooya): Add your types here...


// Each module depends on the previously imported modules. Be careful if you
// want to reorder this, or add a new module of your own.
#import "char.mm"      // character handling
#import "string.mm"    // string memory management
#import "error.mm"     // error handling
#import "lexer.mm"     // lexer

namespace App
{	static zstr ReadTextFile(const_zstr filename)
	{	FILE* fs = fopen(filename, "rb");
		if (fs == NULL)
		{	printf("file \"%s\" cannot be opened", filename);
			return(NULL);
		}

		fseek(fs, 0, SEEK_END);
		long size = ftell(fs);
		fseek(fs, 0, SEEK_SET);

		zstr contents = (zstr)malloc(size + 1);
		if (contents == NULL)
		{	printf("not enough memory...bailing out\n");
			_Exit(EXIT_FAILURE);
		}
		fread(contents, size, 1, fs);
		contents[size] = '\0';
		fclose(fs);

		return(contents);
	}
}

int main(int argc, char *argv[])
{	// Static Initializations
	initialize_string_memory();

	#if SHOW_DEBUG_INFO == 1
	printf("---------------------------------------------------------------\n");
	printf("----------- DEBUG INFORMATOIN\n");
	#endif

	zstr source_code = App::ReadTextFile("sample.txt");
	
	// Print source code.
	// printf("Source Code:\n");
	// printf(source_code);

	FTokenList *tokens = lex_string(source_code);

	// Print errors, if any.
	printf("\n\nErrors: (%d)\n", error_log.error_count);
	for (int i = 0; i < error_log.error_count; i++)
	{	printf("\tmain.mm(0, 0): %s\n", error_log.error_list[i].error_message);
	}
	
	// Print lexer state.
	#if SHOW_DEBUG_INFO == 1
	printf("\nList of Tokens: (%d)\n", tokens->len);
	for (int i = 0; i < tokens->len; i++)
	{	printf("\t%d) ", i+1);
		App::PrintToken(&tokens->data[i]);
	}
	#endif
	
	return(0);
}

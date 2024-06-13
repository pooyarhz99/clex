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

#define ALLOCATION_SIZE 8192
#define SHOW_DEBUG_INFO 1

#pragma GCC diagnostic ignored "-fpermissive" // disables -fpermissive flag, errors in GCC 4.7+


/******************************************************************************/
/*                               Internal Types                               */
/******************************************************************************/

// TODO(pooya): Add your types here...


#include "char.mm"      // character handling
#include "string.mm"    // string memory management
#include "error.mm"     // error handling
#include "lexer.mm"     // lexer

namespace App
{	static zstr ReadFile(const_zstr filename)
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
			exit(1);
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

	zstr source_code = App::ReadFile("sample.txt");
	
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

// ------------------------------- struct token --------------------------------
struct token
{	enum
	{	// 0 through 255 is reserved for ASCII characters
		// this allows for easy encoding of tokens such as operators +, -, !, etc

		TT_Name = 256, // Called `identifier` in the C/C++ standards
		TT_IntegerLiteral,
		TT_StringLiteral,

		// Compound Symbols and Literals
		TT_PlusPlus, TT_MinusMinus, TT_EqualEqual,
	} type;

	union
	{	const_pstr name; // also called identifier  // TODO(pooya): This must be switched to a fat string to save on memory.
		zstr zs;         // for zero-terminated string literals
		int64_t integer; // for integer literals
	} value;

	// Debugging information.
	uint64_t line;
	uint64_t column;
};


// --------------------------- @interface FTokenList ---------------------------
@interface FTokenList : NSObject
	{	@public struct token *data;
		@public size_t        len;
		@public size_t        maxlen;
	}

	- (instancetype) initWithLength: (size_t) _len;
@end

@implementation FTokenList
	- (instancetype) initWithLength: (size_t) _len
	{	if ((self = [super init]))
		{	data   = (struct token*)calloc(_len, sizeof(struct token));
			len    = 0;
			maxlen = _len;
		}
		return self;
	}
@end


inline void eat_space(char **location)
{	while (chr_space(**location))
		(*location)++;
}

/*
Takes a string as input, and returns a list of tokens as output.
The returned value is allocated using calloc(), so you must deallocate it using
"free(return_value.data);".
*/
FTokenList *lex_string(const_zstr s)
{	FTokenList *result = [[FTokenList alloc] initWithLength: ALLOCATION_SIZE]; // allocate 8 KiB
	char *head = s;  // the current character we're reading from the input

	register char run_lexer = 1; // allows us to cancel the lexer in the middle of the lexing process

	while (run_lexer)
	{	eat_space(&head);

		switch (*head)
		{	case '\0':
			{	run_lexer = 0;
			} break;
			
			// Handle special characters and operators.
			case ';':
			{	result->data[result->len++].type = (typeof(result->data[0].type))';';
				head++;
			} break;
			case ':':
			{	result->data[result->len++].type = (typeof(result->data[0].type))':';
				head++;
			} break;
			case '(':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'(';
				head++;
			} break;
			case ')':
			{	result->data[result->len++].type = (typeof(result->data[0].type))')';
				head++;
			} break;
			case '{':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'{';
				head++;
			} break;
			case '}':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'}';
				head++;
			} break;
			case '[':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'[';
				head++;
			} break;
			case ']':
			{	result->data[result->len++].type = (typeof(result->data[0].type))']';
				head++;
			} break;
			case '=':
			{	if (*(++head) != '\0' && *head == '=')
				{	result->data[result->len++].type = token::TT_EqualEqual;
					head++;
				}
				else result->data[result->len++].type = (typeof(result->data[0].type))'=';
			} break;
			case '+':
			{	if (*(++head) != '\0' && *head == '+')
				{	result->data[result->len++].type = token::TT_PlusPlus;
					head++;
				}
				else result->data[result->len++].type = (typeof(result->data[0].type))'+';
			} break;
			case '-':
			{	if (*(++head) == '-')
				{	result->data[result->len++].type = token::TT_MinusMinus;
					head++;
				}
				else result->data[result->len++].type = (typeof(result->data[0].type))'-';
			} break;
			case '*':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'*';
				head++;
			} break;
			case '/':
			{	result->data[result->len++].type = (typeof(result->data[0].type))'/';
				head++;
			} break;

			// Handle numeric literals.
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
			{	char *starting_character = head;
				while (chr_digit(*head))
				{	head++;
				}
				result->data[result->len].type = token::TT_IntegerLiteral;
				result->data[result->len].value.integer = atoi64(starting_character);
				result->len++;
			} break;

			// Handle string literals.
			case '"':
			{	head++;                 // skip the " character
				char *old_head = head;  // store a temporary copy of head
				while (*head++ != '"'); // traverse the string literal

				// create a copy
				zstr strltrl = (zstr)malloc(head - old_head);
				memcpy(strltrl, old_head, head - old_head - 1);
				strltrl[head - old_head - 1] = '\0';

				// initialize the token
				result->data[result->len].type = token::TT_StringLiteral;
				result->data[result->len].value.zs = strltrl;
				result->len++;
			} break;

			// Invalid characters in the character set, show error.
			case '`':
			{	RaiseError(0, 0, "Invalid character ` was found.\n");
				head++;
			} break;

			// On any other character, either is a keyword or a name (a.k.a. identifier)
			default:
			{	pstr name;
				unsigned char size = 0;
				while (chr_letter(*head))
				{	name[++size] = *head;
					head++;
				}
				name[0] = size;
				result->data[result->len].type = token::TT_Name;
				memcpy(const_cast<char*>(result->data[result->len].value.name), name, 256);
				result->len++;
			}
		}
	}
	
	return(result);
}



namespace App
{	// For debugging. Prints a humand-readable text for a token into the
	// specified stream.
	void PrintToken(struct token *token)
	{	switch (token->type)
		{	case ';': { printf("Semi-colon\n");        } break;
			case ':': { printf(":\n");                 } break;
			case '(': { printf("Left Parentheses\n");  } break;
			case ')': { printf("Right Parentheses\n"); } break;
			case '{': { printf("{\n");                 } break;
			case '}': { printf("}\n");                 } break;
			case '[': { printf("[\n");                 } break;
			case ']': { printf("]\n");                 } break;
			case '=': { printf("=\n");                 } break;
			case '+': { printf("+\n");                 } break;
			case '-': { printf("-\n");                 } break;
			case '*': { printf("*\n");                 } break;
			case '/': { printf("/\n");                 } break;

			case token::TT_PlusPlus:   { printf("++\n"); } break;
			case token::TT_MinusMinus: { printf("--\n"); } break;
			case token::TT_EqualEqual: { printf("==\n"); } break;

			case token::TT_IntegerLiteral:
			{	printf("%d\n", token->value.integer);
			} break;
			case token::TT_StringLiteral:
			{	printf("\"%s\\0\"\n", token->value.zs);
			} break;

			case token::TT_Name:
			{	char tmp[256];
				memcpy(tmp, token->value.name, 256);
				tmp[tmp[0] + 1] = '\0';
				printf("Name: %s\n", &tmp[1]);
			} break;
		}
	}
} // end namespace App;

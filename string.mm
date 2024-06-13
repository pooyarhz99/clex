/*==============================================================================
String memory management library. */



// TODO(pooya): Currently we're using malloc, but we should switch to a page
// allocator such as VirutalAlloc()/mmap() or our own allocator.


// Zero-terminated String
// 
// Default C strings that are terminated with a 0 byte.
// The type const_zstr is the type of string literals.

typedef char *zstr;
typedef const char *const_zstr;


// Pascal String
// 
// Always occupies 256 bytes. Size is stored at index 0 (first byte).
// Maximum character size is 255.

typedef char pstr[256];
typedef const char const_pstr[256];


// Fat String
// 
// Like a pascal string, but with two differences:
// 1. the size is 2 bytes
// 2. the buffer is always the same size as length
// 
// Implementation Note:
// never use _fstr_intenral outside of this file, this is not part of the API, but rather to ease the implementation

typedef struct
{	int16_t len; // how many characters are there in the string
	char txt[];  // the text
} _fstr_internal, *fstr;





// String Memory
// A segment of memory which contains all dynamic immutable strings.
// It is linked list of blocks of 8192 bytes (8KB).
struct
{	char *memory; // points to the initial block
	char *last;   // points to one byte past the last stored string
} string_memory;

// Initializes the string memory.
// This function must be called before any functionality from this file is used.
void initialize_string_memory()
{	string_memory.memory = malloc(8192);         // TODO(pooya): handle run out of memory
	string_memory.last   = string_memory.memory;
}

// Increases the size of string memory. Use it when you run out of memory to
// store strings.
void expand_string_memory()
{	char *new_block = malloc(8192);
	string_memory.memory[8191 - sizeof(void*)] = new_block;
}




// Fat String API

// Allocates a new fat string from a zero-terminated string
fstr fstr_from_zstr(zstr from)
{	
}









/*
| ------------------------------------------------------------------------------
| Converts a string to a 64-bit integer.
| ------------------------------------------------------------------------------
*/
int64_t atoi64(const_zstr s)
{	int64_t n = 0;
	int neg = 0;
	// while (chr_space(*s)) s++; // it is specified in the standard, but we provide whitespace guarantees, so don't need it
	switch (*s)
	{	case '-': neg=1;
		case '+': s++;
	}
	/* Compute n as a negative number to avoid overflow on INT_MIN */
	while (chr_digit(*s))
		n = 10*n - (*s++ - '0');
	return neg ? n : -n;
}

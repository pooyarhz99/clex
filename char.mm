/*==============================================================================
ASCII character handling library.

TABLE OF CONTENTS:

chr_space(x)  - whether the given character is a whitespace or not
chr_digit(x)  - whether the given character is a digit or not
chr_letter(x) - whether the given character is an alphabetic character or not
chr_upper(x)  - whether the given character is an uppercase letter or not
chr_lower(x)  - whether the given character is a lowercase letter or not
chr_space(x)  - whether the given character is a whitespace or not */


// -----------------------------------------------------------------------------
// Returns whether the specified character is whitespace or not.
char chr_space(char c)
{	char result = (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\f' || c == '\v');
	return(result);
}


// -----------------------------------------------------------------------------
// Returns whether the specified character is a digit or not.
char chr_digit(char c)
{	char result = (c >= '0' && c <= '9');
	return(result);
}


// -----------------------------------------------------------------------------
// Returns whether the specified character is a letter (alphabetic character) or
// not.
char chr_letter(char c)
{	char result = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
	return(result);
}


// -----------------------------------------------------------------------------
// Returns whether the specified character is an uppercase letter or not.
char chr_upper(char c)
{	char result = (c >= 'A' && c <= 'Z');
	return(result);
}


// -----------------------------------------------------------------------------
// Returns whether the specified character is a lowercase letter or not.
char chr_lower(char c)
{	char result = (c >= 'a' && c <= 'z');
	return(result);
}

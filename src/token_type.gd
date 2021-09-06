extends Node

"""
Defines all token types, reserved words and main token type.
"""

const TT_STRING = 5

enum {
	ILLEGAL,
	EOF,
	
	# Identifiers + Literals
	IDENT,
	NUMBER,
	STRING,
	
	# Operators
	ASSIGN,
	PLUS,
	PLUS_EQ,
	MINUS,
	MINUS_EQ,
	MUL,
	MUL_EQ,
	DIV,
	DIV_EQ,
	
	# Comparison
	EQ,
	BANG,
	NEQ,
	LT,
	LEQ,
	GT,
	GEQ,
	AND,
	OR,
	NULL,
	
	# Delimiters
	COMMA,
	SEMICOLON,
	COLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	LBRACKET,
	RBRACKET,
	
	# Keywords
	FUNCTION,
	LET,
	TRUE,
	FALSE,
	IF,
	ELSE,
	RETURN,
}

# Token names
var token_names: Array = [
	"ILLEGAL",
	"EOF",
	
	# Identifiers + Literals
	"IDENT",
	"NUMBER",
	"STRING",
	
	# Operators
	"ASSIGN",
	"PLUS",
	"PLUS_EQ",
	"MINUS",
	"MINUS_EQ",
	"MUL",
	"MUL_EQ",
	"DIV",
	"DIV_EQ",
	
	# Comparison
	"EQ",
	"BANG",
	"NEQ",
	"LT",
	"LEQ",
	"GT",
	"GEQ",
	"AND",
	"OR",
	"NULL",
	
	# Delimiters
	"COMMA",
	"SEMICOLON",
	"COLON",
	"LPAREN",
	"RPAREN",
	"LBRACE",
	"RBRACE",
	"LBRACKET",
	"RBRACKET",
	
	# Keywords
	"FUNCTION",
	"LET",
	"TRUE",
	"FALSE",
	"IF",
	"ELSE",
	"RETURN",	
]

# keywords dictionary
var _keywords: Dictionary = {
	"fn": FUNCTION,
	"let": LET,
	"true": TRUE,
	"false": FALSE,
	"if": IF,
	"else": ELSE,
	"return": RETURN,
}


# Search for an identifier or keyword
func lookup_ident(ident: String) -> int:
	if _keywords.has(ident):
		return _keywords[ident]

	return IDENT

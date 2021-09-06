extends Node

class_name Lexer

const EOF = char(255)

var _input: String
var _pos: int
var _peek: int
var _ch: String


func _init(input:String) -> void:
	_input = input
	_advance()


func _advance() -> void:
	if _peek >= len(_input):
		_ch = EOF
	else:
		_ch = _input[_peek]
		_pos = _peek
		_peek += 1


func next_token() -> Token:
	var tok: Token = Token.new(TokenType.EOF, '')
	_skip_white_space()

	match _ch:
		'=':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.EQ, "==")
			else:
				tok = _new_token(TokenType.ASSIGN, '=')
		'+':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.PLUS_EQ, "+=")
			else:
				tok = _new_token(TokenType.PLUS, '+')
		'-':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.MINUS_EQ, "-=")
			else:
				tok = _new_token(TokenType.MINUS, '-')
		'!':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.NEQ, "!=")
			else:
				tok = _new_token(TokenType.BANG, '!')
		'/':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.DIV_EQ, "/=")
			else:
				tok = _new_token(TokenType.DIV, '/')
		'*':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.MUL_EQ, "*=")
			else:
				tok = _new_token(TokenType.MUL, '*')
		'<':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.LEQ, "<=")
			else:
				tok = _new_token(TokenType.LT, '<')
		'>':
			if _peek_char() == '=':
				_advance()
				tok = _new_token(TokenType.GEQ, ">=")
			else:
				tok = _new_token(TokenType.GT, '>')
		';':
			tok = _new_token(TokenType.SEMICOLON, ';')
		':':
			tok = _new_token(TokenType.COLON, ':')
		',':
			tok = _new_token(TokenType.COMMA, ',')
		'{':
			tok = _new_token(TokenType.LBRACE, '{')
		'}':
			tok = _new_token(TokenType.RBRACE, '}')
		'(':
			tok = _new_token(TokenType.LPAREN, '(')
		')':
			tok = _new_token(TokenType.RPAREN, ')')
		'[':
			tok = _new_token(TokenType.LBRACKET, '[')
		']':
			tok = _new_token(TokenType.RBRACKET, ']')
		'"':
			tok.Type = TokenType.STRING
			tok.Literal = _get_string()
		EOF:
			tok.Type = TokenType.EOF
			tok.Literal = ''
		_:
			if _is_letter(_ch):
				tok.Literal = _get_identifier()
				tok.Type = TokenType.lookup_ident(tok.Literal)
				return tok
			elif _is_digit(_ch):
				tok.Literal = _get_number()
				tok.Type = TokenType.NUMBER
				return tok
			else:
				tok.Type = TokenType.ILLEGAL
				tok.Literal = _ch
			
	_advance()
	return tok

# ----------------------------------------------------- #
# Helper functions
# ----------------------------------------------------- #
func _skip_white_space() -> void:
	while _ch != EOF and _is_space(_ch):
		_advance()


func _is_space(ch) -> bool:
	return ch == ' ' or ch == '\t' or ch == '\r' or ch == '\n'


func _new_token(t: int, l: String) -> Token:
	return Token.new(t, l)


func _peek_char() -> String:
	if _peek >= len(_input):
		return EOF
	return _input[_peek]


func _get_number() -> String:
	var _position: int = _pos
	while _ch != EOF and _is_digit(_ch):
		_advance()
	
	return _input.substr(_position, _pos-_position)


func _get_string() -> String:
	var _position: int = _pos + 1
	_advance()

	while true:
		if _ch == EOF or _ch == '"':
			break
	
	return _input.substr(_position, _pos-_position)


func _get_identifier() -> String:
	var _position: int = _pos
	while _ch != EOF and _is_letter(_ch):
		_advance()
	
	return _input.substr(_position, _pos-_position)


func _is_letter(ch: String) -> bool:
	var _char = ord(ch)
	return ord('a') <= _char and _char <= ord('z') or \
		ord('A') <= _char and _char <= ord('Z')


func _is_digit(ch: String) -> bool:
	var _char = ord(ch)
	return ord('0') <= _char and _char <= ord('9')


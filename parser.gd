extends Node

class_name Parser

var curToken: Token
var peekToken: Token
var lastToken: Token
var _errors: Array = []
var l: Lexer


# precedence order
enum {
	LOWEST = 1,
	LOGIC_OR = 2,
	LOGIC_AND = 3,
	EQUALITY = 4,
	COMPARISON = 5,
	TERM = 6,
	FACTOR = 7,
	PREFIX = 8,
	CALL = 9,
	INDEX = 10,
}

# token precedence
var _token_precedence: Dictionary = {
	TokenType.OR: LOGIC_OR,
	TokenType.AND: LOGIC_AND,
	TokenType.EQ: EQUALITY,
	TokenType.NEQ: EQUALITY,
	TokenType.LT: COMPARISON,
	TokenType.LEQ: COMPARISON,
	TokenType.GT: COMPARISON,
	TokenType.GEQ: COMPARISON,
	TokenType.PLUS: TERM,
	TokenType.MINUS: TERM,
	TokenType.MUL: FACTOR,
	TokenType.DIV: FACTOR,
	TokenType.MINUS: PREFIX,
	TokenType.BANG: PREFIX,
	TokenType.LPAREN: CALL,
	TokenType.LBRACKET: INDEX,
}


func _init(l: Lexer) -> void:
	self.l = l
	_advance()
	_advance()


# ----------------------------------------------- #
# Parsing functions
# ----------------------------------------------- #
func parse() -> Array:
	var _stmts: Array = []

	while !_cur_token_is(TokenType.EOF):
		var s: = _parse_stmt()

		if s != null:
			_stmts.append(s)

		if _cur_token_is(TokenType.SEMICOLON):
			_advance()

	return _stmts


func _parse_stmt() -> Ast.Stmt:
	match curToken.Type:
		TokenType.LET:
			return _parse_let_stmt()
		TokenType.RETURN:
			return _parse_return_stmt()
		_:
			return _parse_expression_stmt()


func _parse_let_stmt() -> Ast.Stmt:
	return null


func _parse_return_stmt() -> Ast.Stmt:
	return null


func _parse_expression_stmt() -> Ast.Stmt:
	var _stmt: = Ast.ExpressionStmt.new()

	var _exp: = _parse_expression(LOWEST)
	if _exp == null:
		return null
	_stmt.expression = _exp

	return _stmt


func _parse_expression(precedence: int) -> Ast.Expr:
	var _left_expr = _prefix_fn()
	if _left_expr == null:
		_new_error("no parsing function for token: " + curToken._to_string())
		return null

	while !_is_at_end() and precedence < _cur_precedence():
		_left_expr = _infix_fn(_left_expr)

	return _left_expr


func _prefix_fn() -> Ast.Expr:
	match curToken.Type:
		TokenType.IDENT, \
		TokenType.NUMBER, \
		TokenType.STRING, \
		TokenType.NULL, \
		TokenType.TRUE, \
		TokenType.FALSE:
			return _parse_literal()
		_:
			return null


func _infix_fn(left: Ast.Expr) -> Ast.Expr:
	match curToken.Type:
		TokenType.PLUS, \
		TokenType.MINUS, \
		TokenType.MUL, \
		TokenType.DIV:
			return _parse_infix_expr(left)
		_:
			return left


func _parse_literal() -> Ast.Expr:
	var _exp: = Ast.LiteralExpr.new()
	_exp.value = curToken
	_advance()
	return _exp


func _parse_infix_expr(left: Ast.Expr) -> Ast.Expr:
	var _exp: = Ast.BinaryExpr.new()
	_exp.token = curToken
	_exp.left = left
	_exp.operator = curToken.Literal
	var _pre: int = _cur_precedence()
	_advance()

	var _e: = _parse_expression(_pre)
	if _e == null:
		return null

	_exp.right = _e
	
	return _exp

# ----------------------------------------------- #
# Helper functions
# ----------------------------------------------- #
func _advance() -> void:
	curToken = peekToken
	peekToken = l.next_token()


func _cur_precedence() -> int:
	if _token_precedence.has(curToken.Type):
		return _token_precedence[curToken.Type]
	return LOWEST


func _cur_token_is(t: int) -> bool:
	return curToken.Type == t


func _new_error(msg: String) -> void:
	_errors.append(msg)


func _is_at_end() -> bool:
	return curToken.Type == TokenType.EOF

extends Node

class_name Parser

# precedence order

const LOWEST = 1
const EQUALITY = 2
const COMPARISON = 3
const TERM = 4
const FACTOR = 5
const PREFIX = 6
const CALL = 7


var curToken: Token
var peekToken: Token
var lastToken: Token
var _errors: Array = []
var l: Lexer



# token precedence
var _token_precedence: Dictionary = {
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
}


func _init(l: Lexer) -> void:
	self.l = l
	_advance()
	_advance()


# ----------------------------------------------- #
# Parsing functions
# ----------------------------------------------- #
func parse() -> Ast.Program:
	var program := Ast.Program.new()
	var _stmts: Array = []

	while !_cur_token_is(TokenType.EOF):
		var s: = _parse_stmt()

		if s != null:
			_stmts.append(s)

		_advance()
	program.statements = _stmts
	return program


func _parse_stmt() -> Ast.AstNode:
	match curToken.Type:
		TokenType.LET:
			return _parse_let_stmt()
		TokenType.RETURN:
			return _parse_return_stmt()
		_:
			return _parse_expression_stmt()


func _parse_let_stmt() -> Ast.AstNode:
	return null


func _parse_return_stmt() -> Ast.AstNode:
	return null


func _parse_expression_stmt() -> Ast.AstNode:
	var _stmt: = Ast.ExpressionStmt.new()

#	var _exp: = _parse_expression(LOWEST)
	var _exp: = expression()
	if _exp == null:
		return null
	_stmt.expression = _exp

	if _peek_token_is(TokenType.SEMICOLON):
		_advance()

	return _stmt


func expression() -> Ast.AstExpression:
	return logicOr()


func logicOr() -> Ast.AstExpression:
	var node = logicAnd()
	while curToken.Type == TokenType.OR:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = logicAnd()
		node = binaryNode
	
	return node


func logicAnd() -> Ast.AstExpression:
	var node = equality()
	while curToken.Type == TokenType.AND:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = equality()
		node = binaryNode

	return node


func equality() -> Ast.AstExpression:
	var node = comparison()
	while curToken.Type in [TokenType.EQ, TokenType.NEQ]:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = comparison()
		node = binaryNode

	return node


func comparison() -> Ast.AstExpression:
	var node = term()
	while curToken.Type in [TokenType.PLUS, TokenType.MINUS]:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = term()
		node = binaryNode

	return node


func term() -> Ast.AstExpression:
	var node = factor()
	while curToken.Type in [TokenType.PLUS, TokenType.MINUS]:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = factor()
		node = binaryNode

	return node


func factor() -> Ast.AstExpression:
	var node = primary()
	while curToken.Type in [TokenType.MUL, TokenType.DIV]:
		var ope = curToken
		_advance()
		var binaryNode := Ast.BinaryExpr.new()
		binaryNode.left = node
		binaryNode.operator = ope.Literal
		binaryNode.right = primary()
		node = binaryNode

	return node


func primary() -> Ast.AstExpression:
	var literal
	if curToken.Type == TokenType.NUMBER:
		literal = Ast.LiteralExpr.new()
		literal.value = curToken
		_advance()
		return literal
	return null


func _parse_expression(precedence: int) -> Ast.AstExpression:
	var _left_expr = _prefix_fn()
	if _left_expr == null:
		_new_error("no parsing function for token: " + curToken._to_string())
		return null

	while precedence < _peek_precedence():
		if _infix_fn():
			_advance()
			_left_expr = _parse_infix_expr(_left_expr)
		else:
			return _left_expr

	return _left_expr


func _prefix_fn() -> Ast.AstExpression:
	match curToken.Type:
		TokenType.IDENT, \
		TokenType.NUMBER, \
		TokenType.STRING, \
		TokenType.BANG, \
		TokenType.MINUS, \
		TokenType.TRUE, \
		TokenType.FALSE, \
		TokenType.NULL:
			return _parse_literal()
		_:
			return null


func _infix_fn() -> bool:
	match peekToken.Type:
		TokenType.PLUS, \
		TokenType.MINUS, \
		TokenType.MUL, \
		TokenType.DIV:
			return true
		_:
			return false


func _parse_literal() -> Ast.AstExpression:
	var _exp: = Ast.LiteralExpr.new()
	_exp.value = curToken
	return _exp


func _parse_infix_expr(left: Ast.AstExpression) -> Ast.AstExpression:
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


func _peek_precedence() -> int:
	if _token_precedence.has(peekToken.Type):
		return _token_precedence[peekToken.Type]
	return LOWEST


func _cur_token_is(t: int) -> bool:
	return curToken.Type == t


func _peek_token_is(t: int) -> bool:
	return peekToken.Type == t


func _new_error(msg: String) -> void:
	_errors.append(msg)


func _is_at_end() -> bool:
	return curToken.Type == TokenType.EOF

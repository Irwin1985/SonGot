extends Ast.Visitor

class_name AstPrinter

var _program: Array = []


func _init(p: Array) -> void:
	_program = p


func _to_string() -> String:
	var _output: String
	for stmt in _program:
		_output += _eval_stmt(stmt)
	return _output


func _eval_stmt(s: Ast.Stmt):
	return s.Accept(self)


func _eval_expr(e: Ast.Expr):
	return e.Accept(self)


func VisitExpressionStmt(e: Ast.ExpressionStmt):
	return _eval_expr(e.expression)


func VisitLiteralExpr(e: Ast.LiteralExpr):
	return e.value.Literal


func VisitBinaryExpr(e: Ast.BinaryExpr):
	var _left = _eval_expr(e.left)
	var _right = _eval_expr(e.right)
	return "(%s %s %s)" % [_left, e.operator, _right]

extends Node

class_name Ast

class Visitor:
	func VisitExpressionStmt(e: ExpressionStmt):
		return null


	func VisitLiteralExpr(e: LiteralExpr):
		return null


	func VisitBinaryExpr(e: BinaryExpr):
		return null

# -------------------------------------------------- #
# Statements Nodes
# -------------------------------------------------- #
class VisitorStmt extends Visitor:
	pass


class Stmt:
	func Accept(v: Visitor):
		return null


	func _to_string() -> String:
		return ''


class ExpressionStmt extends Stmt:
	var expression: Expr

	func Accept(v: Visitor):
		return v.VisitExpressionStmt(self)

	func _to_string() -> String:
		return ''



# -------------------------------------------------- #
# Expression Nodes
# -------------------------------------------------- #
class VisitorExpr extends Visitor:
	pass


class Expr:
	func Accept(v: Visitor):
		pass


class LiteralExpr extends Expr:
	var value: Token


	func Accept(v: Visitor):
		return v.VisitLiteralExpr(self)


	func _to_string() -> String:
		return "%s" % value


class BinaryExpr extends Expr:
	var token: Token
	var left: Ast.Expr
	var operator: String
	var right: Ast.Expr


	func Accept(v: Visitor):
		return v.VisitBinaryExpr(self)


	func _to_string() -> String:
		return "%s %s %s" % [left._to_string(), operator, right._to_string()]
	

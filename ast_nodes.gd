class_name Ast

class AstNode:
	func TokenLiteral() -> String:
		return ''
	
	func String() -> String:
		return ''


class AstStatement extends AstNode:
	func statementNode() -> String:
		return ''


class AstExpression extends AstNode:
	func expressionNode() -> String:
		return ''


class Program extends AstNode:
	var statements := []

	func String() -> String:
		var out: String
		for i in statements.size():
			out += statements[i].String()
		return out


class ExpressionStmt extends AstExpression:
	var expression: Ast.AstExpression


	func String() -> String:
		if self.expression != null:
			return self.expression.String()
		return ''


class LiteralExpr extends AstExpression:
	var value: Token

	func String() -> String:
		return value.Literal


class BinaryExpr extends AstExpression:
	var token: Token
	var left: Ast.AstExpression
	var operator: String
	var right: Ast.AstExpression

	func String() -> String:
		var out: String

		out += "("
		out += self.left.String()
		out += " " + self.operator + " "
		out += self.right.String()
		out += ")"
		
		return out

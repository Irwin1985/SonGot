"""
Token class
"""
extends Node
class_name Token


var Type: int
var Literal: String


func _init(t: int, l: String) -> void:
	Type = t
	Literal = l


func _to_string() -> String:
	return "<" + TokenType.token_names[Type] + ", '" + Literal + "'>"

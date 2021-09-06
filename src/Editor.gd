extends Control


func _ready() -> void:
	var input: = "let five = 5;"
	var l: Lexer = Lexer.new(input)
	var tok: = l.next_token()

	while tok.Type != TokenType.EOF:
		print(tok._to_string())
		tok = l.next_token()

	print(tok._to_string())

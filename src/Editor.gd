extends Control


func _ready() -> void:
	var input: = '1 + 2 - 3 * 4 / 5;'
	_test_lexer(input)
	_test_parser(input)


func _test_lexer(input: String) -> void:
	var l: Lexer = Lexer.new(input)
	var tok: = l.next_token()
	while tok.Type != TokenType.EOF:
		print(tok._to_string())
		tok = l.next_token()
	print(tok._to_string())


func _test_parser(input: String) -> void:
	var l: Lexer = Lexer.new(input)
	var p: Parser = Parser.new(l)
	var program: = p.parse()
	if len(p._errors) > 0:
		print(p._errors)
	var astPrinter: = AstPrinter.new(program)
	print(astPrinter._to_string())

extends Node2D

var left_interval_bound = 1
var right_interval_bound = 100
var right_interval_bound_easy = 20
var right_interval_multiplication = 10
var points = 100

# Lista de operações matemáticas
var operacoes_2 = ["+", "-", "*"]
var operacoes_3 = ["+", "-"]
var tipos_perguntas = ["operacao", "tempo"]

# Dicionário para armazenar a pergunta atual
var pergunta_atual = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gerar_pergunta_aleatoria():
	var tipo_pergunta = tipos_perguntas[randi() % tipos_perguntas.size()]
	match tipo_pergunta:
		"operacao":
			pergunta_atual = gerar_pergunta_operacao()
		"tempo":
			pergunta_atual = gerar_pergunta_tempo()
			
func gerar_pergunta_operacao():
	var operacao
	var numero1
	var numero2
	var numero3
	var resposta_correta
	var pergunta
	var opcoes = []
	randomize()
	if randi_range(1, 2) == 1:
		operacao = operacoes_2[randi() % operacoes_2.size()]
		numero1 = randi_range(left_interval_bound, right_interval_bound)
		numero2 = randi_range(left_interval_bound, right_interval_bound)
		match operacao:
			"+":
				resposta_correta = numero1 + numero2
				pergunta = str(numero1) + " + " + str(numero2)
				if numero1 > 20 and numero2 > 20:
					points = 200
			"-":
				while numero1 < numero2:
					numero1 = randi_range(numero2, right_interval_bound)
				resposta_correta = numero1 - numero2
				pergunta = str(numero1) + " - " + str(numero2)
				if numero1 > 20 and numero2 > 20:
					points = 200
			"*":
				while numero2 > 10 or numero1 > 10:
					numero1 = randi_range(left_interval_bound, right_interval_multiplication)
					numero2 = randi_range(left_interval_bound, right_interval_multiplication)
				resposta_correta = numero1 * numero2
				pergunta = str(numero1) + " * " + str(numero2)
	else:
		operacao = operacoes_3[randi() % operacoes_3.size()]
		numero1 = randi_range(left_interval_bound, right_interval_bound_easy)
		numero2 = randi_range(left_interval_bound, right_interval_bound_easy)
		numero3 = randi_range(left_interval_bound, right_interval_bound_easy)
		match operacao:
			"+":
				resposta_correta = numero1 + numero2 + numero3
				pergunta = str(numero1) + " + " + str(numero2) + " + " + str(numero3)
			"-":
				while numero1 < (numero2 + numero3):
					numero1 = randi_range(left_interval_bound, right_interval_bound)
					numero2 = randi_range(left_interval_bound, 5)
					numero3 = randi_range(left_interval_bound, 10)
				resposta_correta = numero1 - numero2 - numero3
				pergunta = str(numero1) + " - " + str(numero2) + " - " + str(numero3)

	opcoes = [resposta_correta]
	for opcoes_perguntas in range(4):
		var opcao_incorreta
		var resposta_offset = int(resposta_correta / 10) + 10
		while true:
			opcao_incorreta = resposta_correta + randi_range(-resposta_offset, resposta_offset)
			if opcao_incorreta != resposta_correta and !opcoes.has(opcao_incorreta) and opcao_incorreta > 0:
				break
		opcoes.append(opcao_incorreta)

	var resultado = {
		"resposta_correta": resposta_correta,
		"opcoes": opcoes,
		"pergunta": pergunta,
		"pontos": points
	}
	points = 100 # Reset points value
	return resultado

func gerar_pergunta_tempo():
	var tipo = randi_range(1, 3)
	var pergunta
	var resposta_correta
	var opcoes = []
	if tipo == 1:  # Semanas para Dias
		var semanas = randi_range(2, 10)
		var dias = semanas * 7
		pergunta = str(semanas) + " semanas representa\nquantos dias?"
		resposta_correta = dias
	else:
		var anos = randi_range(2, 10)
		var meses = anos * 12
		pergunta = str(anos) + " anos possui\nquantos meses?"
		resposta_correta = meses
	opcoes = [resposta_correta]
	for opcoes_perguntas in range(4):
		var opcao_incorreta
		while true:
			opcao_incorreta = resposta_correta + randi_range(-30, 30)  # Variação aleatória para opções incorretas
			if opcao_incorreta != resposta_correta and opcao_incorreta > 0 and opcao_incorreta not in opcoes:
				break
		opcoes.append(opcao_incorreta)

	var resultado = {
		"pergunta": pergunta,
		"resposta_correta": resposta_correta,
		"opcoes": opcoes,
		"pontos": points
	}
	points = 100
	return resultado

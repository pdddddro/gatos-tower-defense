extends Control

signal tutorial_completed
signal tutorial_skipped

var is_manual_mode: bool = false
var current_page: int = 0
var tutorial_pages = []

func _ready():
	get_tree().paused = true
	setup_tutorial_pages()
	
	# Conecta os botões existentes aos sinais
	if has_node("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Next"):
		$"MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Next".pressed.connect(_on_next_pressed)
	
	if has_node("MarginContainer/VBoxContainer2/SkipTutorial"):
		$"MarginContainer/VBoxContainer2/SkipTutorial".pressed.connect(_on_skip_pressed)
	
	# Conecta o botão de voltar
	if has_node("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Back"):
		$"MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Back".pressed.connect(_on_back_pressed)
		
	await get_tree().process_frame
	# Mostra a primeira página
	show_current_page()

func setup_tutorial_pages():
	tutorial_pages = [
		{
			"title": "Como funciona o jogo?",
			"steps": [
				"Seu objetivo é impedir que os Slimes cheguem no final do caminho",
				"1. Posicione os seus Gatinhos",
				"2. Compre cartinhas com peixe para melhorá-los",
				"3. Vença ao terminar todas as rodadas... Mas cuidado! Caso muitos slimes cheguem no final do trajeto, você perde!"
			],
			"animation": "Tips"
		}
		,{
			"title": "Como ganho os Gatinhos?",
			"steps": [
				"1. Clique no ícone dos Gatos",
				"2. Escolha o seu, arraste e solte ele para o campo",
				"3. Posicione o estrategicamente",
				"4. Agora aprecie a fofura... - Digo, use uma cartinha para melhorá-lo!"
			],
			"animation": "CatShop"
		}
		,{
			"title": "Como consigo Cartinhas?",
			"steps": [
				"1. Clique no ícone das Cartas",
				"2. Abra o Pack de Cartas e escolha umas",
				"3. Arraste até o Gato (cada gato pode ter até 4 cartas equipadas)",
				"4. Clique no gato e confira a mudança nos atributos!",
			],
			"animation": "CardUsage"
		}
		,{
			"title": "Como eu começo a jogar?",
			"steps": [
				"1. Clique no botão Play para iniciar a rodada",
				"2. Cada rodada tem uma onda diferente de inimigos",
				"3. Cuidado! Caso um slime chegue no final do trajeto, você perde vida!",
			],
			"animation": "WaveStart"
		}
		,{
			"title": "Dicas Importantes",
			"steps": [
				"1. Cuidado com os Chefões... eles são perigosos",
				"2. As frases tem dicas valiosas sobre o jogo e sobre o planeta, leia!",
				"3. Se divirta, aprenda e aprecie a fofura..."
			],
			"animation": "Tips"
		}
	]

func show_current_page():
	var page_data = tutorial_pages[current_page]
	
	# Atualiza o título
	var title_node = get_node_or_null("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/VBoxContainer/Title")
	if title_node:
		title_node.text = page_data.title
	else:
		print("Erro: Nó Title não encontrado")
	
	# Atualiza os steps
	update_steps(page_data.steps)
	
	# Atualiza a animação
	var animated_sprite = get_node_or_null("MarginContainer/VBoxContainer2/Content/HBoxContainer/VBoxContainer/TutorialVideo")
	if animated_sprite and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(page_data.animation):
		animated_sprite.animation = page_data.animation
		animated_sprite.play()
	else:
		print("Erro: AnimatedSprite2D não encontrado ou animação '", page_data.animation, "' não existe")
	
	# Atualiza visibilidade dos botões
	update_button_visibility()

func update_steps(steps: Array):
	var steps_container = get_node_or_null("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/VBoxContainer/Steps")
	
	if not steps_container:
		print("Erro: Container de steps não encontrado")
		return
	
	# Lista de nós de steps disponíveis
	var step_nodes = ["Step1", "Step2", "Step3", "Step4"]
	
	# Atualiza cada step
	for i in range(step_nodes.size()):
		var step_node = steps_container.get_node_or_null(step_nodes[i])
		if step_node:
			if i < steps.size():
				step_node.text = steps[i]
				step_node.visible = true
			else:
				step_node.visible = false
		else:
			print("Erro: Step node '", step_nodes[i], "' não encontrado")

func update_button_visibility():
	# Botão de voltar - só aparece se não for a primeira página
	var back_button = get_node_or_null("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Back")
	if back_button:
		back_button.visible = current_page > 0
	
	# Botão próximo - muda texto na última página
	var next_button = get_node_or_null("MarginContainer/VBoxContainer2/Content/MarginContainer/Content/Controls/Next")
	if next_button:
		var next_label = next_button.get_node_or_null("HBoxContainer/Label")
		if next_label:
			if current_page >= tutorial_pages.size() - 1:
				if is_manual_mode:
					next_label.text = "Fechar"
				else:
					next_label.text = "Finalizar"
			else:
				next_label.text = "Próximo"

func set_manual_mode(manual: bool):
	is_manual_mode = manual
	if manual:
		# Altera texto do botão skip para modo manual
		var skip_button_label = get_node_or_null("MarginContainer/VBoxContainer2/SkipTutorial/Label")
		if skip_button_label:
			skip_button_label.text = "Fechar Tutorial"
	
	# Atualiza visibilidade dos botões
	update_button_visibility()

func _on_next_pressed():
	if current_page < tutorial_pages.size() - 1:
		current_page += 1
		show_current_page()
	else:
		# Última página - finaliza tutorial
		emit_signal("tutorial_completed")
		get_tree().paused = false
		queue_free()

func _on_back_pressed():
	if current_page > 0:
		current_page -= 1
		show_current_page()

func _on_skip_pressed():
	emit_signal("tutorial_skipped")
	get_tree().paused = false
	queue_free()

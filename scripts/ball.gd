extends CharacterBody2D

var speed = 300
var is_active = true

func _ready() -> void:
	velocity = Vector2(-speed, speed)

func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			
			var collider = collision.get_collider()
			if collider.has_method("hit"):
				collider.hit()
		
		# Verhindert, dass der Ball zu langsam wird
		if abs(velocity.y) < 100:
			velocity.y = -200 if velocity.y > 0 else 200
		
		# Stellt sicher, dass der Ball sich immer horizontal bewegt
		if velocity.x == 0:
			velocity.x = -speed if randi() % 2 == 0 else speed

		# Prüft, ob der Ball aus dem Bildschirm gefallen ist
		if position.y > get_viewport_rect().size.y:
			restart_game()

func restart_game():
	await get_tree().create_timer(1).timeout  # 1 Sekunde warten, bevor das Spiel neu startet
	get_tree().reload_current_scene()

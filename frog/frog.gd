extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var is_chasing = false
var is_preparing_hop = false
var is_alive = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if is_chasing:
		var direction = ($"../../Player/Player".position - position).normalized()
		$AnimatedSprite2D.flip_h = direction.x < 0
		
		
		if is_on_floor():
			velocity.x = 0
			
			
			if not is_preparing_hop:
				is_preparing_hop = true
				$AnimatedSprite2D.play("Hop")
		else:
			velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("Idle")
	
	
	move_and_slide()


func _on_animated_sprite_2d_frame_changed() -> void:
	if not is_chasing:
		return

	if not is_on_floor():
		return

	if not is_preparing_hop:
		return

	if $AnimatedSprite2D.animation == "Hop" and $AnimatedSprite2D.frame == 2:
		var direction = ($"../../Player/Player".position - position).normalized()
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * SPEED
		is_preparing_hop = false


func _on_vision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing = true


func _on_vision_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing = false
		is_preparing_hop = false
		velocity = Vector2.ZERO


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 325
		death()


func _on_attack_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if is_alive:
			body.health -= 25
		
		
		$AnimatedSprite2D.play("Attack")
		await $AnimatedSprite2D.animation_finished
		
		
		death()


func death() -> void:
	is_alive = false
	
	
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	
	
	queue_free()

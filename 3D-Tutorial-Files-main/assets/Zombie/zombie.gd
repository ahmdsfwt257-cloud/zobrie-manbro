extends CharacterBody3D

@export var speed = 5
@export var gravity = -10
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = %player

func _ready() -> void:
	# شيلنا الكومنت عشان الأنيميشن يشتغل
	$holder/AnimationPlayer.play("mixamo_com")
	
	# اتأكد إن الـ Timer شغال (لو مش معمول له Autostart)
	$Timer.start()


func _physics_process(delta: float) -> void:
	# 1. طبق الجاذبية (واضرب في دلتا عشان تكون ثابتة)
	if not is_on_floor():
		velocity.y += gravity * delta
	$holder.look_at(player.global_position)
	# 2. احسب الاتجاه من الـ NavAgent
	var dir = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	
	# 3. غيّر السرعة الأفقية (x و z) بس
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	
	# 4. اتحرك
	move_and_slide()


func make_path() -> void:
	navigation_agent_3d.target_position = player.global_position


func _on_timer_timeout() -> void:
	# 5. هو ده أهم تعديل
	# شيلنا pass وحطينا الدالة اللي بتحدث المسار
	make_path()

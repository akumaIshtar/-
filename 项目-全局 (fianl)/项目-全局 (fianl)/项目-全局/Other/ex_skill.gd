extends Node2D

# 确保 Fragment.tscn 文件存在于指定路径
var fragment_scene: PackedScene
func _ready():
	fragment_scene = preload("res://SpecialEffects/Fragment.tscn")

func activate_ultimate_skill():
	# 创建一个新的 ImageTexture 用于渲染场景
	var render_texture = ImageTexture.create_from_image(Image.create(get_viewport_rect().size.x, get_viewport_rect().size.y, false, Image.FORMAT_RGBA8))

	# 获取当前场景的渲染数据
	var viewport = get_viewport()
	var viewport_image = viewport.get_texture().get_image()
	render_texture.update(viewport_image)

	# 碎片大小
	var fragment_size = Vector2(100, 100)
	var viewport_size = get_viewport_rect().size

	# 计算碎片数量
	var cols = viewport_size.x / fragment_size.x
	var rows = viewport_size.y / fragment_size.y

	for i in range(int(cols)):
		for j in range(int(rows)):
			var fragment = fragment_scene.instantiate() as Sprite2D
			fragment.texture = render_texture
			fragment.region_rect = Rect2(i * fragment_size.x, j * fragment_size.y, fragment_size.x, fragment_size.y)
			fragment.position = Vector2(i * fragment_size.x, j * fragment_size.y)
			add_child(fragment)

			# 给碎片添加物理效果
			var rigid_body = fragment.get_node("RigidBody2D") as RigidBody2D
			# 使用 randf_range() 替代 rand_range()
			var force = Vector2(randf_range(-100, 100), randf_range(-100, 100))
			rigid_body.apply_impulse(force)

	

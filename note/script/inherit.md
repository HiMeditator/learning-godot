# GDScript 中的继承详解

继承是面向对象编程的核心概念之一，GDScript 提供了完整的继承支持，让代码可以更好地组织和复用。

## 1. 基本继承语法

### 使用 `extends` 关键字
```gdscript
# 基类 (父类)
class_name Animal

var name: String
var age: int

func _init(animal_name: String, animal_age: int):
    name = animal_name
    age = animal_age

func speak():
    print("动物发出声音")

func get_info() -> String:
    return name + "，年龄：" + str(age)
```

```gdscript
# 派生类 (子类)
extends Animal

var breed: String

func _init(animal_name: String, animal_age: int, animal_breed: String).(animal_name, animal_age):
    breed = animal_breed

func speak():
    print(name + "汪汪叫！")

func get_info() -> String:
    return .get_info() + "，品种：" + breed
```

## 2. 继承 Godot 内置节点

### 继承场景节点
```gdscript
# 自定义角色类
extends CharacterBody2D

class_name Player

@export var speed: float = 300.0
@export var jump_force: float = 500.0

var health: int = 100

func _physics_process(delta):
    var direction = Input.get_axis("ui_left", "ui_right")
    velocity.x = direction * speed
    
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = -jump_force
    
    move_and_slide()

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        die()

func die():
    queue_free()
```

### 继承 Control 节点创建自定义 UI
```gdscript
extends Control

class_name HealthBar

@export var max_health: int = 100
@onready var health: int = max_health

func _ready():
    update_display()

func set_health(value: int):
    health = clamp(value, 0, max_health)
    update_display()

func update_display():
    # 自定义绘制逻辑
    queue_redraw()

func _draw():
    var bar_width = size.x * (float(health) / max_health)
    draw_rect(Rect2(0, 0, bar_width, size.y), Color.RED)
```

## 3. 方法重写 (Override)

### 使用 `virtual` 和 `override`（Godot 4.0+）
```gdscript
# 基类
class_name Weapon

func attack():
    print("武器攻击")

# 虚方法 - 期望子类重写
func special_attack():
    pass  # 基类不实现具体逻辑

# 派生类
extends Weapon

# 重写普通方法
func attack():
    print("剑挥砍！")
    .attack()  # 可选：调用父类方法

# 重写虚方法
func special_attack():
    print("剑的特殊攻击：旋风斩！")
```

## 4. 调用父类方法

### 使用 `.` 操作符
```gdscript
# 基类
class_name GameEntity

var position: Vector2

func _init():
    position = Vector2.ZERO
    print("GameEntity 初始化")

func move(new_position: Vector2):
    position = new_position
    print("移动到位置: " + str(position))

# 派生类
extends GameEntity

func _init():
    .()  # 调用父类的 _init
    print("Player 初始化")

func move(new_position: Vector2):
    # 在父类逻辑前后添加额外逻辑
    print("开始移动...")
    .move(new_position)  # 调用父类的 move 方法
    print("移动完成！")
```

## 5. 多级继承

```gdscript
# 第一级：游戏对象基类
class_name GameObject

var name: String
var position: Vector2

func _init(obj_name: String, pos: Vector2):
    name = obj_name
    position = pos

func describe():
    return name + " 在 " + str(position)

# 第二级：角色基类
extends GameObject

class_name Character

var health: int = 100

func _init(obj_name: String, pos: Vector2).(obj_name, pos):
    pass

func take_damage(damage: int):
    health -= damage
    return health > 0

# 第三级：具体角色类
extends Character

class_name Enemy

var attack_power: int = 10

func _init(obj_name: String, pos: Vector2).(obj_name, pos):
    pass

func attack(target: Character):
    print(name + " 攻击！")
    return target.take_damage(attack_power)

func describe():
    return .describe() + "，生命值：" + str(health)
```

## 6. 使用 `class_name` 和资源继承

### 创建可实例化的类
```gdscript
# items/base_item.gd
class_name BaseItem
extends Resource

@export var item_name: String = ""
@export var description: String = ""
@export var value: int = 0

func use():
    print("使用物品: " + item_name)

# items/weapon_item.gd
class_name WeaponItem
extends BaseItem

@export var damage: int = 10
@export var durability: int = 100

func use():
    print("装备武器: " + item_name + "，伤害: " + str(damage))

func attack():
    durability -= 1
    print("攻击！耐久度: " + str(durability))
```

## 7. 继承的实际应用示例

### 游戏实体系统
```gdscript
# entity.gd
class_name Entity
extends Node2D

@export var max_health: int = 100
var current_health: int

func _ready():
    current_health = max_health

func take_damage(amount: int):
    current_health -= amount
    current_health = max(0, current_health)
    
    if current_health <= 0:
        on_death()
    else:
        on_damage(amount)

func on_damage(amount: int):
    pass  # 子类重写

func on_death():
    queue_free()

# player.gd
extends Entity

@export var speed: float = 200.0

func _physics_process(delta):
    # 玩家移动逻辑
    pass

func on_damage(amount: int):
    # 玩家受伤特效
    $AnimationPlayer.play("hurt")
    # 屏幕震动等效果

func on_death():
    # 玩家死亡处理
    get_tree().change_scene_to_file("res://game_over.tscn")

# enemy.gd
extends Entity

@export var attack_damage: int = 10

func on_damage(amount: int):
    # 敌人受伤效果
    modulate = Color.RED
    var tween = create_tween()
    tween.tween_property(self, "modulate", Color.WHITE, 0.3)

func on_death():
    # 敌人死亡效果
    $DeathParticles.emitting = true
    $CollisionShape2D.set_deferred("disabled", true)
    await get_tree().create_timer(1.0).timeout
    queue_free()
```

## 8. 继承的最佳实践

1. **遵循 is-a 关系**: 确保子类确实是父类的一种特殊类型
2. **合理使用虚方法**: 在基类中定义接口，让子类实现具体行为
3. **避免过度继承**: 继承层次不宜过深，通常 2-3 层为宜
4. **使用组合替代继承**: 对于不是严格 is-a 的关系，考虑使用节点组合
5. **保持 LSP 原则**: 子类应该能够替换父类而不影响程序正确性

## 9. 继承 vs 场景

```gdscript
# 使用继承（当需要代码复用和类型关系时）
class_name BaseEnemy
# 共享的敌人逻辑

# 使用场景（当需要可视化编辑和复杂组合时）
# 创建 enemy.tscn，包含精灵、碰撞体、动画等
# 然后通过脚本继承或实例化使用
```

继承是 GDScript 中组织代码的强大工具，合理使用可以让代码更加清晰、可维护，并促进代码复用。
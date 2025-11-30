在 GDScript 中，`get` 和 `set` 是用于定义属性访问器的特殊方法，它们允许你在读取和设置变量值时执行自定义逻辑。

## 基本语法

```gdscript
var variable_name:
    get():
        return some_value
    set(value):
        # 处理赋值逻辑
        some_value = value
```

## 简单示例

```gdscript
var health: int = 100
var max_health: int = 100

# 使用 get 和 set 的百分比属性
var health_percent: float:
    get:
        return float(health) / max_health
    set(value):
        health = int(value * max_health)
        health = clamp(health, 0, max_health)  # 确保在有效范围内

# 使用
func _ready():
    print(health_percent)  # 输出: 1.0
    health_percent = 0.5   # 设置 health 为 50
    print(health)          # 输出: 50
```

## 实际应用场景

### 1. 数据验证

```gdscript
var score: int = 0:
    set(value):
        # 确保分数不为负数
        score = max(0, value)
        # 分数变化时更新UI
        update_score_display()

func update_score_display():
    $ScoreLabel.text = "Score: " + str(score)
```

### 2. 依赖其他变量的属性

```gdscript
var base_damage: int = 10
var strength: int = 1

var total_damage: int:
    get:
        return base_damage * strength
    set(value):
        # 不允许直接设置总伤害
        print("Cannot set total_damage directly!")

# 使用
func attack():
    print("Damage: ", total_damage)  # 自动计算
```

### 3. 缓存计算

```gdscript
var radius: float = 1.0
var _cached_area: float = -1

var area: float:
    get:
        if _cached_area < 0:
            _cached_area = PI * radius * radius
        return _cached_area
    set(value):
        radius = sqrt(value / PI)
        _cached_area = -1  # 重置缓存

# 当 radius 改变时重置缓存
func set_radius(new_radius: float):
    radius = new_radius
    _cached_area = -1
```

### 4. 只读属性

```gdscript
var player_name: String = "Hero"

# 只读属性
var display_name: String:
    get:
        return player_name + " the Brave"

# 尝试设置会报错
func _ready():
    print(display_name)  # 输出: Hero the Brave
    # display_name = "New Name"  # 这会报错！
```

### 5. 复杂逻辑处理

```gdscript
var inventory: Array = []

var has_items: bool:
    get:
        return not inventory.is_empty()

var item_count: int:
    get:
        return inventory.size()
    set(value):
        # 调整库存大小
        if value < inventory.size():
            inventory.resize(value)
        elif value > inventory.size():
            for i in range(value - inventory.size()):
                inventory.append(null)
```

## 使用 getter/setter 方法

除了内联定义，也可以使用方法：

```gdscript
var _position: Vector2 = Vector2.ZERO

func get_position() -> Vector2:
    return _position

func set_position(value: Vector2):
    _position = value
    position_changed()

func position_changed():
    print("Position changed to: ", _position)
```

## 注意事项

1. **避免无限递归**：
```gdscript
# 错误示例 - 会导致栈溢出
var bad_example: int:
    get:
        return bad_example  # 无限递归！
    set(value):
        bad_example = value  # 无限递归！
```

2. **使用不同的变量名**：
```gdscript
var _internal_value: int = 0

var safe_example: int:
    get:
        return _internal_value
    set(value):
        _internal_value = value
```

3. **性能考虑**：简单的 getter/setter 通常很快，但复杂的计算应考虑缓存。

## 总结

GDScript 中的 `get` 和 `set` 提供了强大的数据封装能力：
- 数据验证和约束
- 自动计算派生属性
- 触发副作用（如更新UI）
- 实现只读属性
- 缓存优化

合理使用它们可以让代码更加健壮和可维护。
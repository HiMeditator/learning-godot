# GDScript 中的组（Groups）用法详解

在 GDScript 中，组（Groups）是一种非常有用的机制，允许你将节点组织在一起，以便批量操作和管理。下面详细介绍组的用法：

## 基本概念

组是 Godot 引擎中的一个核心功能，允许你给节点添加标签，然后通过组名来操作这些节点。

## 常用方法

### 1. 添加节点到组

```gdscript
# 在代码中添加节点到组
node.add_to_group("enemies")
node.add_to_group("ui_elements")
```

### 2. 从组中移除节点

```gdscript
# 从组中移除节点
node.remove_from_group("enemies")
```

### 3. 检查节点是否在组中

```gdscript
# 检查节点是否属于某个组
if node.is_in_group("players"):
    print("这是一个玩家节点")
```

### 4. 获取组中的所有节点

```gdscript
# 获取场景中所有属于指定组的节点
var enemies = get_tree().get_nodes_in_group("enemies")
```

## 实际应用示例

### 游戏中的敌人生成和管理

```gdscript
# 敌人类
extends CharacterBody2D

func _ready():
    add_to_group("enemies")
    
func take_damage(amount):
    # 受伤逻辑
    pass

# 游戏管理器
extends Node

func clear_all_enemies():
    var enemies = get_tree().get_nodes_in_group("enemies")
    for enemy in enemies:
        enemy.queue_free()

func damage_all_enemies(damage_amount):
    var enemies = get_tree().get_nodes_in_group("enemies")
    for enemy in enemies:
        enemy.take_damage(damage_amount)
```

### UI 元素批量管理

```gdscript
# UI 管理器
extends CanvasLayer

func hide_all_ui():
    var ui_elements = get_tree().get_nodes_in_group("ui_elements")
    for element in ui_elements:
        element.visible = false

func show_all_ui():
    var ui_elements = get_tree().get_nodes_in_group("ui_elements")
    for element in ui_elements:
        element.visible = true
```

### 通过编辑器添加组

除了代码方式，你还可以在 Godot 编辑器中添加组：

1. 选择节点
2. 在节点面板中点击"组"标签
3. 输入组名并点击"添加"

## 高级用法

### 发送消息到组内所有节点

```gdscript
# 向组内所有节点发送通知
get_tree().call_group("enemies", "on_player_spotted", player_position)

# 带返回值的调用
var results = get_tree().call_group("collectibles", "get_value")
```

### 场景切换时保持组

```gdscript
# 设置节点为持久化，在场景切换时保持组关系
node.set_owner(get_tree().current_scene)
```

## 最佳实践

1. **使用有意义的组名**：组名应该清晰表达其用途
2. **避免过度使用**：只在需要批量操作时使用组
3. **注意性能**：大型组可能会影响性能，特别是在频繁操作时
4. **清理不需要的组**：当节点被销毁时，会自动从组中移除

## 常见用例

- 敌人生成和管理
- UI 元素批量显示/隐藏
- 收集物品管理
- 触发器系统
- 保存/加载系统

组是 Godot 中非常强大的工具，合理使用可以大大简化游戏逻辑的实现。
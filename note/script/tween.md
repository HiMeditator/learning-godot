# Godot 中的 Tween 详细用法

Tween（补间动画）是 Godot 中用于创建平滑动画和过渡的强大工具。它可以在指定的时间内平滑地改变对象的属性值。

## 1. 创建 Tween

### 方法一：使用 create_tween()（Godot 4.0+）
```gdscript
var tween = create_tween()
```

### 方法二：使用 Tween.new()
```gdscript
var tween = Tween.new()
add_child(tween)
```

## 2. 基本用法

### 属性动画
```gdscript
# 移动节点
tween.tween_property($Sprite2D, "position", Vector2(400, 300), 1.0).from(Vector2(0, 0))

# 改变透明度
tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.5)

# 缩放节点
tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 1.0)

# 旋转节点
tween.tween_property($Sprite2D, "rotation_degrees", 360, 2.0)
```

### 方法调用
```gdscript
# 在动画过程中调用方法
tween.tween_callback($Label.set_text.bind("动画开始"))
tween.tween_interval(1.0)  # 等待1秒
tween.tween_callback($Label.set_text.bind("动画结束"))
```

## 3. 链式动画

Tween 支持链式调用，可以创建复杂的动画序列：

```gdscript
var tween = create_tween()
tween.set_parallel(false)  # 顺序执行（默认）

tween.tween_property($Sprite2D, "position", Vector2(200, 100), 1.0)
tween.tween_property($Sprite2D, "scale", Vector2(1.5, 1.5), 0.5)
tween.tween_property($Sprite2D, "modulate", Color.RED, 0.3)
```

## 4. 并行动画

可以同时执行多个动画：

```gdscript
var tween = create_tween()
tween.set_parallel(true)  # 并行执行

tween.tween_property($Sprite2D, "position", Vector2(200, 100), 1.0)
tween.tween_property($Sprite2D, "scale", Vector2(1.5, 1.5), 1.0)
tween.tween_property($Sprite2D, "modulate", Color.RED, 1.0)
```

## 5. 缓动函数

Godot 提供了多种缓动函数来控制动画的速度曲线：

```gdscript
# 设置缓动类型
tween.tween_property($Sprite2D, "position", Vector2(400, 300), 1.0)\
    .set_ease(Tween.EASE_IN_OUT)\
    .set_trans(Tween.TRANS_BOUNCE)

# 常用缓动类型：
# - TRANS_LINEAR: 线性
# - TRANS_SINE: 正弦曲线
# - TRANS_QUINT: 五次方曲线
# - TRANS_QUART: 四次方曲线
# - TRANS_QUAD: 二次方曲线
# - TRANS_EXPO: 指数曲线
# - TRANS_ELASTIC: 弹性效果
# - TRANS_CUBIC: 三次方曲线
# - TRANS_CIRC: 圆形曲线
# - TRANS_BOUNCE: 弹跳效果
# - TRANS_BACK: 回弹效果

# 常用缓动方向：
# - EASE_IN: 先慢后快
# - EASE_OUT: 先快后慢
# - EASE_IN_OUT: 先慢后快再慢
# - EASE_OUT_IN: 先快后慢再快
```

## 6. 高级功能

### 自定义插值
```gdscript
# 使用自定义方法进行插值
tween.tween_method(set_custom_property, 0.0, 100.0, 2.0)

func set_custom_property(value: float):
    # 根据value更新自定义属性
    $Sprite2D.modulate.a = value / 100.0
```

### 动画控制
```gdscript
# 暂停和继续动画
tween.pause()
tween.play()

# 停止动画
tween.stop()

# 检查动画状态
if tween.is_valid():
    print("Tween 有效")
    
if tween.is_running():
    print("Tween 正在运行")
```

### 循环动画
```gdscript
# 设置循环次数（0 = 无限循环）
tween.set_loops(3)

# 循环模式
tween.set_loop(true)  # 循环播放
```

## 7. 完整示例

```gdscript
extends Node2D

func _ready():
    # 创建 Tween
    var tween = create_tween()
    
    # 设置并行执行
    tween.set_parallel(true)
    
    # 设置循环
    tween.set_loops(0)  # 无限循环
    
    # 多个属性同时动画
    tween.tween_property($Sprite2D, "position:x", 400.0, 2.0)\
        .set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
    
    tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 1.5)\
        .set_trans(Tween.TRANS_ELASTIC)
    
    tween.tween_property($Sprite2D, "modulate", Color.BLUE, 2.0)\
        .set_trans(Tween.TRANS_SINE)

func _input(event):
    if event.is_action_pressed("ui_accept"):
        # 重新开始动画
        var tween = create_tween()
        tween.tween_property($Sprite2D, "position", Vector2(100, 100), 1.0)
```

## 8. 注意事项

1. **自动管理**: 使用 `create_tween()` 创建的 Tween 会自动管理，不需要手动释放
2. **节点依赖**: 如果引用的节点被删除，Tween 会自动停止
3. **性能**: 对于简单的动画，Tween 性能很好，但大量复杂动画可能需要考虑其他方案
4. **Godot 版本**: 注意 Godot 3.x 和 4.x 中 Tween 的 API 有所不同

Tween 是 Godot 中非常实用的动画工具，通过合理使用可以创建出流畅自然的动画效果。
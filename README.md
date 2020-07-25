# vitamin-framework-lua
vitamin 框架 lua版本

> 维他命框架是建立在依赖注入思想上的轻型MVC框架，设计初衷是为了提高代码的可读性及提高开发效率。

## 模块说明

### class
实现了OOP语法的部分功能
```lua
Class -- OOP实现
    ++ -- 定义一个类
    ++ define(object)
    ++ 
    ++ -- 从类定义实例化
    ++ new(object,...)
    ++ 
    ++ -- 从类定义取单例
    ++ instance(nameOrObject)
    ++ -- 继承
    ++ -- base 基类
    ++ -- object 当前类实现
    ++ extend(base, object)
    ++ -- 用限定名称反射出类定义
    ++ getDefineByName(name)
    ++ -- 取得该类的限定名称
    ++ getQualifiedClassName(class)
    ++ -- 取得该类基类的限定名称
    ++ getQualifiedSuperclassName(class)
```

而对应的类结构应该看起来像这样
```lua
    -- 类定义
    Class.define({
        className="Item",
        constructor=function()
            -- todo
        end
    })

    -- 类继承
    local Item=Class.getDefineByName('Item');
    local RedItem=Class.define(Item,{
        className="RedItem",
        constructor=function()
            -- todo
        end
    })

    -- 实例化
    local redItem=Class.new(RedItem);

```

### array
数组结构

数组遵循lua的基本规则，索引从1开始,异常索引将返回0.
```lua
Array -- 数组
    + -- 转换成字符串
    + toString(splitchar)
    + -- 添加元素到末尾
    + push(...)
    + -- 删除第一个匹配内容的项
    + remove(item, startIndex)
    + removeAt(index)
    + -- 删除所有匹配内容的项
    + removeAll(item)
    + -- 查找并返回索引 0为未查找到
    + indexOf(item)
    + -- 从末尾开始查找并返回索引 0为未查找到
    + lastIndexOf(item)
    + -- 插入元素
    + insert(item, index)
    + -- 删除第一个元素 并返回该元素
    + shift()
    + -- 删除最后一个元素 并返回该元素
    + pop()
    + -- 浅表克隆
    + concat(array)
    + -- 删除从起始位置到结束位置的元素,暂未实现添加元素
    + splice(start, _end, ...)
    + -- 数组排序
    + sort(comparefunc)
    + -- 取数组值
    + get(index)
    + -- 设置数组值
    + set(index, v)
    + -- 遍历数组
    + forEach(func)
```
基本用法
```lua
    -- 实例化一个数组 的同时可以初始化数组内容
    local array=Class.new(Array,'hello','world');
    prinf(array:get(1));
    -- > hello

    -- 数组的用法
    local array1=Class.new(Array,'a','b');
    array1:push('c','d','e','f','a1','b1','c1','d1','e1','f1');
    local array2=array1:splice(1,6);
    Logger.log(array1:toString());
    Logger.log(array2:toString());
    -- [LOG] [1 : a1, 2 : b1, 3 : c1, 4 : d1, 5 : e1, 6 : f1] (Len:6)
    -- [LOG] [1 : a, 2 : b, 3 : c, 4 : d, 5 : e, 6 : f] (Len:6)
```
### logger
```lua
Logger -- Logger除了添加了类型标签外，可以打印出类结构、数组结构及Table结构
    + -- 打印分隔线
    + line(...)
    +
    + log(...)
    + info(...)
    + warn(...)
    + debug(...)
    + error(...)
```
### event
```lua
EventEmiter -- 事件
    + -- 监听事件 
    + -- type 事件类型
    + -- listener 事件回调
    + -- priority 事件优先级
    + on(type, listener, priority)
    + -- 取消事件 
    + off(type, listener)
    + -- 发送事件 
    + emit(type, ...)
```
基本用法
```lua
    -- 实例化一个数组 的同时可以初始化数组内容
    local emiter=Class.new(EventEmiter);
    emiter:on('init',function(data)
        Logger.log(data);
    end);

    emiter:emit('init',{a=1,b=2});
    -- > { a:1,b:2 }
```

## Vitamin示例
```lua
#!/usr/local/bin/lua

require('src.vitamin.core.logger');
require('src.vitamin.core.class');
require('src.vitamin.core.array');
require('src.vitamin.vitamin');

Logger.line('Logger');


-- 定义数据模型
Class.extend(Vitamin.ModelBase, {
    className="ModelLogin",
    data=1045,
    initialize = function(self)
        Logger.debug(self.className);
    end
});

-- 定义数据模型
Class.extend(Vitamin.ModelBase, {
    className="ModelUser",
    modelLogin = Inject,--声明模型注入
    initialize = function(self)
        Logger.info(self.modelLogin.data);
    end
});

-- 定义视图组件
ViewLogin = Class.extend(Vitamin.ViewBase, {
    className="ViewLogin",
    modelLogin = Inject('ModelLogin'),--声明模型注入的推荐用法
    enter = function(self)
        Logger.debug('modelLogin',self.modelLogin.data);
    end
});

-- 初始化Vitamin框架
Vitamin.initialize();

-- 进入视图
ViewLogin:enter();

```

# vitamin-framework-lua
vitamin 框架 lua版本

## 示例
```lua
#!/usr/local/bin/lua

require('src.vitamin.core.logger');
require('src.vitamin.core.class');
require('src.vitamin.core.array');
require('src.vitamin.vitamin');

Logger.line('Logger');

-- 数组的用法
local array=Class.new(Array,'a','b');
array:push('c','d','e','f','a1','b1','c1','d1','e1','f1');
local s=array:splice(1,6);
Logger.log(array:toString());
Logger.log(s:toString());
-- [LOG] [1 : a1, 2 : b1, 3 : c1, 4 : d1, 5 : e1, 6 : f1] (Len:6)
-- [LOG] [1 : a, 2 : b, 3 : c, 4 : d, 5 : e, 6 : f] (Len:6)


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

-- 事件用法
ViewLogin:on('INIT',function()Logger.log('INIT!')end);
ViewLogin:emit('INIT');

```

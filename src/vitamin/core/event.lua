-------------------------------------
-------------------------------------
--- author:陈南
--- email:kevin-chen@foxmail.com
--- wechat:kevin_nan
--- date:2020.7.24
--- Copyright (c) 2020-present, KevinChen2046 Technology.
--- All rights reserved.
-------------------------------------
-------------------------------------

require('src.vitamin.core.class');
require('src.vitamin.core.array');
EventEmiter = Class.define({
    className = "EventEmiter",
    _map = {},
    constructor = function(self)
        self._map = {};
    end,
    -- 监听事件
    -- type 事件类型
    -- listener 事件回调
    -- priority 事件优先级
    on = function(self, type, listener, priority)
        if (priority == nil) then
            priority = 0;
        end
        if (self._map[type] == nil) then
            self._map[type] = Class.new(Array);
        end
        local list = self._map[type];
        if(list:indexOf(listener)<=0)then
            list:push({
                method = listener,
                priority = priority
            });
        end
    end,
    -- 取消事件
    off = function(self, type, listener)
        local list = self._map[type];
        if (list and list.length) then
            local off = 0;
            for i = 1, list.length do
                local object = list:get(i + off)
                if (object.method == listener) then
                    list:removeAt(i);
                    off = off - 1;
                end
            end
        end
    end,
    -- 发送事件
    emit = function(self, type, ...)
        local list = self._map[type];
        if (list and list.length) then
            list:sort(function(a, b)
                return (a.priority > b.priority)
            end);
            for i = 1, list.length do
                local object = list:get(i)
                object.method(...);
            end
        end
    end
})
return EventEmiter;

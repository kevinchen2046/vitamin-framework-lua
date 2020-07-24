require('src.vitamin.core.class');
require('src.vitamin.core.array');
EventEmiter = Class.define({
    className="EventEmiter",
    _map={},
    constructor=function(self) 
        self._map = {};
    end,
    on=function(self,type,listener,priority)
        if(priority==nil)then priority=0;end;
        if (self._map[type]==nil) then self._map[type] = Class.new(Array);end;
        self._map[type]:push({ method=listener, priority= priority });
    end,
    off=function(self,type,listener)
        local list = self._map[type];
        if (list and list.length)then
            for i=1,list.length do
                local object = list:get(i)
                if (object.method == listener) then
                    list:removeAt(i);
                end
            end
        end
    end,
    emit=function(self,type,...)
        local list = self._map[type];
        if (list and list.length) then
            list:sort(function (a, b)
                if(a.priority > b.priority)then return 1;else return -1;end;
            end);
            
            for i=1,list.length do
                local object = list:get(i)
                object.method(...);
            end
        end
    end
})
return EventEmiter;
require('src.vitamin.core.class');

Array = Class.define({
    className = "Array",
    length = 0,
    data = {},
    push = function(self, ...)
        for i = 1, select('#', ...) do
            local arg = select(i, ...)
            self.length = self.length + 1;
            self.data[self.length] = arg;
        end
    end,
    remove = function(self, item)
        local finded = false;
        for k, v in pairs(self.data) do
            if (v == item) then
                finded = true;
            end
            if (finded and (k + 1 <= self.length)) then
                self.data[k] = self.data[k + 1];
            end
        end
        if (finded) then
            self.data[self.length] = nil;
            self.length = self.length - 1;
        end
    end,
    removeAt = function(self, index)
        local finded = false;
        for k, v in pairs(self.data) do
            if (k == index) then
                finded = true;
            end
            if (finded and (k + 1 <= self.length)) then
                self.data[k] = self.data[k + 1];
            end
        end
        if (finded) then
            self.data[self.length] = nil;
            self.length = self.length - 1;
        end
    end,
    splice = function(self, start, _end)
        
    end,
    sort= function(self, comparefunc)
        
    end,
    get = function(self, index)
        return self.data[index];
    end,
    set = function(self, index, v)
        self.data[index] = v;
    end,
    forEach = function(self, func)
        for k, v in pairs(self.data) do
            func(k, v);
        end
    end
})
return Array;

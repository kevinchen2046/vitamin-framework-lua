#!/usr/local/bin/lua

require('src.vitamin.core.logger');
require('src.vitamin.core.class');
require('src.vitamin.core.array');
require('src.vitamin.vitamin');

Logger.line('Logger');

local array=Class.new(Array,'a','b');
array:push('c','d','e','f','a1','b1','c1','d1','e1','f1');


local s=array:splice(1,6);
Logger.log(array:toString());
Logger.log(s:toString());
Class.extend(Vitamin.ModelBase, {
    className="ModelLogin",
    data=1045,
    initialize = function(self)
        Logger.debug(self.className);
    end
});
Class.extend(Vitamin.ModelBase, {
    className="ModelUser",
    modelLogin = Inject,
    initialize = function(self)
        Logger.info(self.modelLogin.data);
    end
});

ViewLogin = Class.extend(Vitamin.ViewBase, {
    className="ViewLogin",
    modelLogin = Inject('ModelLogin'),
    enter = function(self)
        Logger.debug('modelLogin',self.modelLogin.data);
    end
});

Vitamin.initialize();

ViewLogin:enter();

ViewLogin:on('INIT',function()Logger.log('INIT!')end);
ViewLogin:emit('INIT');
-- object.aa();


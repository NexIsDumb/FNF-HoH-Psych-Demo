package llua;


import llua.State;
import llua.Lua;
import llua.LuaL;
import llua.Macro.*;
import haxe.DynamicAccess;
class Convert {

	/**
	 * To Lua
	 */
	public static var enableUnsupportedTraces = false;
	public static var allowFunctions = true;
	public static var functionReferences:Map<Dynamic,Array<Dynamic>> = new Map<Dynamic,Array<Dynamic>>();
	// It's recommended to purge this every now and then. Note that this'll effect *every* lua state
	@:keep inline public static function cleanFunctionRefs(){
		functionReferences = new Map<Dynamic,Array<Dynamic>>();
	}
	public static function toLua(l:State, val:Any):Bool {

		switch (Type.typeof(val)) {
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			// case Type.ValueType.TFunction: 
			// 	if(!allowFunctions) return false;
			// 	return false;
				// var funcIndex = -1;
				// if(functionReferences[l] == null){
				// 	functionReferences[l] = [val];
				// 	funcIndex = 0;
				// }else{
				// 	for(i => v in functionReferences[l]){
				// 		if(v == val){
				// 			funcIndex = i;
				// 			break;
				// 		}
				// 	}
				// 	if(funcIndex == -1){
				// 		funcIndex = functionReferences[l].length;
				// 		functionReferences[l].push(val);
				// 	}
				// }
				// Lua.pushnumber(l, funcIndex);
				// Lua.pushcclosure(l, cpp.Callable.fromFunction(new cpp.Function(function(e:StatePointer):Int{return callback_handler(val,l);})),1);
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				arrayToLua(l, val);
			case Type.ValueType.TClass(haxe.ds.StringMap) | Type.ValueType.TClass(haxe.ds.ObjectMap):
				mapToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val); // {}
			default:
				if(enableUnsupportedTraces) trace('Haxe value of $val of type ${Type.typeof(val)} not supported!' );
				return false;
		}
		return true;
	}

	public static function callback_handler(cbf:Dynamic,l:State/*,cbf:Dynamic,lsp:Dynamic*/):Int {
		try{
			var l:State = cast l;
			// var cbf = null;
			var nparams:Int = Lua.gettop(l);
			var args:Array<Dynamic> = [];
			// if(functionReferences[l] == null) return 0;

			for (i in 0...nparams) args[i] = fromLua(l, i + 1);
			// var funcID:Int = args.shift();
			// var cbf = functionReferences[l][funcID];
			// trace(l,nparams,args,funcID,cbf);
			if(cbf == null) return 0;


			var ret:Dynamic = null;
			/* return the number of results */

			ret = Reflect.callMethod(null,cbf,args);
			trace(ret);
			if(ret != null){
				toLua(l, ret);
				return 1;
			}
		}catch(e){
			trace('${e}');
			throw(e);
		}
		return 0;

	}

	public static inline function arrayToLua(l:State, arr:Array<Any>) {

		var size:Int = arr.length;
		Lua.createtable(l, size, 0);

		for (i in 0...size) {
			Lua.pushnumber(l, i + 1);
			toLua(l, arr[i]);
			Lua.settable(l, -3);
		}

	}

	static inline function mapToLua(l:State, res:Map<String,Dynamic>) {
		var tLen = 0;
		for(n in res) tLen++;
		Lua.createtable(l, tLen, 0);
		for (index => val in res){
			Lua.pushstring(l, Std.string(index));
			toLua(l, val);
			Lua.settable(l, -3);
		}

	}

	static inline function objectToLua(l:State, res:Any) {
		Lua.createtable(l, Reflect.fields(res).length, 0);
		for (n in Reflect.fields(res)){
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}

	}

	/**
	 * From Lua
	 */
	public static function fromLua(l:State, v:Int):Any {

		var ret:Any = null;
		var luaType = Lua.type(l, v);
		switch(luaType) {
			case Lua.LUA_TNIL:
				ret = null;
			case Lua.LUA_TBOOLEAN:
				ret = Lua.toboolean(l, v);
			case Lua.LUA_TNUMBER:
				ret = Lua.tonumber(l, v);
			case Lua.LUA_TSTRING:
				ret = Lua.tostring(l, v);
			case Lua.LUA_TTABLE:
				ret = toHaxeObj(l, v);
			case Lua.LUA_TFUNCTION: // From https://github.com/DragShot/linc_luajit/
				ret = new LuaCallback(l, LuaL.ref(l, Lua.LUA_REGISTRYINDEX));
			// 	trace("function\n");
			// case Lua.LUA_TUSERDATA:
			// 	ret = LuaL.ref(l, Lua.LUA_REGISTRYINDEX);
			// 	trace("userdata\n");
			// case Lua.LUA_TLIGHTUSERDATA:
			// 	ret = LuaL.ref(l, Lua.LUA_REGISTRYINDEX);
			// 	trace("lightuserdata\n");
			// case Lua.LUA_TTHREAD:
			// 	ret = null;
			// 	trace("thread\n");
			default:
				ret = null;
				if(enableUnsupportedTraces) trace('Return value $v of type $luaType not supported');
		}

		return ret;

	}

	/*static inline function fromLuaTable(l:State):Any {

		var array:Bool = true;
		var ret:Any = null;

		Lua.pushnil(l);
		while(Lua.next(l,-2) != 0) {

			if (Lua.type(l, -2) != Lua.LUA_TNUMBER) {
				array = false;
				Lua.pop(l,2);
				break;
			}

			// check this
			var n:Float = Lua.tonumber(l, -2);
			if(n != Std.int(n)){
				array = false;
				Lua.pop(l,2);
				break;
			}

			Lua.pop(l,1);

		}

		if(array){

			var arr:Array<Any> = [];
			Lua.pushnil(l);
			while(Lua.next(l,-2) != 0) {
				var index:Int = Lua.tointeger(l, -2) - 1; // lua has 1 based indices instead of 0
				arr[index] = fromLua(l, -1); // with holes
				Lua.pop(l,1);
			}
			ret = arr;

		} else {

			var obj:Anon = Anon.create(); // {}
			Lua.pushnil(l);
			while(Lua.next(l,-2) != 0) {
				obj.add(Std.string(fromLua(l, -2)), fromLua(l, -1)); // works with mixed tables
				Lua.pop(l,1);
			}
			ret = obj;

		}

		return ret;

	}

}*/
	static function toHaxeObj(l, i:Int):Any {
		var count = 0;
		var array = true;

		loopTable(l, i, {
			if(array) {
				if(Lua.type(l, -2) != Lua.LUA_TNUMBER) array = false;
				else {
					var index = Lua.tonumber(l, -2);
					if(index < 0 || Std.int(index) != index) array = false;
				}
			}
			count++;
		});

		return
		if(count == 0) {
			{};
		} else if(array) {
			var v = [];
			loopTable(l, i, {
				var index = Std.int(Lua.tonumber(l, -2)) - 1;
				v[index] = fromLua(l, -1);
			});
			cast v;
		} else {
			var v:DynamicAccess<Any> = {};
			loopTable(l, i, {
				switch Lua.type(l, -2) {
					case t if(t == Lua.LUA_TSTRING): v.set(Lua.tostring(l, -2), fromLua(l, -1));
					case t if(t == Lua.LUA_TNUMBER):v.set(Std.string(Lua.tonumber(l, -2)), fromLua(l, -1));
				}
			});
			cast v;
		}
	}
}

// Anon_obj from hxcpp
@:include('hxcpp.h')
@:native('hx::Anon')
extern class Anon {

	@:native('hx::Anon_obj::Create')
	public static function create() : Anon;

	@:native('hx::Anon_obj::Add')
	public function add(k:String, v:Any):Void;

}

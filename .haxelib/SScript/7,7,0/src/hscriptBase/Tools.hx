/*
 * Copyright (C)2008-2017 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package hscriptBase;
import hscriptBase.Expr;

#if macro
import haxe.macro.Context;
import haxe.macro.TypeTools;
#end

using StringTools;

@:access(hscriptBase.Interp)
class Tools {
	static final thisName:String = 'hscriptBase.Tools';

	public static var keys:Array<String> = [
		"import", "package", "if", "var", "for", "while", "final", "do", "as", "using", "break", "continue",
		"public", "private", "static", "overload", "override", "class", "function", "else", "try", "catch",
		"abstract", "case", "switch", "untyped", "cast", "typedef", "dynamic", "default", "enum", "extern",
		"extends", "implements", "in", "macro", "new", "null", "return", "throw", "from", "to", "super", "is"
	];

	public static function ctToType( ct : CType ):String {
		var ctToType:(ct:CType)->String = function(ct)
		{
			return switch (cast(ct, CType)){
				case CTPath(path, params): switch path[0]{
					case 'Null': return ctToType(params[0]);
				} path[0];
				case CTFun(_,_)|CTParent(_):"Function";
				case CTAnon(fields): "Anon";
				default: null;
			}
		};
		return ctToType(ct);
	}

	public static function compatibleWithEachOther(v : Dynamic , v2 : Dynamic):Bool{
		if( Interp.isMap(v) && Interp.isMap(v2) )
			return true;
		if( Interp.isMap(v) && v2 == "Array" )
			return true;
		
		var c = Type.resolveClass(v), c1 = Type.resolveClass(v2);
		if( c!=null && c1!=null )
		{
			var superC = Type.getSuperClass(c);
			if (superC!=null&&c1 == superC)
				return true;
		}
		var chance:Bool = v=="Float"&&v2=="Int";
		var secondChance:Bool = v=="Dynamic"||v2=="null";
		return chance||secondChance;
	}

	public static function compatibleWithEachOtherObjects(v,v2):Bool{
		if(v!=null&&(v is Class)){
			if (v2!=null)
			{
				var cl=Type.resolveClass(v2);
				var superC = Type.getSuperClass(cl), superC2 = Type.getSuperClass(v);
				if(superC!=null&&superC==v)
					return true;
				if(superC2!=null&&superC2==cl)
					return true;
			}
		}
		return false;
	}

	public static function getType( v , ?fn = false) {
		var getType:(s:Dynamic)->String = function(v){
			return switch(Type.typeof(v)) {
				case TNull: "null";
				case TInt: "Int";
				case TFloat: "Float";
				case TBool: "Bool";  
				case TClass(v): var name = Type.getClassName(v);
				if(fn)return name;
				if(name.contains('.'))
				{
					var split = name.split('.');
					name = split[split.length - 1];
				}
				name;
				case TFunction: "Function";
				default: var string = "" + Type.typeof(v) + ""; string.replace("T","");
			}
		};
		return getType(v);
	}

	public static inline function expr( e : Expr ) : ExprDef {
		return if (e == null) null else e.e;
	}
    macro static function build() 
    {
        Context.onGenerate(function(types) 
        {
            var names = [], self = TypeTools.getClass(Context.getType(thisName));
                
            for (t in types)
                switch t 
                {
                    case TInst(_.get() => c, _):
                        var name: Array<String> = c.pack.copy();
                        name.push(c.name);
                        names.push(Context.makeExpr(name.join("."), c.pos));
                    default:
                }

            self.meta.remove('classes');
            self.meta.add('classes', names, self.pos);
        });
        return macro cast haxe.rtti.Meta.getType($p{thisName.split('.')});
    }

    #if !macro
    static final names:Map<String, Class<Dynamic>> = {
        function returnMap()
        {
            var r:Array<String> = build().classes;
            var map = new Map<String, Class<Dynamic>>();

            for (i in r) 
            {
                if (i.indexOf('_Impl_') == -1) // Private class
                {
                    var c = Type.resolveClass(i);
                    if (c != null)
                        map[i] = c;
                }
            }
			
            return map;
        }
        returnMap();
    }
    #end
}

package hscriptBase;

import haxe.Constraints;

class StringFunctionTools 
{
    public static function getStringToolsFunction( func : String ) : Function {
        if( func == null || func.length < 1 )
            return null;

        switch func {
            case 'contains':
                return StringTools.contains;
            case 'htmlEscape':
                return StringTools.htmlEscape;
            case 'htmlUnescape':
                return StringTools.htmlUnescape;
            case 'lpad':
                return StringTools.lpad;
            case 'rpad':
                return StringTools.rpad;
            case 'hex':
                return StringTools.hex;
            case 'unsafeCodeAt':
                return StringTools.unsafeCodeAt;
            case 'iterator':
                return StringTools.iterator;
            case 'keyValueIterator':
                return StringTools.keyValueIterator;
        }

        return Reflect.getProperty(StringTools, func);
    }    
}
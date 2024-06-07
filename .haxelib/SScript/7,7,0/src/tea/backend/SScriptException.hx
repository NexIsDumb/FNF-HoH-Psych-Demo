package tea.backend;

import haxe.Exception;

abstract SScriptException(Exception)
{
    /**
		Exception message.
	**/
    public var message(get, never):String;
    
    public function new(exception:Exception)
        this = exception;
  
    @:from
    public static function fromException(exception:Exception):SScriptException
        return new SScriptException(exception);

    /**
		Returns exception message.
	**/
    @:to
    public function toString():String
        return message;

    /**
		Detailed exception description.

		Includes message, stack and the chain of previous exceptions (if set).
	**/
    public function details():String 
        return this.details();

    function get_message():String 
        return this.message;

    function toException():Exception 
        return this;
}
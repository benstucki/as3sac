package com.benstucki.css.dom
{
	import org.w3c.css.dom.*;
	import org.w3c.css.sac.*;
	import com.benstucki.css.sac.*;

	public class CSSStyleRule extends CSSRule implements ICSSStyleRule
	{
		
		public var selectors:ISelectorList;
		public var declaration:CSSStyleDeclaration = new CSSStyleDeclaration();
		
		public function get style():ICSSStyleDeclaration
		{
			return null;
		}
		
		public function get selectorText():String
		{
			return null;
		}
		
		public function set selectorText(value:String):void
		{
		}
		
		override public function get type():uint {
			return 0;
		}
		
	}
}
package com.benstucki.css.dom
{
	import org.w3c.css.dom.*;
	import org.w3c.css.sac.ISelector;
	import org.w3c.css.sac.ISelectorList;
	import com.benstucki.css.sac.SelectorList;

	public class CSSRule implements ICSSRule
	{
		
		private var _cssText:String;
		private var _parentRule:ICSSRule;
		private var _parentStyleSheet:CSSStyleSheet;
		
		public function get parentRule():ICSSRule {
			return _parentRule;
		}
		
		public function get cssText():String {
			return _cssText;
		}
		
		public function set cssText(value:String):void {
			// todo: clear old css
			_cssText = value;
		}
		
		public function get type():uint {
			return 0;
		}
		
		public function get parentStyleSheet():ICSSStyleSheet {
			return _parentStyleSheet;
		}
		
	}
}
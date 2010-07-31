package com.benstucki.css.dom
{
	import org.w3c.css.dom.*;

	public class CSSRuleList implements ICSSRuleList
	{
		
		private var _items:Array = new Array();
		
		public function get length():uint {
			return _items.length;
		}
		
		public function item(index:uint):ICSSRule {
			return _items[index];
		}
		
		// non standard interface
		
		public function addRuleObject( rule:ICSSRule, index:uint ):uint {
			_items.push(rule);
			return index;
		}
		
	}
}
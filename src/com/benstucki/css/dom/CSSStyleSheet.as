package com.benstucki.css.dom
{
	import org.w3c.css.dom.*;

	public class CSSStyleSheet implements ICSSStyleSheet
	{
		
		private var _cssRules:ICSSRuleList = new CSSRuleList();
		private var _ownerRule:ICSSRule;
		
		public function get ownerRule():ICSSRule {
			return _ownerRule;
		}
		
		public function get cssRules():ICSSRuleList {
			return _cssRules;
		}
		
		public function deleteRule(index:uint):void {
			//_cssRules.
		}
		
		public function insertRule(rule:String, index:uint):uint {
			return 0;
		}
		
		public function get href():String
		{
			return null;
		}
		
		public function get disabled():Boolean
		{
			return false;
		}
		
		public function set disabled(value:Boolean):void
		{
		}
		
		public function get type():String {
			return "text/css";
		}
		
		public function get media():IMediaList
		{
			return null;
		}
		
		public function get title():String
		{
			return null;
		}
		
		public function get ownerNode():String
		{
			return null;
		}
		
		public function get parentStyleSheet():IStyleSheet
		{
			return null;
		}
		
		// non standard interfaces
		public function insertRuleObject( rule:CSSRule, index:uint):uint {
			return CSSRuleList(_cssRules).addRuleObject( rule, index );
		}
	}
}
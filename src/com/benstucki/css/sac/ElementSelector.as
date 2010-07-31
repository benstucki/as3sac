package com.benstucki.css.sac
{
	import org.w3c.css.sac.IElementSelector;
	import org.w3c.css.sac.SelectorTypes;

	public class ElementSelector implements IElementSelector
	{
		private var _namespaceURI:String;
		private var _tagName:String;
		
		public function ElementSelector(namespaceURI:String, tagName:String) {
			_namespaceURI = namespaceURI;
			_tagName = tagName;
		}
		
		public function get namespaceURI():String {
			return _namespaceURI;
		}
		
		public function get localName():String {
			return _tagName;
		}
		
		public function get selectorType():uint {
			return SelectorTypes.SAC_ELEMENT_NODE_SELECTOR;
		}
		
	}
}
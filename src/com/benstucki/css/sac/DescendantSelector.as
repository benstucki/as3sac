package com.benstucki.css.sac {
	
	import org.w3c.css.sac.IDescendantSelector;
	import org.w3c.css.sac.ISelector;
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.SelectorTypes;
	
	public class DescendantSelector implements IDescendantSelector {
		
		private var _par:ISelector;
		private var _descendant:ISimpleSelector;
		private var _isChildSelector:Boolean=false;
		
		public function DescendantSelector(parent:ISelector, descendant:ISimpleSelector, isChildSelector:Boolean=false):void {
			_par = parent;
			_descendant = descendant;
			_isChildSelector = isChildSelector;
		}
		
		public function get ancestorSelector():ISelector {
			return _par;
		}
		
		public function get simpleSelector():ISimpleSelector {
			return _descendant;
		}
		
		public function get selectorType():uint {
			return _isChildSelector ? SelectorTypes.SAC_CHILD_SELECTOR : SelectorTypes.SAC_DESCENDANT_SELECTOR;
		}
		
	}
}
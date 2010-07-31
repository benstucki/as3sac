package com.benstucki.css.sac
{
	import org.w3c.css.sac.ISiblingSelector;
	import org.w3c.css.sac.ISelector;
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.SelectorTypes;

	public class SiblingSelector implements ISiblingSelector
	{
		public static const ANY_NODE:uint = 0;
		
		private var _nodeType:uint;
		private var _child:ISelector;
		private var _directAdjacent:ISimpleSelector;
		
		public function SiblingSelector( nodeType:uint, child:ISelector, directAdjacent:ISimpleSelector ):void {
			_nodeType = nodeType;
			_child = child;
			_directAdjacent = directAdjacent;
		}
		
		public function get nodeType():uint { return _nodeType; }
		public function get selector():ISelector { return _child; }
		public function get siblingSelector():ISimpleSelector { return _directAdjacent; }
		
		public function get selectorType():uint {
			return SelectorTypes.SAC_DIRECT_ADJACENT_SELECTOR;
		}
		
	}
}
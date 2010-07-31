package com.benstucki.css.sac
{
	import org.w3c.css.sac.IConditionalSelector;
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.ICondition;
	import org.w3c.css.sac.SelectorTypes;

	public class ConditionalSelector implements IConditionalSelector
	{
		private var _selector:ISimpleSelector;
		private var _condition:ICondition;
		
		public function ConditionalSelector(selector:ISimpleSelector, condition:ICondition):void {
			_selector = selector;
			_condition = condition;
		}
		public function get simpleSelector():ISimpleSelector {
			return _selector;
		}
		
		public function get condition():ICondition {
			return _condition;
		}
		
		public function get selectorType():uint {
			return SelectorTypes.SAC_CONDITIONAL_SELECTOR;
		}
		
	}
}
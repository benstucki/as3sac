package com.benstucki.css.sac
{
	import org.w3c.css.sac.INegativeSelector;
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.SelectorTypes;

	public class NegativeSelector implements INegativeSelector
	{

		private var _selector:ISimpleSelector;

		public function NegativeSelector( selector:ISimpleSelector ):void {
			_selector = selector;
		}

		public function get simpleSelector():ISimpleSelector { return _selector; }

		public function get selectorType():uint { return SelectorTypes.SAC_NEGATIVE_SELECTOR; }

	}
}
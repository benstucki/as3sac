package com.benstucki.css.sac
{
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.SelectorTypes;

	public class SimpleSelector implements ISimpleSelector
	{
		
		public function get selectorType( ):uint {
			return SelectorTypes.SAC_ANY_NODE_SELECTOR;
		}
		
	}
}
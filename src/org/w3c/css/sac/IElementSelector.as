package org.w3c.css.sac
{
	// http://www.w3.org/Style/CSS/SAC/doc/org/w3c/css/sac/ElementSelector.html
	/**
	 * @see SelectorTypes#SAC_ELEMENT_NODE_SELECTOR
	 */
	public interface IElementSelector extends ISimpleSelector
	{
		/**
		 * Returns the local part of the qualified name of this element.
		 * <p>Null if this element selector can match any element.</p>
		 */
		function get localName():String;

		/**
		 * Returns the namespace URI of this element selector.
		 * <p>Null if this element selector can match any namespace.</p>
		 */
		function get namespaceURI():String;
	}
}
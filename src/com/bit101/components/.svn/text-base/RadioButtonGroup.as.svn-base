package com.bit101.components 
{
	import com.bit101.components.RadioButton;
	
	public class RadioButtonGroup 
	{
		public var buttons:Array;
		
		public function RadioButtonGroup() 
		{
			buttons = new Array();
		}
		
		public function addButton(rb:RadioButton):void
		{
			buttons.push(rb);
		}
		
		public function clear(rb:RadioButton):void
		{
			for(var i:uint = 0; i < buttons.length; i++)
			{
				if(buttons[i] != rb)
				{
					buttons[i].selected = false;
				}
			}
		}
		
	}
	
}
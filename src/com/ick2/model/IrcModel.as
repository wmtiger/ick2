package com.ick2.model 
{
	import com.ick2.vo.IrcVO;
	/**
	 * ...
	 * @author wmtiger
	 */
	public class IrcModel 
	{
		private static var _instance:IrcModel;
		
		private var _irc:IrcVO;
		
		public function IrcModel() 
		{
			
		}
		
		static public function get instance():IrcModel 
		{
			if (_instance == null) 
			{
				_instance = new IrcModel();
			}
			return _instance;
		}
		
		private function dealIrc(data:Object):IrcVO
		{
			//to do:fix this func
			return IrcVO(data);
		}
		public function setIrc(data:Object):void
		{
			_irc = dealIrc(data);
		}
		
	}

}
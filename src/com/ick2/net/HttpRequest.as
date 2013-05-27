package com.ick2.net
{
	import flash.events.Event;
	import flash.net.URLLoader;

	public class HttpRequest
	{
		/**
		 * 具体请求方法
		 */ 
		public var action:String;
		/**
		 * 回调方法
		 */ 
		public var callback:Function;
		/**
		 * 数据
		 */ 
		public var data:*;
		public function HttpRequest()
		{
		}
		public function onResponse(e:Event):void
		{
			var serviceID:String = action;
			var service:URLLoader = HttpService.instance.getService(serviceID);
			service.removeEventListener(Event.COMPLETE, onResponse);
			var s:String = "";
			try 
			{
				s = e.target.data + "";
				var idx:int = s.indexOf("{");
				s = s.substr(idx);
				var obj:Object = JSON.parse(s);
			}
			catch (err:Error)
			{
				
			}
			//Log.info("req:" + s);
			if (callback != null)
			{
				callback.call(null, obj);
			}
		}
	}
}
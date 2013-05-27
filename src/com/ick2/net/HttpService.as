package com.ick2.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class HttpService
	{
		/**
		 * 用于存储URLLoader对象
		 * 一个action对应一个URLLoader对象
		 */ 
		private var services:Dictionary;
		/**
		 * 服务请求根路径
		 */ 
		private var serviceRoot:String;
		private var separator:String;
		private static var _instance:HttpService;
		
		public function HttpService(lock:HttpServiceLock)
		{
			if(!lock)
			{
				throw(new Error("单例出错!"));
			}
			services = new Dictionary();
		}
		public static function get instance():HttpService
		{
			if(_instance==null)
			{
				_instance = new HttpService(new HttpServiceLock());
			}
			return _instance;
		}
		/**
		 * 初始化
		 */ 
		public function init(serRoot:String = "",separ:String = ""):void
		{
			serviceRoot = serRoot;
			separator = separ;
		}
		/**
		 * 获取根地址
		 * @return
		 */
		public function getRoot():String
		{
			return serviceRoot;
		}
		/**
		 * 发送请求
		 */ 
		public function sendRequest(req:HttpRequest):void
		{
			var serviceID:String = req.action;
			var service:URLLoader = getService(serviceID);
			service.addEventListener(Event.COMPLETE, req.onResponse);
			var url:String = req.action + "";
			//Log.info(this, "[url]=>"+ url);
			var urlReq:URLRequest = new URLRequest(url);
			urlReq.method = URLRequestMethod.POST;
			if (req.data != null)
			{
				var p:URLVariables = new URLVariables();
				var n:String;
				for(n in req.data)
				{
					p[n] = req.data[n];
				}
				urlReq.data = p;
			}
			service.load(urlReq);
		}
		
		/**
		 * 发送请求数据
		 * @param	url
		 * @param	okFun
		 * @param	okParam
		 * @param	obj
		 * @param	noFun
		 */
		public function sendReqInfo(actionUrl:String, okFun:Function = null, okParam:Boolean = true, 
				obj:Object = null, noFun:Function = null):void
		{
			var req:HttpRequest = new HttpRequest();
			req.action = actionUrl;
			req.data = obj;
			req.callback = function (o:Object):void 
			{
				//Log.info(req.action + "->obj.status:" + o.status);
				if (o.status + "" == "200") 
				{
					if (okFun != null) 
					{
						if (okParam) 
						{
							okFun(o);
						}
						else
						{
							okFun();
						}
					}
				}
				else
				{
					//Log.error("status:" + o.status);
					if (noFun != null) 
					{
						noFun(o);
					}
				}
			}
			HttpService.instance.sendRequest(req);
		}
		
		/**
		 * 获取服务
		 */ 
		public function getService(id:String):URLLoader
		{
			var service:URLLoader = services[id];
			if(service==null)
			{
				service = new URLLoader();
				//service.dataFormat = URLLoaderDataFormat.VARIABLES;
				service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFail);
				service.addEventListener(IOErrorEvent.IO_ERROR, onFail);
				services[id] = service;
			}
			return service;
		}
		/**
		 * 请求失败
		 */ 
		private function onFail(e:Event):void
		{
			//Log.info(e);
		}
	}
}
class HttpServiceLock
{
	
}
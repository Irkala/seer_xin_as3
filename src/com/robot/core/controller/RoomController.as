package com.robot.core.controller
{
   import com.robot.core.CommandID;
   import com.robot.core.ErrorReport;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.StringUtil;
   
   [Event(name="getRoomAddres",type="com.robot.core.event.RobotEvent")]
   [Event(name="enterRoom",type="com.robot.core.event.RobotEvent")]
   [Event(name="leaveRoom",type="com.robot.core.event.RobotEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="connect",type="flash.events.Event")]
   public class RoomController extends EventDispatcher
   {
      public static var isClose:Boolean = false;
      
      private var _id:uint;
      
      private var _isConnect:Boolean;
      
      private var _isIlk:Boolean = false;
      
      private var _session:ByteArray;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function RoomController()
      {
         super();
      }
      
      public function get isConnect() : Boolean
      {
         return this._isConnect;
      }
      
      public function get isIlk() : Boolean
      {
         return this._isIlk;
      }
      
      public function getRoomAddres(id:uint) : void
      {
         this._id = id;
         SocketConnection.addCmdListener(CommandID.GET_ROOM_ADDRES,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_ROOM_ADDRES,arguments.callee);
            var data:ByteArray = e.data as ByteArray;
            _session = new ByteArray();
            data.readBytes(_session,0,24);
            _ip = StringUtil.hexToIp(data.readUnsignedInt());
            _port = data.readUnsignedShort();
            trace("小屋服务器地址：",_ip + ":" + _port);
            if(SocketConnection.roomSocket.ip == _ip && SocketConnection.roomSocket.port == _port)
            {
               _isIlk = true;
            }
            else
            {
               _isIlk = false;
            }
            dispatchEvent(new RobotEvent(RobotEvent.GET_ROOM_ADDRES));
         });
         SocketConnection.mainSocket.send(CommandID.GET_ROOM_ADDRES,[this._id]);
      }
      
      public function connect() : void
      {
         if(this._isIlk)
         {
            dispatchEvent(new Event(Event.CONNECT));
         }
         SocketConnection.roomSocket.session = this._session;
         SocketConnection.roomSocket.userID = MainManager.actorID;
         SocketConnection.roomSocket.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         SocketConnection.roomSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         SocketConnection.roomSocket.addEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.roomSocket.addEventListener(Event.CLOSE,this.onClose);
         SocketConnection.roomSocket.connect(this._ip,this._port);
      }
      
      public function inRoom(type:uint, x:uint, y:uint) : void
      {
         var catchTime:uint = 0;
         if(Boolean(PetManager.showInfo))
         {
            catchTime = PetManager.showInfo.catchTime;
         }
         SocketConnection.send(CommandID.ROOM_LOGIN,SocketConnection.roomSocket.session,catchTime,type,this._id,x,y);
      }
      
      public function outRoom(mapID:uint) : void
      {
         var catchTime:uint = 0;
         if(Boolean(PetManager.showInfo))
         {
            catchTime = PetManager.showInfo.catchTime;
         }
         SocketConnection.addCmdListener(CommandID.LEAVE_ROOM,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.LEAVE_ROOM,arguments.callee);
            close();
         });
         SocketConnection.mainSocket.send(CommandID.LEAVE_ROOM,[1,mapID,catchTime,MainManager.actorInfo.changeShape,MainManager.actorInfo.actionType]);
      }
      
      public function close() : void
      {
         if(this._isConnect)
         {
            SocketConnection.roomSocket.close();
            this._isConnect = false;
            dispatchEvent(new RobotEvent(RobotEvent.LEAVE_ROOM));
         }
      }
      
      private function onConnect(e:Event) : void
      {
         trace("连接小屋成功 [" + SocketConnection.roomSocket.ip + ":" + SocketConnection.roomSocket.port + "]");
         SocketConnection.roomSocket.removeEventListener(Event.CONNECT,this.onConnect);
         this._isConnect = true;
         SocketConnection.roomSocket.ip = this._ip;
         SocketConnection.roomSocket.port = this._port;
         dispatchEvent(e);
      }
      
      private function onClose(e:Event) : void
      {
         trace("room socket close");
         SocketConnection.roomSocket.removeEventListener(Event.CLOSE,this.onClose);
         this._isConnect = false;
         SocketConnection.roomSocket.close();
         isClose = true;
         MapManager.changeMap(MapManager.defaultID);
      }
      
      private function onError(e:Event) : void
      {
         trace("room IO_ERROR");
         SocketConnection.roomSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         SocketConnection.roomSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         trace("room SECURITY_ERROR");
         ErrorReport.sendError(ErrorReport.LOGIN_HOME_ONLINE_ERROR);
         SocketConnection.roomSocket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         SocketConnection.roomSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }
}


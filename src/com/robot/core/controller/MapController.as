package com.robot.core.controller
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.ArmEvent;
   import com.robot.core.event.FitmentEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.HeadquarterManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.map.MapTransEffect;
   import com.robot.core.manager.map.MapType;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.manager.map.config.MapProcessConfig;
   import com.robot.core.mode.MapModel;
   import com.robot.core.mode.PeopleModel;
   import com.robot.core.net.ConnectionType;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamInstallation.ShowTeamLogo;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.teamPK.shotActive.PKInteractiveAction;
   import com.robot.core.utils.Direction;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.algo.AStar;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapController
   {
      private static var _isReMap:Boolean = false;
      
      private static var _isChange:Boolean = false;
      
      private static var _isLogin:Boolean = true;
      
      private static var _isSwitching:Boolean = false;
      
      private var _mapModel:MapModel;
      
      private var _newMapID:uint;
      
      private var _dir:int = 0;
      
      private var _roomCol:RoomController;
      
      private var _isShowLoading:Boolean = true;
      
      private var _mapType:uint;
      
      private var _tempStyleID:uint;
      
      public var isChangeLocal:Boolean = false;
      
      public function MapController()
      {
         super();
      }
      
      public static function get isReMap() : Boolean
      {
         return _isReMap;
      }
      
      public function get newMapID() : uint
      {
         return this._newMapID;
      }
      
      public function changeLocalMap(mapID:uint, dir:uint = 0) : void
      {
         this.isChangeLocal = true;
         this._dir = dir;
         this._newMapID = mapID;
         this._mapType = 0;
         this._tempStyleID = 0;
         _isChange = true;
         _isReMap = false;
         this.startSwitch();
      }
      
      public function closeChange() : void
      {
         this._mapModel.closeChange();
      }
      
      public function changeMap(mapID:uint, dir:int = 0, mapType:uint = 0) : void
      {
         this.isChangeLocal = false;
         if(_isSwitching)
         {
            return;
         }
         if(!_isLogin)
         {
            if(mapID == MainManager.actorInfo.mapID || mapID == this._newMapID)
            {
               if(mapType == MapManager.type || mapType == this._mapType)
               {
                  if(mapType <= MapManager.TYPE_MAX && mapID != MapManager.TOWER_MAP && mapID != MapManager.FRESH_TRIALS)
                  {
                     return;
                  }
               }
            }
            MouseController.removeMouseEvent();
         }
         this._dir = dir;
         this._newMapID = mapID;
         this._mapType = mapType;
         this._tempStyleID = MapManager.styleID;
         _isChange = true;
         _isReMap = false;
         this.startSwitch();
      }
      
      public function refMap(isShowLoading:Boolean = true) : void
      {
         if(_isSwitching)
         {
            return;
         }
         this._isShowLoading = isShowLoading;
         _isChange = true;
         _isReMap = true;
         this.startSwitch();
      }
      
      public function destroy() : void
      {
         MapManager.isInMap = false;
         MainManager.actorModel.stop();
         MainManager.actorModel.aimatStateManager.clear();
         MapConfig.clear();
         MapProcessConfig.destroy();
         if(Boolean(MapManager.currentMap))
         {
            MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_DESTROY,MapManager.currentMap));
            MapManager.currentMap.destroy();
            MapManager.currentMap = null;
         }
      }
      
      private function startSwitch() : void
      {
         _isSwitching = true;
         LevelManager.closeMouseEvent();
         if(this._newMapID > MapManager.ID_MAX)
         {
            switch(this._mapType)
            {
               case MapType.HOOM:
                  FitmentManager.addEventListener(FitmentEvent.USED_LIST,function(e:FitmentEvent):void
                  {
                     FitmentManager.removeEventListener(FitmentEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  FitmentManager.getUsedInfo(this._newMapID);
                  break;
               case MapType.CAMP:
                  ArmManager.addEventListener(ArmEvent.USED_LIST,function(e:ArmEvent):void
                  {
                     ArmManager.removeEventListener(ArmEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  ArmManager.getUsedInfoForServer(this._newMapID);
                  break;
               case MapType.HEAD:
                  HeadquarterManager.addEventListener(FitmentEvent.USED_LIST,function(e:FitmentEvent):void
                  {
                     HeadquarterManager.removeEventListener(FitmentEvent.USED_LIST,arguments.callee);
                     _startSwitch(MapManager.styleID);
                  });
                  HeadquarterManager.getUsedInfo(this._newMapID);
                  break;
               default:
                  this._startSwitch();
            }
         }
         else
         {
            this._startSwitch();
         }
      }
      
      private function _startSwitch(styleID:uint = 0) : void
      {
         MapManager.addEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.addEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.addEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         this._mapModel = new MapModel(this._newMapID,!_isLogin,this._isShowLoading);
         MapManager.initPos = MapConfig.getMapPeopleXY(MainManager.actorInfo.mapID,this._newMapID);
         ResourceManager.stop();
      }
      
      private function comeInMap() : void
      {
         MainManager.actorModel.showClothLight(true);
         if(this._newMapID == MapManager.FRESH_TRIALS || this._newMapID == MapManager.TOWER_MAP || this.isChangeLocal)
         {
            this.initMapFunction(false);
            return;
         }
         if(this._newMapID < MapManager.ID_MAX)
         {
            MapManager.type = ConnectionType.MAIN;
            if(MainManager.actorInfo.mapID > MapManager.ID_MAX)
            {
               this._roomCol.addEventListener(RobotEvent.LEAVE_ROOM,this.onRoomLeave);
               this._roomCol.outRoom(this._newMapID);
            }
            else
            {
               SocketConnection.send(CommandID.ENTER_MAP,this._mapType,this._newMapID,MapManager.initPos.x,MapManager.initPos.y);
            }
         }
         else
         {
            MapManager.type = ConnectionType.ROOM;
            if(MainManager.actorInfo.mapID > MapManager.ID_MAX)
            {
               if(this._roomCol.isIlk)
               {
                  SocketConnection.send(CommandID.ENTER_MAP,this._mapType,this._newMapID,MapManager.initPos.x,MapManager.initPos.y);
               }
               else
               {
                  this._roomCol.addEventListener(RobotEvent.LEAVE_ROOM,this.onRoomLeave);
                  this._roomCol.close();
               }
            }
            else
            {
               this._roomCol.addEventListener(Event.CONNECT,this.onRoomConnect);
               this._roomCol.addEventListener(ErrorEvent.ERROR,this.onRoomError);
               this._roomCol.connect();
            }
         }
      }
      
      private function initMapFunction(isGetUser:Boolean = true) : void
      {
         var mte:MapTransEffect;
         var pinfo:PetShowInfo = null;
         MapManager.removeEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         LevelManager.openMouseEvent();
         ResourceManager.play();
         mte = new MapTransEffect(this._mapModel,this._dir);
         mte.addEventListener(MapEvent.MAP_EFFECT_COMPLETE,function(e:MapEvent):void
         {
            DisplayUtil.removeAllChild(LevelManager.appLevel);
            DisplayUtil.removeAllChild(LevelManager.mapLevel);
            LevelManager.mapLevel.addChild(_mapModel.root);
         });
         mte.star();
         this.destroy();
         MapManager.isInMap = true;
         LevelManager.mapScroll = false;
         MapManager.prevMapID = MainManager.actorInfo.mapID;
         MainManager.actorInfo.mapType = this._mapType;
         MainManager.actorInfo.mapID = this._newMapID;
         MapManager.currentMap = this._mapModel;
         AStar.init(MapManager.currentMap,1500);
         MapConfig.configMap(MapManager.getResMapID(this._newMapID));
         MapManager.currentMap.depthLevel.addChild(MainManager.actorModel.sprite);
         if(!_isReMap)
         {
            MainManager.actorModel.pos = MapManager.initPos;
         }
         MapProcessConfig.configMap(MapManager.getResMapID(this._newMapID),this._mapType);
         MainManager.actorModel.direction = Direction.DOWN;
         if(Boolean(PetManager.showInfo))
         {
            pinfo = new PetShowInfo();
            pinfo.catchTime = PetManager.showInfo.catchTime;
            pinfo.petID = PetManager.showInfo.id;
            pinfo.userID = MainManager.actorID;
            MainManager.actorModel.showPet(pinfo);
         }
         DepthManager.swapDepthAll(MapManager.currentMap.depthLevel);
         MouseController.addMouseEvent();
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_SWITCH_COMPLETE,MapManager.currentMap));
         this._mapModel.closeLoading();
         _isSwitching = false;
         if(MapManager.currentMap.width > MainManager.getStageWidth())
         {
            LevelManager.mapScroll = true;
         }
         if(isGetUser && this._newMapID != 515)
         {
            SocketConnection.send(CommandID.LIST_MAP_PLAYER);
         }
         MainManager.actorModel.showClothLight();
      }
      
      private function onLeaveMap(e:SocketEvent) : void
      {
         var by:ByteArray = e.data as ByteArray;
         by.position = 0;
         var userID:uint = by.readUnsignedInt();
         if(this.isChangeLocal)
         {
            return;
         }
         if(userID == MainManager.actorID)
         {
            if(_isChange)
            {
               _isChange = false;
               this.comeInMap();
            }
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            MapManager.currentMap.removeUser(userID);
         }
         MainManager.actorModel.delProtectMC();
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
      
      private function onEnterMap(e:SocketEvent) : void
      {
         var user:PeopleModel = null;
         if(this._newMapID == MapManager.TOWER_MAP)
         {
            MapManager.changeMap(108);
            return;
         }
         if(this._newMapID == MapManager.FRESH_TRIALS)
         {
            MapManager.changeMap(101);
            return;
         }
         if(this.isChangeLocal)
         {
            return;
         }
         var info:UserInfo = new UserInfo();
         UserInfo.setForPeoleInfo(info,e.data as IDataInput);
         info.serverID = MainManager.serverID;
         if(info.userID == MainManager.actorID)
         {
            if(_isReMap)
            {
               MainManager.actorModel.pos = info.pos;
            }
            MainManager.upDateForPeoleInfo(info);
            this.initMapFunction();
         }
         else
         {
            if(MapManager.currentMap == null)
            {
               return;
            }
            user = new PeopleModel(info);
            if(info.actionType == 0)
            {
               user.walk = new WalkAction();
            }
            else
            {
               user.walk = new FlyAction(user);
            }
            if(MainManager.actorInfo.mapType == MapType.PK_TYPE)
            {
               if(info.teamInfo.id != MainManager.actorInfo.mapID)
               {
                  user.x = info.pos.x + TeamPKManager.REDX;
                  user.additiveInfo.info = TeamPKManager.AWAY;
               }
               else
               {
                  user.additiveInfo.info = TeamPKManager.HOME;
               }
               user.interactiveAction = new PKInteractiveAction(user);
            }
            MapManager.currentMap.addUser(user);
            if(info.teamInfo.isShow)
            {
               ShowTeamLogo.showLogo(user);
            }
         }
         MainManager.actorModel.delProtectMC();
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
      
      private function onMapInit(e:Event) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.removeEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_SWITCH_OPEN,MapManager.currentMap));
         if(_isLogin)
         {
            _isLogin = false;
            this.initMapFunction();
            SocketConnection.addCmdListener(CommandID.ENTER_MAP,this.onEnterMap);
            SocketConnection.addCmdListener(CommandID.LEAVE_MAP,this.onLeaveMap);
            SocketConnection.addCmdListener(CommandID.ON_MAP_SWITCH,this.onMapOnSwitch);
         }
         else if(MapManager.isInMap)
         {
            if(this._newMapID > MapManager.ID_MAX)
            {
               if(this._roomCol == null)
               {
                  this._roomCol = new RoomController();
               }
               this._roomCol.addEventListener(RobotEvent.GET_ROOM_ADDRES,this.onRoomAddres);
               this._roomCol.getRoomAddres(this._newMapID);
            }
            else if(RoomController.isClose)
            {
               RoomController.isClose = false;
               this.comeInMap();
            }
            else
            {
               if(this._newMapID == MapManager.FRESH_TRIALS || this._newMapID == MapManager.TOWER_MAP || this.isChangeLocal)
               {
                  this.comeInMap();
                  return;
               }
               SocketConnection.send(CommandID.LEAVE_MAP);
            }
         }
         else
         {
            this.initMapFunction(this._newMapID != 500);
         }
      }
      
      private function onMapOnSwitch(e:SocketEvent) : void
      {
         if(Boolean(this._mapModel))
         {
            this.onMapFail(null);
         }
      }
      
      private function onMapFail(e:Event) : void
      {
         this._mapModel.closeLoading();
         this._mapType = MainManager.actorInfo.mapType;
         this._newMapID = MainManager.actorInfo.mapID;
         MapManager.styleID = this._tempStyleID;
         LevelManager.openMouseEvent();
         MapManager.removeEventListener(MapEvent.MAP_INIT,this.onMapInit);
         MapManager.removeEventListener(ErrorEvent.ERROR,this.onMapFail);
         MapManager.removeEventListener(MapEvent.MAP_LOADER_CLOSE,this.onMapFail);
         MouseController.addMouseEvent();
         _isSwitching = false;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_ERROR));
      }
      
      private function onRoomAddres(e:RobotEvent) : void
      {
         this._roomCol.removeEventListener(RobotEvent.GET_ROOM_ADDRES,this.onRoomAddres);
         SocketConnection.send(CommandID.LEAVE_MAP);
      }
      
      private function onRoomConnect(e:Event) : void
      {
         this._roomCol.removeEventListener(Event.CONNECT,this.onRoomConnect);
         this._roomCol.inRoom(this._mapType,MapManager.initPos.x,MapManager.initPos.y);
      }
      
      private function onRoomLeave(e:RobotEvent) : void
      {
         if(MapManager.type == ConnectionType.ROOM)
         {
            this._roomCol.addEventListener(Event.CONNECT,this.onRoomConnect);
            this._roomCol.connect();
         }
      }
      
      private function onRoomError(e:ErrorEvent) : void
      {
         this._roomCol.removeEventListener(Event.CONNECT,this.onRoomConnect);
         this._roomCol.removeEventListener(ErrorEvent.ERROR,this.onRoomError);
         if(Boolean(this._mapModel))
         {
            this._mapModel.closeLoading();
         }
         MapManager.styleID = this._tempStyleID;
         this._mapType = MainManager.actorInfo.mapType;
         this._newMapID = MainManager.actorInfo.mapID;
         _isReMap = true;
         RoomController.isClose = true;
         this.startSwitch();
      }
   }
}


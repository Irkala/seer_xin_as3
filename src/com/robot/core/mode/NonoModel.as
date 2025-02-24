package com.robot.core.mode
{
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.MachXMLInfo;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.ui.nono.NonoInfoPanelController;
   import com.robot.core.ui.nono.NonoShortcut;
   import com.robot.core.utils.Direction;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.GeomUtil;
   import org.taomee.utils.MathUtil;
   
   public class NonoModel extends BobyModel implements INonoModel
   {
      public static const MAX:int = 30;
      
      private static const ClaName:Array = ["pet","sou"];
      
      private static const SCALE:Number = 0.8;
      
      private var _people:ActionSpriteModel;
      
      private var _info:NonoInfo;
      
      private var _actionID:uint;
      
      private var _expID:uint;
      
      private var _expList:Array;
      
      private var _linesList:Array;
      
      private var _expTimeID:uint;
      
      private var _bodyMC:Sprite;
      
      private var _bodyUpColorMC:MovieClip;
      
      private var _bodyDownColorMC:MovieClip;
      
      private var _bodyChildMC:MovieClip;
      
      private var _bodyFootMC:MovieClip;
      
      private var _bodyFootMC2:MovieClip;
      
      private var _expMC:MovieClip;
      
      private var _actionMC:MovieClip;
      
      private var _sound:Sound;
      
      private var _sc:SoundChannel;
      
      private var _dirPos:Point = new Point();
      
      private var _dirSpeed:Point = new Point();
      
      private var _followTimeID:uint;
      
      private var _resPath:String = "";
      
      private var _fly:FlyAction;
      
      private var _enterCount:int;
      
      private var _nullPos:Point = new Point();
      
      private var _bodyRect:Rectangle;
      
      private var _matriix:Matrix = new Matrix();
      
      private var _bmd:BitmapData;
      
      private var _bmp:Bitmap;
      
      public function NonoModel(info:NonoInfo, people:ActionSpriteModel = null)
      {
         super();
         _speed = 3;
         this._info = info;
         this.buttonMode = true;
         if(this._info.superNono)
         {
            this._resPath = "super/";
         }
         if(Boolean(people))
         {
            this._people = people;
            this._people.addChild(this);
            this.moveForPeople(false);
         }
         this._expList = MachXMLInfo.getExpID();
         if(this._info.superNono)
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "nono" + "_" + this._info.superStage),this.onResLoad,"pet");
         }
         else
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "nono"),this.onResLoad,"pet");
         }
         this.addEvent();
      }
      
      override public function destroy() : void
      {
         this.removeEvent();
         clearTimeout(this._expTimeID);
         clearTimeout(this._followTimeID);
         super.destroy();
         this.clearActionMC();
         this._dirPos = null;
         this._dirSpeed = null;
         this._bodyUpColorMC = null;
         this._bodyDownColorMC = null;
         this._bodyChildMC = null;
         this._bodyFootMC = null;
         this._bodyMC = null;
         DisplayUtil.removeForParent(this);
      }
      
      override public function set visible(b1:Boolean) : void
      {
         this.visible = b1;
      }
      
      public function set people(o:ActionSpriteModel) : void
      {
         this._people = o;
         if(Boolean(this._people))
         {
            this.stopAutoTime();
            this.setGear();
            y = -22;
            this._people.addChild(this);
            this.moveForPeople(false);
         }
         else
         {
            this.startAutoTime();
         }
      }
      
      public function get people() : ActionSpriteModel
      {
         return this._people;
      }
      
      public function get info() : NonoInfo
      {
         return this._info;
      }
      
      override public function set direction(dir:String) : void
      {
         if(dir == null || dir == "")
         {
            return;
         }
         _direction = dir;
         this.changedir();
      }
      
      override public function get centerPoint() : Point
      {
         _centerPoint.x = x;
         _centerPoint.y = y - 22;
         return _centerPoint;
      }
      
      override public function get hitRect() : Rectangle
      {
         _hitRect.x = x - width / 2;
         _hitRect.y = y - height;
         _hitRect.width = width;
         _hitRect.height = height;
         return _hitRect;
      }
      
      private function addEvent() : void
      {
         if(this._info.userID == MainManager.actorID)
         {
            addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         }
         else
         {
            addEventListener(MouseEvent.CLICK,this.onClick);
         }
         EventManager.addEventListener(RobotEvent.NONO_SHORTCUT_HIDE,this.onShortcutHide);
         NonoManager.addActionListener(this._info.userID,this.onNonoEvent);
         if(Boolean(this._people))
         {
            this._people.addEventListener(RobotEvent.CHANGE_DIRECTION,this.onPeopleDir);
            this._people.addEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
            this._people.addEventListener(RobotEvent.WALK_END,this.onPeopleWalkEnd);
            if(this._info.superNono)
            {
               this._people.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
            }
         }
         else
         {
            addEventListener(RobotEvent.WALK_START,this.onWalkStart);
            addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onMoveDir);
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         EventManager.removeEventListener(RobotEvent.NONO_SHORTCUT_HIDE,this.onShortcutHide);
         NonoManager.removeActionListener(this._info.userID,this.onNonoEvent);
         if(Boolean(this._people))
         {
            this._people.removeEventListener(RobotEvent.CHANGE_DIRECTION,this.onPeopleDir);
            this._people.removeEventListener(RobotEvent.WALK_START,this.onPeopleWalkStart);
            this._people.removeEventListener(RobotEvent.WALK_END,this.onPeopleWalkEnd);
            if(this._info.superNono)
            {
               this._people.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onPeopleWalkEnter);
            }
         }
         else
         {
            removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
            removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         }
      }
      
      private function initCheck() : void
      {
         if(this._info.chargeTime != 0)
         {
            this._actionID = 1;
            this.getActionRes();
            return;
         }
         if(!this._info.state[0] || this._info.power == 0)
         {
            this.setClose();
            return;
         }
         this.startAutoTime();
      }
      
      private function onResLoad(o:DisplayObject) : void
      {
         this._bodyMC = o as Sprite;
         this._bodyMC.scaleX = SCALE;
         this._bodyMC.scaleY = SCALE;
         this._bodyMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function():void
         {
            _bodyMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
            _bodyUpColorMC = _bodyMC.getChildByName("color_1") as MovieClip;
            if(Boolean(_bodyUpColorMC))
            {
               DisplayUtil.FillColor(_bodyUpColorMC,_info.color);
               _bodyUpColorMC.gotoAndStop(direction);
            }
            _bodyDownColorMC = _bodyMC.getChildByName("color_2") as MovieClip;
            if(Boolean(_bodyDownColorMC))
            {
               DisplayUtil.FillColor(_bodyDownColorMC,_info.color);
               _bodyDownColorMC.gotoAndStop(direction);
            }
            _bodyChildMC = _bodyMC.getChildByName("body") as MovieClip;
            _bodyChildMC.gotoAndStop(direction);
            _bodyFootMC = _bodyMC.getChildByName("foot") as MovieClip;
            if(Boolean(_bodyFootMC))
            {
               _bodyFootMC.gotoAndStop(direction);
            }
            _bodyFootMC2 = _bodyMC.getChildByName("foot_2") as MovieClip;
            if(Boolean(_bodyFootMC2))
            {
               _bodyFootMC2.gotoAndStop(direction);
            }
         });
         addChild(this._bodyMC);
         if(this._people == null)
         {
            this.initCheck();
         }
         else
         {
            this.onPeopleWalkEnd();
         }
      }
      
      private function startAutoTime() : void
      {
         if(this._actionID == 0)
         {
            if(this._info.power > 0 && Boolean(this._info.state[0]))
            {
               this._expTimeID = setTimeout(this.onExpTime,MathUtil.randomHalve(20000));
               starAutoWalk(3000);
            }
         }
      }
      
      private function stopAutoTime() : void
      {
         clearTimeout(this._expTimeID);
         stopAutoWalk();
         this.changedir();
      }
      
      private function clearActionMC() : void
      {
         if(Boolean(this._actionMC))
         {
            this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,null);
            DisplayUtil.removeForParent(this._actionMC);
            this._actionMC = null;
         }
         if(Boolean(this._expMC))
         {
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,null);
            DisplayUtil.removeForParent(this._expMC);
            this._expMC = null;
         }
         if(Boolean(this._sound))
         {
            this._sound = null;
         }
         if(Boolean(this._sc))
         {
            this._sc.stop();
            this._sc = null;
         }
      }
      
      private function fillColor(mc:MovieClip) : void
      {
         mc.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
         {
            var c:MovieClip = null;
            mc.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
            var num:uint = uint(mc.numChildren);
            for(var i:uint = 0; i < num; i++)
            {
               c = mc.getChildAt(i) as MovieClip;
               if(Boolean(c))
               {
                  if(c.name.substr(0,6) == "color_")
                  {
                     DisplayUtil.FillColor(c,_info.color);
                  }
               }
            }
         });
      }
      
      private function setGear() : void
      {
         this.clearActionMC();
         this._actionID = 0;
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
      }
      
      private function setClose() : void
      {
         this._info.state[0] = false;
         this._actionID = 3;
         this.getActionRes();
      }
      
      private function setOpen() : Boolean
      {
         if(this._info.power != 0)
         {
            this._info.state[0] = true;
            this._info.chargeTime = 0;
            this._actionID = 2;
            this.getActionRes();
            return true;
         }
         return false;
      }
      
      private function onResAction(arr:Array) : void
      {
         var loops:int = 0;
         this.clearActionMC();
         if(arr.length == 0)
         {
            return;
         }
         this._actionMC = arr[0] as MovieClip;
         if(Boolean(this._actionMC))
         {
            this._actionMC.scaleX = SCALE;
            this._actionMC.scaleY = SCALE;
            this.fillColor(this._actionMC);
            addChild(this._actionMC);
            this.stopAutoTime();
            this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,this.onActionScript);
            this._actionMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
            if(arr.length >= 2)
            {
               loops = MachXMLInfo.getActionSouLoops(this._actionID);
               if(loops > 0)
               {
                  this._sound = arr[1] as Sound;
                  if(Boolean(this._sound))
                  {
                     this._sc = this._sound.play(0,loops);
                  }
               }
            }
            DepthManager.bringToTop(this);
         }
      }
      
      private function onActionScript() : void
      {
         this._actionMC.addFrameScript(this._actionMC.totalFrames - 1,null);
         if(!MachXMLInfo.getActionIsAutoEnd(this._actionID))
         {
            return;
         }
         NonoManager.dispatchEvent(new DynamicEvent(NonoEvent.PLAY_COMPLETE,this._actionID));
         this._actionID = 0;
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.clearActionMC();
         this.initCheck();
      }
      
      private function onResExp(arr:Array) : void
      {
         var lineID:uint = 0;
         this.clearActionMC();
         if(arr.length == 0)
         {
            return;
         }
         this._expMC = arr[0] as MovieClip;
         if(Boolean(this._expMC))
         {
            this._expMC.scaleX = SCALE;
            this._expMC.scaleY = SCALE;
            this.fillColor(this._expMC);
            addChild(this._expMC);
            this.stopAutoTime();
            this.direction = Direction.DOWN;
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onExpScript);
            this._expMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
            if(this._linesList.length != 0)
            {
               lineID = uint(this._linesList[int(this._linesList.length * Math.random())]);
               showBox(MachXMLInfo.getLinesName(lineID),12);
            }
         }
         if(arr.length >= 2)
         {
            this._sound = arr[1] as Sound;
            if(Boolean(this._sound))
            {
               this._sc = this._sound.play(0,1);
            }
         }
      }
      
      private function onExpTime() : void
      {
         this._expID = this._expList[int(this._expList.length * Math.random())];
         this._linesList = MachXMLInfo.getLinesIDForExp(this._expID,this._info.getPowerLevel(),this._info.getMateLevel());
         this.getExpRes();
      }
      
      private function onExpScript() : void
      {
         this.clearActionMC();
         if(this._actionID != 0)
         {
            return;
         }
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.startAutoTime();
      }
      
      private function changedir() : void
      {
         var num:uint = 0;
         var i:uint = 0;
         var c:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            num = uint(this._bodyMC.numChildren);
            for(i = 0; i < num; i++)
            {
               c = this._bodyMC.getChildAt(i) as MovieClip;
               if(c != this._bodyDownColorMC && c != this._bodyUpColorMC && c != this._bodyFootMC && c != this._bodyChildMC)
               {
                  c.gotoAndStop(_direction);
               }
            }
            if(Boolean(this._bodyUpColorMC))
            {
               this._bodyUpColorMC.gotoAndStop(_direction);
               this._bodyUpColorMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
               {
                  var upmc:MovieClip = null;
                  _bodyUpColorMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyUpColorMC.numChildren > 0)
                  {
                     upmc = _bodyUpColorMC.getChildAt(0) as MovieClip;
                     if(Boolean(upmc))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyDownColorMC))
            {
               this._bodyDownColorMC.gotoAndStop(_direction);
               this._bodyDownColorMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
               {
                  var downmc:MovieClip = null;
                  _bodyDownColorMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyDownColorMC.numChildren > 0)
                  {
                     downmc = _bodyDownColorMC.getChildAt(0) as MovieClip;
                     if(Boolean(downmc))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyChildMC))
            {
               this._bodyChildMC.gotoAndStop(_direction);
               this._bodyChildMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
               {
                  var cmc:MovieClip = null;
                  _bodyChildMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyChildMC.numChildren > 0)
                  {
                     cmc = _bodyChildMC.getChildAt(0) as MovieClip;
                     if(Boolean(cmc))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyFootMC))
            {
               this._bodyFootMC.gotoAndStop(_direction);
               this._bodyFootMC.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
               {
                  var fmc:MovieClip = null;
                  _bodyFootMC.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyFootMC.numChildren > 0)
                  {
                     fmc = _bodyFootMC.getChildAt(0) as MovieClip;
                     if(Boolean(fmc))
                     {
                     }
                  }
               });
            }
            if(Boolean(this._bodyFootMC2))
            {
               this._bodyFootMC2.gotoAndStop(_direction);
               this._bodyFootMC2.addEventListener(RobotEvent.FRAME_CONSTRUCTED,function(e:Event):void
               {
                  var fmc:MovieClip = null;
                  _bodyFootMC2.removeEventListener(RobotEvent.FRAME_CONSTRUCTED,arguments.callee);
                  if(_bodyFootMC2.numChildren > 0)
                  {
                     fmc = _bodyFootMC2.getChildAt(0) as MovieClip;
                     if(Boolean(fmc))
                     {
                     }
                  }
               });
            }
         }
      }
      
      private function onPeopleWalkEnter(e:Event) : void
      {
         var p:Point = null;
         var mx:Number = NaN;
         var my:Number = NaN;
         if(Boolean(this._bodyMC))
         {
            if(this._enterCount % 3 == 0)
            {
               this._bodyRect = this._bodyMC.transform.pixelBounds;
               p = this._bodyMC.localToGlobal(this._nullPos);
               mx = p.x - this._bodyRect.x;
               my = p.y - this._bodyRect.y;
               this._matriix.createBox(SCALE,SCALE,0,-this._bodyMC.x + mx,-this._bodyMC.y + my);
               this._bmd = new BitmapData(this._bodyRect.width,this._bodyRect.height - 13,true,0);
               this._bmd.draw(this._bodyMC,this._matriix);
               this._bmp = new Bitmap(this._bmd);
               this._bmp.x = -LevelManager.mapLevel.x + this._bodyRect.x;
               this._bmp.y = -LevelManager.mapLevel.y + this._bodyRect.y;
               this._bmp.alpha = 0.5;
               MapManager.currentMap.depthLevel.addChildAt(this._bmp,0);
               this._bmp.addEventListener(Event.ENTER_FRAME,this.onBMPEnter);
            }
            ++this._enterCount;
         }
      }
      
      private function onBMPEnter(e:Event) : void
      {
         var bmp:Bitmap = e.target as Bitmap;
         if(bmp.alpha <= 0)
         {
            bmp.bitmapData.dispose();
            bmp.removeEventListener(Event.ENTER_FRAME,this.onBMPEnter);
            DisplayUtil.removeForParent(bmp);
            bmp = null;
         }
         else
         {
            bmp.alpha -= 0.05;
         }
      }
      
      private function onPeopleWalkStart(e:Event = null) : void
      {
         clearTimeout(this._followTimeID);
         this.clearActionMC();
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         if(Boolean(this._expID))
         {
            if(this._info.superNono)
            {
               ResourceManager.cancel(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResFollowExp);
            }
            else
            {
               ResourceManager.cancel(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResFollowExp);
            }
            this._expID = 0;
         }
      }
      
      private function onPeopleWalkEnd(e:Event = null) : void
      {
         this._followTimeID = setTimeout(this.onFollowTime,MathUtil.randomHalve(20000));
         if(NonoManager.isBeckon)
         {
            NonoManager.isBeckon = false;
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/6" + "_" + this._info.superStage),this.onResFollowAction,ClaName);
         }
      }
      
      private function onFollowTime() : void
      {
         this._expID = this._expList[int(this._expList.length * Math.random())];
         if(this._info.superNono)
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResFollowExp,"pet");
         }
         else
         {
            ResourceManager.getResource(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResFollowExp,"pet");
         }
      }
      
      private function onResFollowExp(o:DisplayObject) : void
      {
         this.clearActionMC();
         this._expMC = o as MovieClip;
         this._expMC.scaleX = SCALE;
         this._expMC.scaleY = SCALE;
         this.fillColor(this._expMC);
         addChild(this._expMC);
         clearTimeout(this._followTimeID);
         this.direction = Direction.DOWN;
         this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onFollowExpScript);
         this._expMC.gotoAndPlay(1);
         if(Boolean(this._bodyMC))
         {
            DisplayUtil.removeForParent(this._bodyMC,false);
         }
      }
      
      private function onFollowExpScript() : void
      {
         this.clearActionMC();
         if(Boolean(this._bodyMC))
         {
            addChild(this._bodyMC);
         }
         this.onPeopleWalkEnd();
      }
      
      private function onResFollowAction(arr:Array) : void
      {
         this.clearActionMC();
         if(arr.length == 0)
         {
            return;
         }
         this._expMC = arr[0] as MovieClip;
         if(Boolean(this._expMC))
         {
            this._expMC.scaleX = SCALE;
            this._expMC.scaleY = SCALE;
            this.fillColor(this._expMC);
            addChild(this._expMC);
            clearTimeout(this._followTimeID);
            this.direction = Direction.DOWN;
            this._expMC.addFrameScript(this._expMC.totalFrames - 1,this.onFollowExpScript);
            this._expMC.gotoAndPlay(1);
            if(Boolean(this._bodyMC))
            {
               DisplayUtil.removeForParent(this._bodyMC,false);
            }
         }
         if(arr.length >= 2)
         {
            this._sound = arr[1] as Sound;
            if(Boolean(this._sound))
            {
               this._sc = this._sound.play(0,1);
            }
         }
      }
      
      private function onPeopleDir(e:DynamicEvent) : void
      {
         this.direction = e.paramObject as String;
         this.moveForPeople();
      }
      
      private function moveForPeople(d:Boolean = true) : void
      {
         if(Boolean(this._people))
         {
            switch(this._people.direction)
            {
               case Direction.LEFT_DOWN:
               case Direction.DOWN:
               case Direction.RIGHT_DOWN:
                  this._dirPos.y = -MAX;
                  DepthManager.bringToBottom(this);
                  break;
               case Direction.UP:
               case Direction.RIGHT_UP:
               case Direction.LEFT_UP:
                  this._dirPos.y = 10;
                  DepthManager.bringToTop(this);
                  break;
               case Direction.LEFT:
               case Direction.RIGHT:
                  this._dirPos.y = 0;
                  DepthManager.bringToBottom(this);
            }
            switch(this._people.direction)
            {
               case Direction.LEFT:
               case Direction.DOWN:
               case Direction.LEFT_DOWN:
               case Direction.LEFT_UP:
                  this._dirPos.x = MAX;
                  break;
               case Direction.UP:
               case Direction.RIGHT:
               case Direction.RIGHT_DOWN:
               case Direction.RIGHT_UP:
                  this._dirPos.x = -MAX;
            }
            if(d)
            {
               if(Math.abs(Point.distance(pos,this._dirPos)) > 4)
               {
                  this._dirSpeed = GeomUtil.angleSpeed(pos,this._dirPos);
                  this._dirSpeed.x *= 4;
                  this._dirSpeed.y *= 4;
                  addEventListener(Event.ENTER_FRAME,this.onMoveDir);
               }
            }
            else
            {
               pos = this._dirPos.clone();
            }
         }
      }
      
      private function onMoveDir(e:Event) : void
      {
         if(Math.abs(Point.distance(pos,this._dirPos)) < 4)
         {
            removeEventListener(Event.ENTER_FRAME,this.onMoveDir);
         }
         pos = pos.subtract(this._dirSpeed);
      }
      
      private function onNonoEvent(e:NonoActionEvent) : void
      {
         var flag:Boolean = false;
         var flag1:Boolean = false;
         switch(e.actionType)
         {
            case NonoActionEvent.COLOR_CHANGE:
               this._info.color = e.data as uint;
               if(Boolean(this._bodyUpColorMC))
               {
                  DisplayUtil.FillColor(this._bodyUpColorMC,this._info.color);
               }
               if(Boolean(this._bodyDownColorMC))
               {
                  DisplayUtil.FillColor(this._bodyDownColorMC,this._info.color);
               }
               break;
            case NonoActionEvent.NAME_CHANGE:
               this._info.nick = e.data as String;
               break;
            case NonoActionEvent.CLOSE_OPEN:
               flag = e.data as Boolean;
               if(flag)
               {
                  this.setOpen();
               }
               else
               {
                  this.setClose();
               }
               break;
            case NonoActionEvent.NONO_PLAY:
               this._actionID = e.data as uint;
               if(this._actionID == 0)
               {
                  return;
               }
               this.getActionRes();
               break;
            case NonoActionEvent.CHARGEING:
               flag1 = e.data as Boolean;
               if(flag1)
               {
                  this._info.chargeTime = 1;
                  this._actionID = 1;
                  this._info.state[0] = false;
                  this.getActionRes();
               }
               else
               {
                  this._info.chargeTime = 0;
                  this._actionID = 0;
                  if(!this._info.state[0] || this._info.power == 0)
                  {
                     this.setClose();
                  }
                  else
                  {
                     this.setGear();
                     this.startAutoTime();
                  }
               }
         }
      }
      
      private function onWalkStart(e:Event) : void
      {
         var upmc:MovieClip = null;
         var downmc:MovieClip = null;
         var cmc:MovieClip = null;
         var fmc:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            if(Boolean(this._bodyUpColorMC))
            {
               if(this._bodyUpColorMC.numChildren > 0)
               {
                  upmc = this._bodyUpColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(upmc))
                  {
                     if(upmc.currentFrame == 1)
                     {
                        upmc.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyDownColorMC))
            {
               if(this._bodyDownColorMC.numChildren > 0)
               {
                  downmc = this._bodyDownColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(downmc))
                  {
                     if(downmc.currentFrame == 1)
                     {
                        downmc.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyChildMC))
            {
               if(this._bodyChildMC.numChildren > 0)
               {
                  cmc = this._bodyChildMC.getChildAt(0) as MovieClip;
                  if(Boolean(cmc))
                  {
                     if(cmc.currentFrame == 1)
                     {
                        cmc.gotoAndStop(2);
                     }
                  }
               }
            }
            if(Boolean(this._bodyFootMC))
            {
               if(this._bodyFootMC.numChildren > 0)
               {
                  fmc = this._bodyFootMC.getChildAt(0) as MovieClip;
                  if(Boolean(fmc))
                  {
                     if(fmc.currentFrame == 1)
                     {
                        fmc.gotoAndStop(2);
                     }
                  }
               }
            }
         }
      }
      
      private function onWalkEnd(e:Event) : void
      {
         var upmc:MovieClip = null;
         var downmc:MovieClip = null;
         var cmc:MovieClip = null;
         var fmc:MovieClip = null;
         if(Boolean(this._bodyMC))
         {
            if(Boolean(this._bodyUpColorMC))
            {
               if(this._bodyUpColorMC.numChildren > 0)
               {
                  upmc = this._bodyUpColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(upmc))
                  {
                     if(upmc.currentFrame == 2)
                     {
                        upmc.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyDownColorMC))
            {
               if(this._bodyDownColorMC.numChildren > 0)
               {
                  downmc = this._bodyDownColorMC.getChildAt(0) as MovieClip;
                  if(Boolean(downmc))
                  {
                     if(downmc.currentFrame == 2)
                     {
                        downmc.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyChildMC))
            {
               if(this._bodyChildMC.numChildren > 0)
               {
                  cmc = this._bodyChildMC.getChildAt(0) as MovieClip;
                  if(Boolean(cmc))
                  {
                     if(cmc.currentFrame == 2)
                     {
                        cmc.gotoAndStop(1);
                     }
                  }
               }
            }
            if(Boolean(this._bodyFootMC))
            {
               if(this._bodyFootMC.numChildren > 0)
               {
                  fmc = this._bodyFootMC.getChildAt(0) as MovieClip;
                  if(Boolean(fmc))
                  {
                     if(fmc.currentFrame == 2)
                     {
                        fmc.gotoAndStop(1);
                     }
                  }
               }
            }
         }
      }
      
      private function getActionRes() : void
      {
         if(this._info.superNono)
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/" + this._actionID.toString() + "_" + this._info.superStage),this.onResAction,ClaName);
         }
         else
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "action/" + this._actionID.toString()),this.onResAction,ClaName);
         }
      }
      
      private function getExpRes() : void
      {
         if(this._info.superNono)
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString() + "_" + this._info.superStage),this.onResExp,ClaName);
         }
         else
         {
            ResourceManager.getResourceList(ClientConfig.getNonoPath(this._resPath + "exp/" + this._expID.toString()),this.onResExp,ClaName);
         }
      }
      
      private function onOver(e:MouseEvent) : void
      {
         var flag:Boolean = false;
         if(this._people == null)
         {
            flag = false;
         }
         else
         {
            flag = true;
            if(this._people.walk.isPlaying)
            {
               return;
            }
         }
         var p:Point = localToGlobal(new Point(0,-30));
         NonoShortcut.show(p,this._info,flag);
         this.stopAutoTime();
      }
      
      private function onShortcutHide(e:Event) : void
      {
         if(this._people == null)
         {
            this.startAutoTime();
         }
      }
      
      public function startPlay() : void
      {
      }
      
      public function stopPlay() : void
      {
      }
      
      private function onClick(e:MouseEvent) : void
      {
         NonoInfoPanelController.show(this._info);
      }
   }
}


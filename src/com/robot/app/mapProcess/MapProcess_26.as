package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.PetModel;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.TweenLite;
   import org.taomee.effect.ColorFilter;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_26 extends BaseMapProcess
   {
      private var isShow:Boolean;
      
      private var _beeMc:MovieClip;
      
      private var _beeTimeID:uint;
      
      private var appModel:AppModel;
      
      public function MapProcess_26()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._beeMc = btnLevel["beeMc"];
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         if(!MainManager.actorInfo.superNono)
         {
            this.checkFlightCloth();
         }
         conLevel["cloudMc"].buttonMode = true;
         ToolTipManager.add(conLevel["cloudMc"],"梦幻云层");
         this.check();
      }
      
      override public function destroy() : void
      {
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         this._beeMc.removeEventListener(MouseEvent.CLICK,this.onBeeClick);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         ToolTipManager.remove(conLevel["cloudMc"]);
         if(!this.isShow)
         {
            conLevel["cloudMc"].removeEventListener(MouseEvent.CLICK,this.onCloudMcClickHandler);
            conLevel["shipMc"]["redMc"].removeEventListener(MouseEvent.CLICK,this.onRedClickHandler);
            conLevel["shipMc"]["greenMc"].removeEventListener(MouseEvent.CLICK,this.onGreenClickHandler);
            conLevel["shipMc"]["lightMc"].removeEventListener(MouseEvent.CLICK,this.onLightClickHandler);
         }
         DisplayUtil.removeForParent(this._beeMc);
         this._beeMc = null;
      }
      
      private function onAimatEnd(e:AimatEvent) : void
      {
         if(MainManager.actorInfo.clothIDs.indexOf(100245) == -1)
         {
            return;
         }
         var info:AimatInfo = e.info;
         if(info.userID == MainManager.actorID)
         {
            if(this._beeMc.hitTestPoint(info.endPos.x,info.endPos.y))
            {
               if(this._beeMc.currentFrame > 45 && this._beeMc.currentFrame < 104 || this._beeMc.currentFrame > 118 && this._beeMc.currentFrame < 172)
               {
                  this._beeMc.stop();
                  this._beeMc.filters = [ColorFilter.setHue(160)];
                  this._beeMc.buttonMode = true;
                  this._beeMc.addEventListener(MouseEvent.CLICK,this.onBeeClick);
               }
            }
         }
      }
      
      private function onBeeClick(e:MouseEvent) : void
      {
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         MainManager.actorModel.walkAction(new Point(e.stageX,e.stageY));
      }
      
      private function onMapDown(e:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
      }
      
      private function onWalkEnter(e:Event) : void
      {
         if(MainManager.actorModel.hitTestObject(this._beeMc))
         {
            MainManager.actorModel.stop();
            MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
            FightInviteManager.fightWithBoss("小莹蜂");
            return;
         }
      }
      
      private function checkFlightCloth() : void
      {
         var closeAry:Array = MainManager.actorInfo.clothIDs;
         var b:Boolean = Boolean(ArrayUtil.embody(MainManager.actorInfo.clothIDs,[100048,100049,100050,100051]));
         if(!b)
         {
            LevelManager.closeMouseEvent();
            TweenLite.to(MainManager.actorModel.sprite,2,{
               "y":600,
               "onComplete":this.changeMap
            });
         }
      }
      
      private function changeMap() : void
      {
         MapManager.changeMap(25);
      }
      
      private function check() : void
      {
         conLevel["cloudMc"].addEventListener(MouseEvent.CLICK,this.onCloudMcClickHandler);
      }
      
      private function onComHandler(a:Array) : void
      {
         if(!a[0])
         {
            this.isShow = false;
            return;
         }
         if(Boolean(a[1]))
         {
            this.isShow = false;
            return;
         }
         this.isShow = true;
         conLevel["cloudMc"].buttonMode = true;
         conLevel["cloudMc"].addEventListener(MouseEvent.CLICK,this.onCloudMcClickHandler);
         conLevel["shipMc"]["redMc"].buttonMode = true;
         conLevel["shipMc"]["redMc"].addEventListener(MouseEvent.CLICK,this.onRedClickHandler);
         conLevel["shipMc"]["greenMc"].buttonMode = true;
         conLevel["shipMc"]["greenMc"].addEventListener(MouseEvent.CLICK,this.onGreenClickHandler);
         conLevel["shipMc"]["lightMc"].addEventListener(MouseEvent.CLICK,this.onLightClickHandler);
      }
      
      private function onCloudMcClickHandler(e:MouseEvent) : void
      {
         var str:String = null;
         var model:ActorModel = null;
         var petModel:PetModel = null;
         var petID:uint = 0;
         if(!TasksManager.isComNoviceTask())
         {
            Alarm.show("你必须要先完成新手任务才能来这里找我哦!");
            return;
         }
         if(TasksManager.getTaskStatus(406) == TasksManager.COMPLETE)
         {
            Alarm.show("你的幽浮看起来已经有点累咯，明天再来陪它玩吧！");
            return;
         }
         if(TasksManager.getTaskStatus(406) == TasksManager.UN_ACCEPT)
         {
            str = "你还没有获取" + TextFormatUtil.getRedTxt("幽浮捉迷藏") + "的每日任务呢，" + "快点击右上角的" + TextFormatUtil.getRedTxt("赛尔号每日任务") + "按钮看看吧！";
            Alarm.show(str);
         }
         else
         {
            model = MainManager.actorModel;
            petModel = model.pet;
            if(Boolean(petModel))
            {
               petID = uint(petModel.info.petID);
               if(petID == 25 || petID == 26)
               {
                  this.startHideGame();
               }
               else
               {
                  Alarm.show("快带上你的" + TextFormatUtil.getRedTxt("幽浮") + "吧，它可是跃跃欲试地想要过一把捉迷藏的瘾呢！");
               }
            }
            else
            {
               Alarm.show("快带上你的" + TextFormatUtil.getRedTxt("幽浮") + "吧，它可是跃跃欲试地想要过一把捉迷藏的瘾呢！");
            }
         }
      }
      
      private function startHideGame() : void
      {
         if(!this.appModel)
         {
            this.appModel = new AppModel(ClientConfig.getTaskModule("YoufuHideAndSeekTask"),"正在打开...");
            this.appModel.setup();
         }
         this.appModel.show();
      }
      
      private function onRedClickHandler(e:MouseEvent) : void
      {
         conLevel["shipMc"]["redMc"].removeEventListener(MouseEvent.CLICK,this.onRedClickHandler);
         conLevel["shipMc"]["greenMc"].addEventListener(MouseEvent.CLICK,this.onGreenClickHandler);
         conLevel["shipMc"]["redMc"].gotoAndStop(3);
         conLevel["shipMc"]["greenMc"].gotoAndStop(3);
      }
      
      private function onGreenClickHandler(e:MouseEvent) : void
      {
         conLevel["shipMc"]["redMc"].addEventListener(MouseEvent.CLICK,this.onRedClickHandler);
         conLevel["shipMc"]["greenMc"].removeEventListener(MouseEvent.CLICK,this.onGreenClickHandler);
         conLevel["shipMc"]["redMc"].gotoAndStop(1);
         conLevel["shipMc"]["greenMc"].gotoAndStop(1);
      }
      
      private function onLightClickHandler(e:MouseEvent) : void
      {
         conLevel["shipMc"]["lightMc"].removeEventListener(MouseEvent.CLICK,this.onLightClickHandler);
         conLevel["shipMc"]["redMc"].removeEventListener(MouseEvent.CLICK,this.onRedClickHandler);
         conLevel["shipMc"]["greenMc"].removeEventListener(MouseEvent.CLICK,this.onGreenClickHandler);
         NpcTipDialog.show("救援总算来了！我刚来这里执行任务的时候，来了一个紫色的海盗，估计跟艾里逊是一伙的，我当时可威风了，立刻消灭了他!",this.onSureHandler,NpcTipDialog.DINGDING,-60,this.onSureHandler);
      }
      
      private function onSureHandler() : void
      {
         NpcTipDialog.show("在赶跑他的时候，我去关掉飞船的电源打算把海盗的资料都调出来带回去。结果海盗大部队赶到，把我关在这里了。",this.onSureOneHandler,NpcTipDialog.DINGDING,-60,this.onSureOneHandler);
      }
      
      private function onSureOneHandler() : void
      {
         NpcTipDialog.show("他们来了很多人啊，都是我没有见过的。当中有一个块头特别大，好像很强的样子，我看见他一脚就把大炮的门踩坏了。",this.onSureTwoHandler,NpcTipDialog.DINGDING,-60,this.onSureTwoHandler);
      }
      
      private function onSureTwoHandler() : void
      {
         NpcTipDialog.show("对了，我的傻弟弟好像还被困在塞西利亚呢！拜托你快去救救他吧，我实在无能为力，需要快点回去充电了……",this.onSureThreeHandler,NpcTipDialog.DINGDING,-60,this.onSureThreeHandler);
      }
      
      private function onSureThreeHandler() : void
      {
         TasksManager.setProStatus(14,1,true);
      }
   }
}


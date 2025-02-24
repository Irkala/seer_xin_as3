package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.control.TaskController_79;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.GamePlatformEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.GamePlatformManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_60 extends BaseMapProcess
   {
      private var _yq_btn:SimpleButton;
      
      private var _st_btn:SimpleButton;
      
      private var _long_mc:MovieClip;
      
      private var lmc:MovieClip;
      
      private var blackHot:MovieClip;
      
      private var helpSer:MovieClip;
      
      private var guess:MovieClip;
      
      private var panelOne:AppModel = null;
      
      private var panelOne1:AppModel = null;
      
      private var panelOne2:AppModel = null;
      
      private var numAdd:Number = 0;
      
      private var numAdd2:Number = 0;
      
      private var _feng_mc:MovieClip;
      
      private var _mach_mc:MovieClip;
      
      private var _tree_mc:MovieClip;
      
      private var _tree_btn:SimpleButton;
      
      private var evaBig:MovieClip;
      
      public function MapProcess_60()
      {
         var i:uint;
         super();
         this._feng_mc = animatorLevel["feng_mc"];
         this._mach_mc = animatorLevel["mach_mc"];
         this._tree_mc = animatorLevel["tree_mc"];
         this._tree_btn = btnLevel["tree_btn"];
         this._mach_mc.gotoAndStop(1);
         this._mach_mc.visible = false;
         this._tree_btn.visible = true;
         ToolTipManager.add(this._tree_btn,"植物大战沙尘暴");
         this.evaBig = depthLevel["bigEva"];
         this.evaBig.visible = false;
         this.evaBig.gotoAndStop(1);
         TasksManager.getProStatusList(97,function(arr:Array):void
         {
            if(Boolean(arr[3]) && !arr[4])
            {
               if(MapProcess_325.vistiteEva != "visited")
               {
                  evaBig.visible = true;
                  evaBig.buttonMode = true;
                  evaBig.addEventListener(MouseEvent.CLICK,pleaseEva);
               }
            }
         });
         this._tree_btn.addEventListener(MouseEvent.CLICK,this.clickTreeHandler);
         ToolTipManager.add(conLevel["door_1"],"光暗之城");
         this.blackHot = depthLevel["blackHole"];
         this.helpSer = depthLevel["helpSeer"];
         this.guess = topLevel["guessMC"];
         this.numAdd = 0;
         this.numAdd2 = 0;
         this.guess.visible = false;
         this.addLisGame();
         for(i = 0; i < 4; i++)
         {
            this.guess["mc" + i].buttonMode = true;
            this.guess["mc" + i].addEventListener(MouseEvent.CLICK,this.chooseSec);
         }
         this.guess["enterBtn"].addEventListener(MouseEvent.CLICK,this.enterChoose);
         this.guess["closeBtn"].addEventListener(MouseEvent.CLICK,this.closeChoose);
         this.blackHot.buttonMode = true;
         this.helpSer.buttonMode = true;
         this.helpSer.visible = false;
         this.blackHot.visible = false;
         if(TasksManager.getTaskStatus(83) == TasksManager.UN_ACCEPT)
         {
            this.blackHot.visible = true;
            this.blackHot.gotoAndStop(2);
         }
         else if(TasksManager.getTaskStatus(83) != TasksManager.COMPLETE)
         {
            TasksManager.getProStatusList(83,function(arr:Array):void
            {
               blackHot.visible = true;
               blackHot.gotoAndStop(1);
               if(arr[0] && !arr[1] || arr[1] && !arr[2])
               {
                  if(Boolean(arr[0]) && !arr[1])
                  {
                     helpSer.visible = true;
                     helpSer.gotoAndStop(2);
                     blackHot.mouseChildren = false;
                     blackHot.mouseEnabled = false;
                  }
                  if(Boolean(arr[1]) && !arr[2])
                  {
                     helpSer.visible = true;
                     helpSer.gotoAndStop(2);
                     blackHot.mouseChildren = false;
                     blackHot.mouseEnabled = false;
                  }
               }
               if(!arr[0])
               {
                  helpSer.visible = true;
                  blackHot.visible = true;
               }
            });
         }
         this.blackHot.addEventListener(MouseEvent.CLICK,this.showSpeak);
         this.helpSer.addEventListener(MouseEvent.CLICK,this.showSeerHelp);
         this.lmc = conLevel as MovieClip;
         this.lmc.gotoAndStop(1);
         this.lmc.addEventListener("clickhamole",this.clickHamOHandler);
         this._yq_btn = conLevel["yq_btn"];
         this._yq_btn.enabled = false;
         this._st_btn = conLevel["shitou_btn"];
         ToolTipManager.add(this._st_btn,"异类石堆");
         this._long_mc = conLevel["long_mc"];
         this._long_mc.visible = false;
         this._long_mc.buttonMode = true;
         this._long_mc.addEventListener(MouseEvent.CLICK,this.clickLongHandler);
         this._st_btn.mouseEnabled = false;
         this._st_btn.addEventListener(MouseEvent.CLICK,this.clickShiTouHandler);
         this._yq_btn.addEventListener(MouseEvent.CLICK,this.clickYqHandler);
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) == TasksManager.COMPLETE)
         {
            this._long_mc.visible = true;
            this._yq_btn.visible = false;
            this._st_btn.visible = false;
            return;
         }
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) != TasksManager.ALR_ACCEPT)
         {
            return;
         }
         TaskController_79.initLong(this.lmc,this._long_mc,this._yq_btn,this._st_btn);
         TasksManager.getProStatusList(TaskController_79.TASK_ID,function(arr:Array):void
         {
            if(!arr[0])
            {
               TaskController_79.inScean();
            }
            else if(Boolean(arr[0]))
            {
               _long_mc.visible = true;
               _yq_btn.enabled = true;
               _st_btn.visible = true;
            }
            if(Boolean(arr[1]) && !arr[2])
            {
               _yq_btn.enabled = false;
               _st_btn.visible = false;
               _long_mc.visible = false;
               lmc.gotoAndStop(88);
            }
         });
      }
      
      private function pleaseEva(e:MouseEvent) : void
      {
         NpcDialog.show(NPC.EVA,["咦？#7伊娃伊娃!彭恰恰！！#6艾迪？GOGOGO~~~~"],["嘿嘿……"],[function():void
         {
            var panel:* = undefined;
            var name:* = undefined;
            evaBig.gotoAndPlay(1);
            MapProcess_325.vistiteEva = "visited";
            evaBig.mouseChildren = false;
            evaBig.mouseEnabled = false;
            if(MapProcess_325.visiteMaomao == "visited")
            {
               TasksManager.complete(97,4,null,true);
            }
            else
            {
               panel = null;
               name = "TaskPanel_97";
               if(panel)
               {
                  panel.destroy();
                  panel = null;
               }
               panel = new AppModel(ClientConfig.getTaskModule(name),"正在打开任务信息");
               panel.setup();
               panel.show();
            }
         }]);
      }
      
      private function gameWin(e:GamePlatformEvent) : void
      {
      }
      
      private function addLisGame() : void
      {
      }
      
      public function onLineClickHandler() : void
      {
         var n:uint = uint(Math.random() * 2);
         if(n == 0)
         {
            MapManager.changeMap(61);
         }
         else
         {
            MapManager.changeMap(62);
         }
      }
      
      private function clickTreeHandler(e:MouseEvent) : void
      {
         GamePlatformManager.join("PlantsVSZombies",true);
      }
      
      private function enterChoose(e:MouseEvent) : void
      {
         var url:String = null;
         if(this.guess["mc2"].currentFrame == 2)
         {
            url = "resource/bounsMovie/circleRun.swf";
            depthLevel.mouseEnabled = true;
            depthLevel.mouseChildren = true;
            AnimateManager.playFullScreenAnimate(url,function():void
            {
               TasksManager.complete(83,1,null,true);
               LevelManager.closeMouseEvent();
               guess.visible = false;
               helpSer.visible = true;
               helpSer.gotoAndStop(2);
               helpSer.mouseChildren = true;
               helpSer.mouseEnabled = true;
            });
            LevelManager.openMouseEvent();
         }
         else if(this.guess["mc0"].currentFrame == 1 && this.guess["mc1"].currentFrame == 1 && this.guess["mc2"].currentFrame == 1 && this.guess["mc3"].currentFrame == 1)
         {
            Alarm.show("您还没有回答我的问题哦！",null);
         }
         else
         {
            this.guess.visible = false;
            NpcTipDialog.show("喂喂喂！你有没有认真在想啊！好吧……我勉强再给你一次机会，你再好好想想吧！",function():void
            {
               guess.visible = true;
            },NpcTipDialog.UNKNOWNPET);
            depthLevel.mouseEnabled = true;
            depthLevel.mouseChildren = true;
         }
      }
      
      private function closeChoose(e:MouseEvent) : void
      {
         this.guess.visible = false;
         depthLevel.mouseEnabled = true;
         depthLevel.mouseChildren = true;
         LevelManager.openMouseEvent();
      }
      
      private function chooseSec(e:MouseEvent) : void
      {
         for(var i:uint = 0; i < 4; i++)
         {
            this.guess["mc" + i].gotoAndStop(1);
         }
         e.currentTarget.gotoAndStop(2);
      }
      
      private function showSpeak(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(83) == TasksManager.UN_ACCEPT)
         {
            NpcTipDialog.show("你是谁？你来自哪里？你来这里干吗？你为什么长成这样啊？还有你不怕在这里迷路吗？",function():void
            {
               NpcTipDialog.show("⊙﹏⊙你怎么一下子问我这么多问题……不对啊！你又是谁？你来自哪里？你来这里干吗？为什么我看不到你啊？为什么黑影会说话？",function():void
               {
                  NpcTipDialog.showAnswer("要我回答你的问题也可以！但是要看你有没有这个本事了！你有胆量接受我的考验吗？哼哼……好戏还在后头呢！╭(╯^╰)╮",function():void
                  {
                     TasksManager.accept(83,null);
                     trace("黑影烟消云散");
                     blackHot.gotoAndStop(1);
                     helpSer.visible = true;
                     if(panelOne == null)
                     {
                        panelOne = new AppModel(ClientConfig.getTaskModule("TaskPanel_83"),"正在打开任务信息");
                        panelOne.setup();
                     }
                     panelOne.show();
                  },null,NpcTipDialog.UNKNOWNPET);
               },NpcTipDialog.SEER);
            },NpcTipDialog.UNKNOWNPET);
         }
         TasksManager.getProStatusList(83,function(arr:Array):void
         {
            if(TasksManager.getTaskStatus(83) == TasksManager.ALR_ACCEPT && !arr[0])
            {
               NpcTipDialog.show("怎么？没有经过我的考验就想让我现身？最后说一遍！只有靠你自己的能力找到我的真身，我才会现身……",null,NpcTipDialog.UNKNOWNPET);
            }
         });
      }
      
      private function showSeerHelp(e:MouseEvent) : void
      {
         TasksManager.getProStatusList(83,function(arr:Array):void
         {
            if(Boolean(arr[0]) && !arr[1])
            {
               NpcTipDialog.show("刚才是对你勇气的考验！没想到你竟然为了精灵勇于牺牲自己！下面就是智慧测试了，能否看到我的真身，就看这关了！",function():void
               {
                  guess.visible = true;
                  depthLevel.mouseEnabled = false;
                  depthLevel.mouseChildren = false;
               },NpcTipDialog.UNKNOWNPET);
            }
            if(Boolean(arr[1]) && !arr[2])
            {
               helpSer.gotoAndStop(3);
               helpSer.addEventListener(Event.ENTER_FRAME,checkFrames);
               blackHot.gotoAndStop(3);
               ++numAdd2;
            }
            if(!arr[0])
            {
               if(numAdd == 0)
               {
                  NpcTipDialog.showAnswer("救命！救命！这下面困着一个精灵，它似乎奄奄一息了！不过下面可是很危险的，你愿意为精灵去冒生命危险吗？",function():void
                  {
                     NpcTipDialog.show("咦？我的头怎么感觉这么晕？视线也变的好模糊，眼前似乎出现了一些幻影……",function():void
                     {
                        var mclloader:MCLoader = new MCLoader("resource/bounsMovie/downSeer.swf",LevelManager.appLevel,1,"正在打开赛尔掉落动画");
                        mclloader.addEventListener(MCLoadEvent.SUCCESS,onLoadControlMovie);
                        mclloader.doLoad();
                     },NpcTipDialog.SEER);
                  },null,NpcTipDialog.ZISESEER);
               }
            }
         });
      }
      
      private function checkFrames(e:Event) : void
      {
         if(Boolean(this.helpSer["mc3"]))
         {
            if(this.helpSer["mc3"].curentFrame == this.helpSer["mc3"].tatalFrames)
            {
               this.helpSer.removeEventListener(Event.ENTER_FRAME,this.checkFrames);
               NpcTipDialog.show("其实我的真身并不在这里，我存在于一个称之为" + TextFormatUtil.getRedTxt("暗之迷城") + "的地方！右边有个入口，你可以进入，但是注意了，光暗迷城存在于一个空间，就看我和你的缘分了！",function():void
               {
                  NpcTipDialog.show("你进入的这个空间有可能是暗之迷城也有可能是光之迷城，哦对了！还有个家伙就居住在" + TextFormatUtil.getRedTxt("光之迷城") + "！想要见到我们？就看你有没有这个耐心了……回头见吧！",function():void
                  {
                     helpSer.gotoAndStop(4);
                     helpSer.mouseEnabled = false;
                     helpSer.mouseChildren = false;
                     TasksManager.complete(83,2,null,true);
                     blackHot.visible = false;
                  },NpcTipDialog.NEWUNKNOWNPET);
               },NpcTipDialog.NEWUNKNOWNPET);
            }
         }
      }
      
      private function movieOver(e:Event) : void
      {
         MainManager.getRoot().removeEventListener("PLAYMOVIE_OVER",this.movieOver);
         this.helpSer.gotoAndStop(2);
      }
      
      private function onLoadControlMovie(event:MCLoadEvent) : void
      {
         var content:MovieClip = null;
         content = event.getContent() as MovieClip;
         MainManager.getStage().addChild(content);
         content.addEventListener("DOWNSEER_OVER",function(event:Event):void
         {
            DisplayUtil.removeForParent(content);
            ++numAdd;
            NpcTipDialog.showAnswer("可别怪我没提醒你，正如你刚才看到的！你还是要去救那只精灵吗？",function():void
            {
               helpSer.gotoAndStop(2);
               setTimeout(function():void
               {
                  TasksManager.complete(83,0,null,true);
                  LevelManager.closeMouseEvent();
                  blackHot.mouseEnabled = false;
                  blackHot.mouseChildren = false;
                  MainManager.getRoot().addEventListener("PLAYMOVIE_OVER",movieOver);
               },1000);
            },function():void
            {
               numAdd = 0;
            },NpcTipDialog.ZISESEER);
         });
      }
      
      private function clickHamOHandler(e:Event) : void
      {
         TaskController_79.dongHua2();
      }
      
      private function clickLongHandler(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) == TasksManager.COMPLETE)
         {
            FightInviteManager.fightWithBoss("哈莫雷特");
            return;
         }
      }
      
      private function clickShiTouHandler(e:MouseEvent) : void
      {
         if(TaskController_79.clickSt == 1)
         {
            TaskController_79.clickS0();
         }
      }
      
      private function clickYqHandler(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) != TasksManager.ALR_ACCEPT)
         {
            return;
         }
         TasksManager.getProStatusList(TaskController_79.TASK_ID,function(arr:Array):void
         {
            if(Boolean(arr[0]) && !arr[1])
            {
               TaskController_79.showPanel0();
               _st_btn.mouseEnabled = true;
            }
         });
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(this._tree_btn);
         this.helpSer.removeEventListener(Event.ENTER_FRAME,this.checkFrames);
         MainManager.getRoot().removeEventListener("PLAYMOVIE_OVER",this.movieOver);
         this._tree_btn.removeEventListener(MouseEvent.CLICK,this.clickTreeHandler);
         this.blackHot.removeEventListener(MouseEvent.CLICK,this.showSpeak);
         this.helpSer.removeEventListener(MouseEvent.CLICK,this.showSeerHelp);
         this._tree_btn = null;
         this._feng_mc = null;
         this._mach_mc = null;
         this._tree_mc = null;
         this.blackHot = null;
         this.helpSer = null;
         this.guess = null;
         MainManager.actorModel.visible = true;
         this._yq_btn.removeEventListener(MouseEvent.CLICK,this.clickYqHandler);
         this._yq_btn = null;
      }
   }
}


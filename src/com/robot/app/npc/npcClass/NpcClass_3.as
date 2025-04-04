package com.robot.app.npc.npcClass
{
   import com.robot.app.mapProcess.MapProcess_5;
   import com.robot.app.task.noviceGuide.DoctorGuideDialog;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.task.control.TaskController_42;
   
   public class NpcClass_3 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      private var panel:AppModel = null;
      
      public function NpcClass_3(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
         this._curNpcModel.addEventListener(NpcEvent.TASK_WITHOUT_DES,this.onTaskWithoutDes);
      }
      
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         DoctorGuideDialog.showDialog(e.taskID);
         if(e.taskID == 97)
         {
            TasksManager.getProStatusList(97,function(arr:Array):void
            {
               var name:String = null;
               if(Boolean(arr[0]) && !arr[1])
               {
                  NpcDialog.show(NPC.DOCTOR,["艾迪星啊！艾迪星！你可总算让我发现了！#8啦啦啦……"],["博士这是在干吗啊……"],[function():void
                  {
                     trace("博士拿着手里的资料很高兴的转");
                     _curNpcModel.hide();
                     MapProcess_5.doctorNPC.visible = true;
                     MapProcess_5.doctorNPC.gotoAndStop(1);
                     AnimateManager.playMcAnimate(MapProcess_5.doctorNPC,0,null,function():void
                     {
                        NpcDialog.show(NPC.SEER,["博士啊！你这是在干吗呢？#7哦对了！我在艾迪星球上发现一个性格很奇怪的精灵哦！我怎么叫它，它都不理我，它长的……"],["它长的……"],[function():void
                        {
                           trace("帕尼会唱歌，个去可能是那种抒情的歌（类似儿童摇篮曲）");
                           AnimateManager.playFullScreenAnimate("resource/bounsMovie/musicMovie.swf",function():void
                           {
                              _curNpcModel.show();
                              MapProcess_5.doctorNPC.visible = false;
                              NpcDialog.show(NPC.DOCTOR,["它的名字叫帕尼，能够吸引它注意的只有音乐！小家伙是个音乐痴迷者，那个星球上的植物也是因为受到它音乐的影响而变得活了！"],["音乐！啊哈！我想到办法咯！博士我先走啦！"],[function():void
                              {
                                 TasksManager.complete(97,1,null,true);
                              }]);
                           });
                        }]);
                     });
                  }]);
               }
               else
               {
                  name = "TaskPanel_97";
                  if(Boolean(panel))
                  {
                     panel.destroy();
                     panel = null;
                  }
                  panel = new AppModel(ClientConfig.getTaskModule(name),"正在打开任务信息");
                  panel.setup();
                  panel.show();
               }
            });
         }else if(e.taskID == 42)
         {
            TasksManager.getProStatusList(42,function(arr:Array):void{
               if(Boolean(arr[2]) && !arr[3]){
                  NpcTipDialog.show("赛尔，多亏你拖住巨型机器人！我已经成功将卡塔精灵送到博士这里了",function():void{
                     NpcTipDialog.show("什么？！你是说你们回到了千年前的赫尔卡星？还遇到了赫尔卡星长老！",function():void{
                        NpcTipDialog.show("是的，博士！情况紧急！千年前的赫尔卡星现在机械巨人和叛变的机械精灵已经完全失去控制……你能研究出比卡塔精灵更厉害的机械精灵吗？",function():void{
                           NpcTipDialog.show("我只能提供给你一个我最新发明CC-0118机械精灵分析制造装置，能否制造出比卡塔更加厉害的家伙还要看你自己了！",function():void{
                              TasksManager.complete(TaskController_42.TASK_ID,3,function():void{TaskController_42.showPanel()})
                           },NpcTipDialog.DOCTOR)
                        },NpcTipDialog.SEER_SAD)
                     },NpcTipDialog.DOCTOR)
                  },NpcTipDialog.NONO)
               }
            })
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
         if(Boolean(this.panel))
         {
            this.panel.destroy();
            this.panel = null;
         }
      }
      
      private function onTaskWithoutDes(e:NpcEvent) : void
      {
         trace("task  test");
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}


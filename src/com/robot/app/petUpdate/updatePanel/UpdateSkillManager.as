package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.info.pet.update.UpdateSkillInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import flash.events.Event;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class UpdateSkillManager
   {
      private static var _info:UpdateSkillInfo;
      
      private static var _fun:Function;
      
      private static var singlePanel:SingleSkillPanel;
      
      private static var multiPanel:MultiSkillPanel;
      
      public function UpdateSkillManager()
      {
         super();
      }
      
      public static function update(info:UpdateSkillInfo, fun:Function) : void
      {
         _info = info;
         _fun = fun;
         execute();
      }
      
      private static function execute() : void
      {
         if(_info.activeSkills.length > 0)
         {
            showSinglePanel();
         }
         else if(_info.unactiveSkills.length > 0)
         {
            showMultiPanel();
         }
         else if(_fun != null)
         {
            _fun();
         }
      }
      
      private static function showSinglePanel() : void
      {
         if(!singlePanel)
         {
            singlePanel = new SingleSkillPanel();
            singlePanel.addEventListener(Event.CLOSE,onCloseSingle);
         }
         var id:uint = uint(_info.activeSkills.shift());
         singlePanel.setInfo(_info.petCatchTime,id,PetManager.getPetInfo(_info.petCatchTime) != null);
         DisplayUtil.align(singlePanel,null,AlignType.MIDDLE_CENTER);
         MainManager.getStage().addChild(singlePanel);
      }
      
      private static function onCloseSingle(event:Event) : void
      {
         DisplayUtil.removeForParent(singlePanel,false);
         execute();
      }
      
      private static function showMultiPanel() : void
      {
         if(!multiPanel)
         {
            multiPanel = new MultiSkillPanel();
            multiPanel.addEventListener(Event.CLOSE,onCloseMulti);
         }
         var id:uint = uint(_info.unactiveSkills.shift());
         multiPanel.setInfo(_info.petCatchTime,id,PetManager.getPetInfo(_info.petCatchTime) != null);
         DisplayUtil.align(multiPanel,null,AlignType.MIDDLE_CENTER);
         MainManager.getStage().addChild(multiPanel);
      }
      
      private static function onCloseMulti(event:Event) : void
      {
         DisplayUtil.removeForParent(multiPanel,false);
         execute();
      }
   }
}


package com.robot.app.petUpdate.updatePanel
{
   import com.robot.app.petUpdate.PetUpdatePropController;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.MainManager;
   import flash.events.Event;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class UpdatePropManager
   {
      private static var _newInfo:UpdatePropInfo;
      
      private static var _oldInfo:PetInfo;
      
      private static var _fun:Function;
      
      private static var levelPanel:UpdateLevelPanel;
      
      private static var nomalPanel:UpdateNomalPanel;
      
      private static var addPanel:UpdateNomalWithAddPanel;
      
      public function UpdatePropManager()
      {
         super();
      }
      
      public static function update(newInfo:UpdatePropInfo, oldInfo:PetInfo, fun:Function, showByLevelPanel:Boolean = false) : void
      {
         _fun = fun;
         _newInfo = newInfo;
         _oldInfo = oldInfo;
         if(_newInfo.level > _oldInfo.level || showByLevelPanel)
         {
            updateLevel();
         }
         else if(PetUpdatePropController.addition == 0)
         {
            updateNormal();
         }
         else
         {
            updateNormalWithAdd();
         }
      }
      
      private static function updateLevel() : void
      {
         if(!levelPanel)
         {
            levelPanel = new UpdateLevelPanel();
            levelPanel.addEventListener(Event.CLOSE,updateLevelCloseHandler);
         }
         levelPanel.setInfo(_newInfo,_oldInfo);
         DisplayUtil.align(levelPanel,null,AlignType.MIDDLE_CENTER);
         MainManager.getStage().addChild(levelPanel);
      }
      
      private static function updateNormal() : void
      {
         if(!nomalPanel)
         {
            nomalPanel = new UpdateNomalPanel();
            nomalPanel.addEventListener(Event.CLOSE,updateNormalCloseHandler);
         }
         nomalPanel.setInfo(_newInfo,_oldInfo);
         DisplayUtil.align(nomalPanel,null,AlignType.MIDDLE_CENTER);
         MainManager.getStage().addChild(nomalPanel);
      }
      
      private static function updateNormalWithAdd() : void
      {
         if(!addPanel)
         {
            addPanel = new UpdateNomalWithAddPanel();
            addPanel.addEventListener(Event.CLOSE,updateNormalCloseHandler);
         }
         addPanel.setInfo(_newInfo,_oldInfo);
         DisplayUtil.align(addPanel,null,AlignType.MIDDLE_CENTER);
         MainManager.getStage().addChild(addPanel);
      }
      
      private static function updateLevelCloseHandler(event:Event) : void
      {
         if(_fun != null)
         {
            _fun();
         }
      }
      
      private static function updateNormalCloseHandler(event:Event) : void
      {
         if(_fun != null)
         {
            _fun();
         }
      }
   }
}


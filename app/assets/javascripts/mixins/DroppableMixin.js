Hummingbird.DroppableMixin = Em.Mixin.create(JQ.Widget, {
    uiType: 'droppable',
    uiOptions: ['accept', 'activeClass', 'addClasses', 'disabled',
              'greedy', 'hoverClass', 'scope', 'tolerance'],
    uiEvents: ['activate', 'create', 'deactivate', 'drop', 'out', 'over'],

    //Pagevault business logic

    hoverClass: 'dragValidTarget',
    //activeClass: 'dragHover',
    greedy: true,
    tolerance: 'pointer',
    addClasses: false,

    over: function() {
        this.$().children().addClass("disablePointerEvents");
    },

    out:function(){
        this.$().children().removeClass("disablePointerEvents");
    },

    drop: function(event, ui) {
        if (ui) {
          var modelId = $(ui.draggable.context).data('modelId');
          var dataType = $(ui.draggable.context).data('dataType');

          //no model ID breaks behavior
          if(!modelId){
            throw("model has no id");
          }

          if (dataType == "snapshot")
            var model = App.Snapshot.find(modelId);
          else if (dataType == "folder")
            var model = App.Folder.find(modelId);

          this.moveItem(model, dataType, modelId);
          //make sure the disablePointerEvents is removed
          this.$().children().removeClass("disablePointerEvents");
        }
    },

    moveItem: function(model, dataType, Id) {
        var targetfolder = this.get('folder.content')
          || this.get('folder');

        //no target folder, no dice
        if (!targetfolder) { return ;}

        if(dataType == "snapshot") {
          var oldFolder = model.get('folder');
          model.set('folder', targetfolder);
          model.save();
          targetfolder.get('snapshots').pushObject(model);
          targetfolder.save();
          oldFolder.get('snapshots').removeObject(model);
          App.CurrentSnapshots.removeObject(model);
          oldFolder.save();
        }
        else if (dataType == "folder") {
          var oldFolder = model.get('parentFolder');
          if (this.validFolderMove(model, oldFolder, targetfolder)) {
            model.set('parentFolder',targetfolder);
            model.save();
            targetfolder.get('folders').pushObject(model);
            targetfolder.save();
            if(oldFolder) {
              oldFolder.get('folders').removeObject(model);
              oldFolder.save();
            }            
          }
        }
    },

    validFolderMove: function(model, oldFolder, targetfolder) {
      if (!oldFolder) {
        App.HeaderMessage('The root folder cannot be moved.', 5000);
        return false;
      }
      if(oldFolder.get('id') == targetfolder.get('id')) {
        App.HeaderMessage('Same parent folder - nothing changed.', 5000);
        return false;
      }

      if(targetfolder.get('id') == model.get('id')) {
        App.HeaderMessage('Cannot make a folder a child of itself.', 5000);
        return false;
      }

      var thisId = model.get('id');
      var ancestors = this.folderAncestors(targetfolder);
      console.log(thisId, ancestors);
      if (App.indexOf.call(ancestors, thisId) > -1) {
        App.HeaderMessage('Cannot make folder a child of its own descendant.', 5000);
        return false;
      }


      return true;
    },

    folderAncestors: function(folder) {
      var ancestors = [];
      var currentParent = folder.get('parentFolder');
      while(currentParent != null) {
        ancestors.push(currentParent.get('id'));
        currentParent = currentParent.get('parentFolder');
      }

      return ancestors;
    }
});

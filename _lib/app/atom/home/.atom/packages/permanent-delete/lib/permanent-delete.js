'use babel';
import fs from 'fs-plus';

var config = {
  confirmDelete: {
    description: 'Confirm dialog before deleting files',
    type: 'boolean',
    default: true
  }
};

var disposable;

function activate() {
  disposable = atom.commands.add('atom-workspace', 'permanent-delete:delete', deleteCommand);
}

function deactivate() {
  disposable.dispose();
  disposable = null;
}

function deleteCommand() {
  var treeView = atom.packages.getActivePackage('tree-view');
  if(!treeView) return;
  treeView = treeView.mainModule.getTreeViewInstance();
  selectedPaths = treeView.selectedPaths();
  if(atom.config.get('permanent-delete.confirmDelete')) {
    atom.confirm({
      message: `Are you sure you want to delete the selected ${selectedPaths > 1 ? 'items' : 'item'}?`,
      detailedMessage: `You are deleting: \n${selectedPaths.join('\n')}`,
      buttons:{
        'Delete permanently': function() {
          deletePaths(selectedPaths);
        },
        'Cancel': null
      }
    });
  } else {
    deletePaths(selectedPaths);
  }
}

function deletePaths(paths) {
  for(let path of paths) {
    fs.remove(path, function(){});
  }
}

export {config, activate, deactivate};

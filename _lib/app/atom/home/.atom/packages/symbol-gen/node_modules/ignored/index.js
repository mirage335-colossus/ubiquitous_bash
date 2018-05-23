var fs   = require('fs');
var path = require('path');

/**
 * sync is our synchronous fallback. it returns a List of entries given a
 * .gitignore file to parse. Requires one parameter:
 * @param {string} gitignorefile - file descriptor e.g: ./.gitignore
 * Note: there is no Public interface for this method! it gets called
 * when no callback is supplied to ignored method (see below).
 * returs an error Object if an error occurs.
 */
function sync(gitignorefile) {
  var list = [];
  try {  // first check file actually exists
    var stats = fs.lstatSync(gitignorefile);
    if (stats.isFile()) { // if its not a valid file return an error
      var str = fs.readFileSync(gitignorefile, 'utf8');
      var lines = str.split('\n');
      lines.forEach(function(line) {
        line = line.trim();
        if(line.charAt(0) === '#' || line.length === 0) {
          // ignore comment and empty lines
        }
        else {
          list.push(line);
        }
      });
      return list;
    }
    else {
      return { msg : 'ERROR: Bad .gitignore file!', code:'ENOENT' };
    }
  }
  catch (e) {
      return e;
  }
}

/**
 * ignored returns a List of entries given a .gitignore file to parse.
 * accepts two (optional) parameters:
 * @param {string} gitignorefile (Optional)- file descriptor e.g: ./.gitignore
 * @param {function} callback (Optional)- called once we have a list of entries
 * (or if an error occurs). Your callback should have two arguments:
 *   @param {string} error - an error message or null if no errors.
 *   @param {array} list - a list of entries in the .gitignore
 * Note: if gitignorefile is not supplied we attempt to find it by going
 * up the directory tree. If we still cannot find it, we return an error!
 */
module.exports = function ignored(gitignorefile, callback) {
  // check if the method was called sync or asyn by checking for callback
  if(!callback || typeof callback !== 'function') {
    if(!gitignorefile) { // attempt to find .gitignore file in parent dir:
      gitignorefile = path.resolve("./.gitignore");
    } else {
      gitignorefile = path.resolve(gitignorefile);
    }
    // console.log("SYNC filename:"+gitignorefile);
    // console.log(' '); // blank line
    return sync(gitignorefile);
  }
  else { // the fact that callback exists tells us that gitignorefile is set!
    fs.stat(gitignorefile, function(err, stats){
      if(err) {
        callback(err, []);
      }
      else {
        if(!stats.isFile()) {
          var error = { msg : 'ERROR: Bad .gitignore file!', code:'ENOENT' }
          callback(error, []);
        } else {
          fs.readFile(gitignorefile, 'utf8', function gotfile(err, str) {
            var list = [];
            var lines = str.split('\n');
            lines.forEach(function(line) {
              line = line.trim();
              if(line.charAt(0) === '#' || line.length === 0) {
                // ignore comment and empty lines
              }
              else {
                list.push(line);
              }
            });
            callback(null, list);
          }); // end fs.readFile
        }
      }
    }); // end fs.stat
  }
}

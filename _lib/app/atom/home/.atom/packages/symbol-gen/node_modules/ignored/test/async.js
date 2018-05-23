var test  = require('tape');
var chalk = require('chalk');
var red   = chalk.red, green = chalk.green, cyan = chalk.cyan;
var path  = require('path');

test(cyan('ASYNC: supplying BAD .gitignore file'), function (t) {
  var ignored = require('../'); // use the module's method asynchronously
  var gitignorefile = path.resolve('../.gitignore');
  ignored(gitignorefile, function(err, list) {
    t.equal(err.code, 'ENOENT', green("✓ "+red(gitignorefile) + " is NOT valid."));
    t.end();
  });
});

test(cyan('ASYNC: with VALID .gitignore file'), function (t) {
  var ignored = require('../'); // use the module's method asynchronously
  var gitignorefile = path.resolve('./.gitignore');
  ignored(gitignorefile, function(err, list) {
    t.equal(err, null, green("✓ got "+cyan(list.length) + " items in "+gitignorefile));
    t.end();
  });
});

test(cyan('ASYNC: supplying a DIRECTORY instead of a .gitignore file'), function (t) {
  var ignored = require('../'); // use the module's method asynchronously
  var gitignorefile = path.resolve('./test');
  var errmsg = "ERROR: Bad .gitignore file!"
  ignored(gitignorefile, function(err, list) {
    t.equal(err.msg, errmsg, green("✓ "+red(gitignorefile) + " is NOT valid."));
    t.end();
  });
});

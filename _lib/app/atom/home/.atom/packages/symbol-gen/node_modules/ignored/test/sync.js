var test  = require('tape');
var chalk = require('chalk');
var red   = chalk.red, green = chalk.green, cyan = chalk.cyan;
var path  = require('path');

test(cyan('SYNC: no .gitignore file passed as param'), function (t) {
  var ignored = require('../')(); // no .gitignore file supplied, we attempt to find one!
  // console.log(ignored.length);
  t.equal(ignored.length, 12, green("✓ SYNC call without params returns "+ ignored.length +" items."));
  t.end();
});

test(cyan('SYNC: with sample .gitignore file'), function (t) {
  var ignored = require('../')('test/Node.gitignore.txt'); // sample node .gitignore: http://git.io/jLYB
  // console.log(ignored.length);
  t.equal(ignored.length, 11, green("✓ SYNC call without params returns "+ ignored.length +" items."));
  t.end();
});

test(cyan('SYNC: .gitignore file in parent of CWD (usage example in README)'), function (t) {
  var ignored = require('../')(__dirname+'/../.gitignore');
  // console.log(ignored);
  t.equal(ignored.length, 12, green("✓ SYNC call without params returns "+ ignored.length +" items."));
  t.end();
});

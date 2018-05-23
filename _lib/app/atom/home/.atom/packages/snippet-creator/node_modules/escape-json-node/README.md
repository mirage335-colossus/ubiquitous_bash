![escape-json-node Logo][logo]

Escape nested double quotes and unescape apostrophes within JSON string.

[![NPM Package Version][npm-package-version-badge]][npm-package-url]
[![NPM Package License][npm-package-license-badge]][npm-package-license-url]
[![NPM Package Downloads][npm-package-downloads-badge]][npm-package-url]
[![devDependencies Status][devDependencies-status-badge]][devDependencies-status-page-url]

[![Node Version][node-version-badge]][node-downloads-page-url]
[![Travis CI Build Status][travis-ci-build-status-badge]][travis-ci-build-status-page-url]
[![Code Climate Status][code-climate-status-badge]][code-climate-status-page-url]
[![Code Climate Test Coverage Status][code-climate-test-coverage-status-badge]][code-climate-test-coverage-status-page-url]
[![Inch CI Documentation Coverage Status][inch-ci-documentation-coverage-status-badge]][inch-ci-documentation-coverage-status-page-url]

[![NPM Package Statistics][npm-package-statistics-badge]][npm-package-url]

## Installation

`npm install escape-json-node`

## Usage Example

```javascript
var escapeJSON = require('escape-json-node');

var JSONString = '{"quoteText": "\'Acceptance says, "True, this is ' +
'my situation at the moment. I\'ll look unblinkingly at the reality of it. ' +
'But I will also open my hands to accept willingly whatever a loving ' +
'Father sends me.""}';

JSONString = escapeJSON(JSONString);

console.log(JSONString);
```

***

```json
{"quoteText": "'Acceptance says, \"True, this is my situation at the moment. 
I'll look unblinkingly at the reality of it. But I will also open my 
hands to accept willingly whatever a loving Father sends me.\""}
```

## Tests

To run the test suite, first install the dependencies, then run `npm test`:

```bash
$ npm install
$ npm test
```

## License

Distributed under the [MIT License](LICENSE).

[logo]: https://cldup.com/EwVD6pZerW.png

[npm-package-url]: https://npmjs.org/package/escape-json-node

[npm-package-version-badge]: https://img.shields.io/npm/v/escape-json-node.svg?style=flat-square

[npm-package-license-badge]: https://img.shields.io/npm/l/escape-json-node.svg?style=flat-square
[npm-package-license-url]: http://opensource.org/licenses/MIT

[npm-package-downloads-badge]: https://img.shields.io/npm/dm/escape-json-node.svg?style=flat-square

[devDependencies-status-badge]: https://david-dm.org/AnatoliyGatt/escape-json-node/dev-status.svg?style=flat-square
[devDependencies-status-page-url]: https://david-dm.org/AnatoliyGatt/escape-json-node#info=devDependencies

[node-version-badge]: https://img.shields.io/node/v/escape-json-node.svg?style=flat-square
[node-downloads-page-url]: https://nodejs.org/en/download/

[travis-ci-build-status-badge]: https://img.shields.io/travis/AnatoliyGatt/escape-json-node.svg?style=flat-square
[travis-ci-build-status-page-url]: https://travis-ci.org/AnatoliyGatt/escape-json-node

[code-climate-status-badge]: https://img.shields.io/codeclimate/github/AnatoliyGatt/escape-json-node.svg?style=flat-square
[code-climate-status-page-url]: https://codeclimate.com/github/AnatoliyGatt/escape-json-node

[code-climate-test-coverage-status-badge]: https://img.shields.io/codeclimate/coverage/github/AnatoliyGatt/escape-json-node.svg?style=flat-square
[code-climate-test-coverage-status-page-url]: https://codeclimate.com/github/AnatoliyGatt/escape-json-node/coverage

[inch-ci-documentation-coverage-status-badge]: https://inch-ci.org/github/AnatoliyGatt/escape-json-node.svg?style=flat-square
[inch-ci-documentation-coverage-status-page-url]: https://inch-ci.org/github/AnatoliyGatt/escape-json-node

[npm-package-statistics-badge]: https://nodei.co/npm/escape-json-node.png?downloads=true&downloadRank=true&stars=true

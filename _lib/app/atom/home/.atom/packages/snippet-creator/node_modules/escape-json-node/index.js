/**
 * @module index
 * @description Entry point for escape-json-node module.
 * @version 1.0.8
 * @author Anatoliy Gatt [anatoliy.gatt@aol.com]
 * @copyright Copyright (c) 2015-2016 Anatoliy Gatt
 * @license MIT
 */

'use strict';

/**
 * @public
 * @description Expose function to escape nested double quotes and unescape apostrophes within JSON string.
 * @returns {Function} - Function to escape nested double quotes and unescape apostrophes within JSON string.
 */

module.exports = require('./lib/escape-json');

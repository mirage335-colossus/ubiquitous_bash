/**
 * @module escape-json
 * @description Provides function to escape nested double quotes and unescape apostrophes within JSON string.
 * @version 1.0.8
 * @author Anatoliy Gatt [anatoliy.gatt@aol.com]
 * @copyright Copyright (c) 2015-2016 Anatoliy Gatt
 * @license MIT
 */

'use strict';

/**
 * @public
 * @function escapeJSON
 * @description Escape nested double quotes and unescape apostrophes within JSON strings.
 * @param {String} string - JSON string with unescaped nested double quotes and escaped apostrophes.
 * @returns {String} - Escaped JSON string.
 */

function escapeJSON(string) {
    if (string) {
        string = string.replace(new RegExp('\\\''.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, '\\$1'), 'g'), '\'');
        string = string.replace(/"((?:"[^"]*"|[^"])*?)"(?=[:},])(?=(?:"[^"]*"|[^"])*$)/gm, function (match, group) {
            return '"' + group.replace(/"/g, '\\"') + '"';
        });
    }
    return string;
}

/**
 * @public
 * @description Expose function to escape nested double quotes and unescape apostrophes within JSON string.
 * @param {String} string - JSON string with unescaped nested double quotes and escaped apostrophes.
 * @returns {String} - Escaped JSON string.
 */

module.exports = function (string) {
    return escapeJSON(string);
};

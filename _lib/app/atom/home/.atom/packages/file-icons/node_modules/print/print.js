"use strict";

/**
 * Generate a human-readable representation of a value.
 *
 * @param {Mixed}   input                 - Value to print
 * @param {Object}  opts                  - Optional parameters
 * @param {Boolean} opts.ampedSymbols     - Prefix Symbol-keyed properties with @@
 * @param {Mixed}   opts.escapeChars      - Which characters to escape in string values
 * @param {Boolean} opts.invokeGetters    - Show the values of properties defined by getter functions
 * @param {Number}  opts.maxArrayLength   - Maximum number of array values to show before truncating
 * @param {Boolean} opts.showAll          - Display non-enumerable properties
 * @param {Boolean} opts.showArrayIndices - Show the index of each element in an array
 * @param {Boolean} opts.showArrayLength  - Display an array's "length" property after its values
 * @param {Boolean} opts.sortProps        - Alphabetise the properties of printed objects
 * @return {String}
 */
function print(input, opts = {}, /* …Internal:*/ name = "", refs = null){
	
	// Handle options and defaults
	let {
		ampedSymbols,
		escapeChars,
		invokeGetters,
		maxArrayLength,
		showAll,
		showArrayIndices,
		showArrayLength,
		sortProps,
	} = opts;
	
	ampedSymbols   = undefined === ampedSymbols   ? true : ampedSymbols;
	escapeChars    = undefined === escapeChars    ? /(?!\x20)\s|\\/g : escapeChars;
	sortProps      = undefined === sortProps      ? true  : sortProps;
	maxArrayLength = undefined === maxArrayLength ? 100   : (!+maxArrayLength ? false : maxArrayLength);

	if(escapeChars && "function" !== typeof escapeChars)
		escapeChars = (function(pattern){
			return function(input){
				return input.replace(pattern, function(char){
					switch(char){
						case "\f": return "\\f";
						case "\n": return "\\n";
						case "\r": return "\\r";
						case "\t": return "\\t";
						case "\v": return "\\v";
						case "\\": return "\\\\";
					}
					const cp  = char.codePointAt(0);
					const hex = cp.toString(16).toUpperCase();
					if(cp < 0xFF) return "\\x" + hex;
					return "\\u{" + hex + "}";
				});
			};
		}(escapeChars));
	
	
	// Only thing that can't be checked with obvious methods
	if(Number.isNaN(input)) return "NaN";
	
	// Exact match
	switch(input){
		
		// Primitives
		case null:      return "null";
		case undefined: return "undefined";
		case true:      return "true";
		case false:     return "false";
		
		// "Special" values
		case Math.E:                   return "Math.E";
		case Math.LN10:                return "Math.LN10";
		case Math.LN2:                 return "Math.LN2";
		case Math.LOG10E:              return "Math.LOG10E";
		case Math.LOG2E:               return "Math.LOG2E";
		case Math.PI:                  return "Math.PI";
		case Math.SQRT1_2:             return "Math.SQRT1_2";
		case Math.SQRT2:               return "Math.SQRT2";
		
		case Number.EPSILON:           return "Number.EPSILON";
		case Number.MIN_VALUE:         return "Number.MIN_VALUE";
		case Number.MAX_VALUE:         return "Number.MAX_VALUE";
		case Number.MIN_SAFE_INTEGER:  return "Number.MIN_SAFE_INTEGER";
		case Number.MAX_SAFE_INTEGER:  return "Number.MAX_SAFE_INTEGER";
		case Number.NEGATIVE_INFINITY: return "Number.NEGATIVE_INFINITY";
		case Number.POSITIVE_INFINITY: return "Number.POSITIVE_INFINITY";
	}
	
	// Basic data types
	const type = Object.prototype.toString.call(input);
	switch(type){
		case "[object Number]":
			if("number" !== typeof input) break;
			return input.toString();
		
		case "[object Symbol]":
			if("symbol" !== typeof input) break;
			return input.toString();
		
		case "[object String]":
			if("string" !== typeof input) break;
			if(escapeChars)
				input = escapeChars(input);
			return `"${input}"`;
	}
	
	// Guard against circular references
	refs = refs || new Map();
	if(refs.has(input))
		return "-> " + (refs.get(input) || "{input}");
	refs.set(input, name);
	
	
	// Begin compiling some serious output
	let output = "";
	let typeName = "";
	
	let arrayLike;
	let isFunc;
	let ignoreNumbers;
	let padBeforeProps;

	// Resolve which properties get displayed in the output
	const descriptors = [
		...Object.getOwnPropertyNames(input),
		...Object.getOwnPropertySymbols(input),
	].map(key => [key, Object.getOwnPropertyDescriptor(input, key)]);
	
	let normalKeys = [];
	let symbolKeys = [];
	for(const [key, descriptor] of descriptors){
		const {enumerable, get, set} = descriptor;
		
		// Skip non-enumerable properties
		if(!showAll && !enumerable) continue;
		
		if(!get && !set || invokeGetters && get)
			"symbol" === typeof key
				? symbolKeys.push(key)
				: normalKeys.push(key);
	}
	
	
	// Maps
	if("[object Map]" === type){
		typeName = "Map";
		
		if(input.size){
			padBeforeProps = true;
			
			let index = 0;
			for(let [key, value] of input.entries()){
				const namePrefix  = (name ? name : "Map") + ".entries";
				const keyString   = `${index}.key`;
				const valueString = `${index}.value`;
				
				key   = print(key,   opts, `${namePrefix}[${keyString}]`,   refs);
				value = print(value, opts, `${namePrefix}[${valueString}]`, refs);
				
				output += keyString   + (/^->\s/.test(key)   ? " " : " => ") + key   + "\n";
				output += valueString + (/^->\s/.test(value) ? " " : " => ") + value + "\n\n";
				++index;
			}
			
			output = "\n" + output.replace(/\s+$/, "");
		}
	}
	
	
	// Sets
	else if("[object Set]" === type){
		typeName = "Set";
		
		if(input.size){
			padBeforeProps = true;
			
			let index  = 0;
			for(let value of input.values()){
				const valueName = (name ? name : "{input}") + ".entries[" + index + "]";
				value = print(value, opts, valueName, refs);
				
				const delim = /^->\s/.test(value) ? " " : " => ";
				output += index + delim + value + "\n";
				++index;
			}
			
			output = "\n" + output.replace(/\s+$/, "");
		}
	}
	
	
	// Dates
	else if(input instanceof Date){
		typeName = "Date";
		padBeforeProps = true;
		
		if("Invalid Date" === input.toString())
			output = "\nInvalid Date";
		
		else{
			output = "\n" + input.toISOString()
				.replace(/T/, " ")
				.replace(/\.?0*Z$/m, " GMT")
				+ "\n";
			
			let delta  = Date.now() - input.getTime();
			let future = delta < 0;
			
			const units = [
				[1000,  "second"],
				[60000, "minute"],
				[3600000, "hour"],
				[86400000, "day"],
				[2628e6, "month"],
				[31536e6, "year"],
			];
			
			delta = Math.abs(delta);
			for(let i = 0, l = units.length; i < l; ++i){
				const nextUnit = units[i + 1];
				if(!nextUnit || delta < nextUnit[0]){
					let [value, name] = units[i];
					
					// Only bother with floating-point values if it's within the last week
					delta = (i > 0 && delta < 6048e5)
						? (delta / value).toFixed(1).replace(/\.?0+$/, "")
						: Math.round(delta / value);
					
					output += `${delta} ${name}`;
					if(delta != 1)
						output += "s";
					break;
				}
			}
			output += future ? " from now" : " ago";
		}
	}
	
	
	// Objects and functions
	else switch(type){
		
		// Number objects
		case "[object Number]":
			output = "\n" + print(Number.prototype.valueOf.call(input), opts);
			padBeforeProps = true;
			break;
		
		// String objects
		case "[object String]":
			output = "\n" + print(String.prototype.toString.call(input), opts);
			padBeforeProps = true;
			break;
		
		// Boolean objects
		case "[object Boolean]":
			output = "\n" + Boolean.prototype.toString.call(input);
			padBeforeProps = true;
			break;
		
		// Regular expressions
		case "[object RegExp]":{
			const {lastIndex, source, flags} = input;
			output = `/${source}/${flags}`;
			
			// Return early if RegExp isn't subclassed and has no unusual properties
			if(RegExp === input.constructor && 0 === lastIndex && 0 === normalKeys.length)
				return output;
			
			else{
				output = "\n" + output;
				padBeforeProps = true;
				if(0 !== lastIndex)
					normalKeys.push("lastIndex");
			}
			break;
		}
		
		// Anything else
		default:
			arrayLike     = "function" === typeof input[Symbol.iterator];
			isFunc        = "function" === typeof input;
			ignoreNumbers = !showArrayIndices && arrayLike;
	}
	
	
	// Functions: Include name and arity
	if(isFunc){
		if(-1 === normalKeys.indexOf("name"))    normalKeys.push("name");
		if(-1 === normalKeys.indexOf("length"))  normalKeys.push("length");
	}
	
	// Errors: Include name and message
	else if(input instanceof Error){
		if(-1 === normalKeys.indexOf("name"))    normalKeys.push("name");
		if(-1 === normalKeys.indexOf("message")) normalKeys.push("message");
	}
	
	// Arrays: Handle length property
	else if(arrayLike){
		const index = normalKeys.indexOf("length");
		if(showArrayLength && -1 === index)
			normalKeys.push("length");
		else if(!showArrayLength && -1 !== index)
			normalKeys.splice(index, 1);
	}
	

	// Clip lengthy arrays to a sensible limit
	let truncationNote = null;
	if(maxArrayLength !== false && arrayLike && input.length > maxArrayLength){
		normalKeys = normalKeys.filter(k => +k != k || +k < maxArrayLength);
		truncationNote = `\n\n… ${input.length - maxArrayLength} more values not shown\n`;
	}
	
	
	// Alphabetise each property name
	if(sortProps) normalKeys = normalKeys.sort((a, b) => {
		let A, B;
		
		// Numbers: Compare algebraically
		if(("0" == a || +a == a) && ("0" == b || +b == b)){
			A = +a;
			B = +b;
		}
		
		// Anything else: Convert to lowercase
		else{
			A = a.toLowerCase();
			B = b.toLowerCase();
		}
		
		if(A < B) return -1;
		if(A > B) return 1;
		return 0;
	});
	
	
	// Insert a blank line if existing lines have been printed for this object
	if(padBeforeProps && normalKeys.length)
		output += "\n";
	
	
	// Regular properties
	normalKeys = Array.from(new Set(normalKeys));
	for(let i = 0, l = normalKeys.length; i < l; ++i){
		let key = normalKeys[i];
		
		// Array's been truncated, and this is the first non-numeric key
		if(null !== truncationNote && +key != key){
			output  += truncationNote;
			truncationNote = null;
		}
		
		let accessor = /\W|^\d+$/.test(key) ? `[${key}]` : (name ? "."+key : key);
		let value    = print(input[key], opts, name + accessor, refs);
		output      += "\n";
		
		// Arrays: Check if each value's index should be omitted
		if(ignoreNumbers && /^\d+$/.test(key))
			output += value;
		
		// Name: Value
		else output += `${key}: ${value}`;
	}
	
	// If we still have a truncation notice, it means there were only numerics to list
	if(null !== truncationNote)
		output += truncationNote.replace(/\n+$/, "");
	
	
	// Properties keyed by Symbols
	symbolKeys = Array.from(new Set(symbolKeys));
	if(sortProps) symbolKeys = symbolKeys.sort((a, b) => {
		const A = a.toString().toLowerCase();
		const B = b.toString().toLowerCase();
		if(A < B) return -1;
		if(A > B) return 1;
		return 0;
	});
	
	for(let i = 0, l = symbolKeys.length; i < l; ++i){
		const symbol = symbolKeys[i];
		let accessor = symbol.toString();
		let valName  = "[" + accessor + "]";
		
		// Use a @@-prefixed form to represent Symbols in property lists
		if(ampedSymbols){
			accessor = "@@" + accessor.replace(/^Symbol\(|\)$/g, "");
			valName  = (name ? "." : "") + accessor;
		}
		
		const value = print(input[symbol], opts, name + valName, refs);
		output += `\n${accessor}: ${value}`;
	}
	
	
	// Tweak output based on the value's type
	if("[object Arguments]" === type)
		typeName = "Arguments";
	
	else{
		const ctr = input.constructor ? input.constructor.name : "";
		switch(ctr){
			
			case "AsyncGeneratorFunction":
				typeName = "async function*()";
				break;
			
			case "AsyncFunction":
				typeName = "async function()";
				break;
			
			case "GeneratorFunction":
				typeName = "function*()";
				break;
			
			case "Function":
				typeName = "function()";
				break;
			
			case "Array":
			case "Object":
				typeName = "";
				break;
			
			default:
				typeName = ctr;
				break;
		}
	}
	
	output = output ? output.replace(/\n/g, "\n\t") + "\n" : "";
	return typeName + (arrayLike
		? "[" + output + "]"
		: "{" + output + "}");
}

module.exports = print;


// Wrapper for console.log(print(…))
module.exports.out = function(...args){
	const output = print(...args);
	console.log(output);
	return output;
};

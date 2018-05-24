const defaultOptions = {
	rejectOnError: true,
	alwaysReturnArray: false,
	callbackArg: -1,
};

const promisificator = (cb, options) => {
	let promise, callback, undef;
	switch (typeof cb) {
	case "object":
	/* eslint-disable no-param-reassign */
		options = cb;
		cb = undef;
		/* eslint-enable no-param-reassign */
		// fallthrough
	case "undefined":
		const opts = Object.assign({}, defaultOptions, options);
		promise = new Promise((resolve, reject) => {
			callback = function (...args) {
				if (opts.rejectOnError) {
					if (args[0]) {
						reject(args[0]);
					} else if (args.length <= 2 && !opts.alwaysReturnArray) {
						resolve(args[1]);
					} else {
						resolve(args.slice(1));
					}
				} else {
					if (args.length <= 1 && !opts.alwaysReturnArray) {
						resolve(args[0]);
					} else {
						resolve(args);
					}
				}
			};
		});
		break;
	case "function":
		callback = function (...args) {
			process.nextTick(cb, ...args);
		};
		break;
	default:
		throw new Error("Invalid argument for callback");
	}

	return {
		promise,
		callback,
	};
};

promisificator.promisify = function (func, options) {
	const opts = Object.assign({}, defaultOptions, options);
	let cbArg = parseInt(opts.callbackArg, 10);
	if (isNaN(cbArg)) {
		throw new Error("Invalid value for callbackArg");
	} else if (func.length > 0 && cbArg < 0) {
		if (-cbArg <= func.length) {
			cbArg = func.length + cbArg;
		}
	}
	return function (...args) {
		const {promise, callback} = promisificator(options);
		let undef;
		if (cbArg >= 0) {
			while (args.length < cbArg) {
				args.push(undef);
			}
			args[cbArg] = callback;
		} else {
			// func.length is most likely not correct
			// so we push callback on array at location -cbArg from end
			args[args.length + 1 + cbArg] = callback;
		}
		func(...args);
		return promise;
	};
};

module.exports = promisificator;

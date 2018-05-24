const promisificator = require("../src");
const {promisify} = promisificator;

describe("promisificator", function () {
	beforeEach(function () {
		this.passingFunc = (arg, cb) => {
			setTimeout(() => cb(null, arg), 1);
		};

		this.failingFunc = (arg, cb) => {
			setTimeout(() => cb(arg), 1);
		};
	});

	it("should resolve arg from promise", async function () {
		const {callback, promise} = promisificator();
		const arg = "arg";
		this.passingFunc(arg, callback);
		const value = await promise;
		expect(value).toBe(arg);
	});

	it("should reject arg from promise", async function () {
		const {callback, promise} = promisificator();
		const arg = "arg";
		this.failingFunc(arg, callback);
		let err;
		try {
			await promise;
		} catch (error) {
			err = error;
		}
		expect(err).toBe(arg);
	});

	it("should resolve arg if rejectOnError is false", async function () {
		const {callback, promise} = promisificator({rejectOnError: false});
		const arg = "arg";
		this.failingFunc(arg, callback);
		const value = await promise;
		expect(value).toBe(arg);
	});

	it("should resolve [arg] if alwaysReturnArray is true", async function () {
		const {callback, promise} = promisificator({alwaysReturnArray: true});
		const arg = "arg";
		this.passingFunc(arg, callback);
		const value = await promise;
		expect(value).toEqual([arg]);
	});

	it("should resolve [arg] if alwaysReturnArray is true and rejectOnError is false", async function () {
		const {callback, promise} = promisificator({rejectOnError: false, alwaysReturnArray: true});
		const arg = "arg";
		this.failingFunc(arg, callback);
		const value = await promise;
		expect(value).toEqual([arg]);
	});

	describe("promisify", function () {
		it("should resolve arg from promisify", async function () {
			const arg = "arg";
			const value = await promisify(this.passingFunc)(arg);
			expect(value).toBe(arg);
		});

		it("should reject arg from promisify", async function () {
			const arg = "arg";
			let err;
			try {
				await promisify(this.failingFunc)(arg);
			} catch (error) {
				err = error;
			}
			expect(err).toBe(arg);
		});

		it("should be able to reuse promisified function", async function () {
			const passingAsync = promisify(this.passingFunc);
			const failingAsync = promisify(this.failingFunc);
			let err;
			let value;

			value = await passingAsync(1);
			expect(value).toBe(1);

			try {
				await failingAsync(1);
			} catch (error) {
				err = error;
			}
			expect(err).toBe(1);

			value = await passingAsync(2);
			expect(value).toBe(2);

			try {
				await failingAsync(2);
			} catch (error) {
				err = error;
			}
			expect(err).toBe(2);
		});

		it("should resolve arg if rejectOnError is false", async function () {
			const arg = "arg";
			const value = await promisify(this.failingFunc, {rejectOnError: false})(arg);
			expect(value).toBe(arg);
		});

		it("should resolve [arg] if alwaysReturnArray is true", async function () {
			const arg = "arg";
			const value = await promisify(this.passingFunc, {alwaysReturnArray: true})(arg);
			expect(value).toEqual([arg]);
		});

		it("should resolve [arg] if alwaysReturnArray is true and rejectOnError is false", async function () {
			const arg = "arg";
			const value = await promisify(this.failingFunc, {rejectOnError: false, alwaysReturnArray: true})(arg);
			expect(value).toEqual([arg]);
		});

		describe("callbackArg option", function () {
			beforeEach(function () {
				this.middleCallback = (arg, cb, arg1) => {
					setTimeout(() => cb(null, arg, arg1), 1);
				};
				this.agumentsCallback = (...args) => {
					const cb = args.pop();
					setTimeout(() => cb(null, ...args), 1);
				};
			});

			it("should set the callback arg according to callbackArg", async function () {
				const arg = "arg";
				const arg1 = "arg1";
				const value = await promisify(this.middleCallback, {callbackArg: 1})(arg, null, arg1);
				expect(value).toEqual([arg, arg1]);
			});

			it("should set the callback arg according to negative callbackArg", async function () {
				const arg = "arg";
				const arg1 = "arg1";
				const value = await promisify(this.middleCallback, {callbackArg: -2})(arg, null, arg1);
				expect(value).toEqual([arg, arg1]);
			});

			it("should set the callback arg according to negative callbackArg", async function () {
				const arg = "arg";
				const arg1 = "arg1";
				const value = await promisify(this.agumentsCallback)(arg, arg1);
				expect(value).toEqual([arg, arg1]);
			});
		});
	});
});

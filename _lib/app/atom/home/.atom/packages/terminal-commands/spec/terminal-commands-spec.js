/** @babel */

import promisificator, { promisify } from "promisificator";
import fs from "fs";
import path from "path";
import temp from "temp";
import terminalCommands from "../lib/terminal-commands";
temp.track();

require("./toBeARegisteredCommand");

async function createConfig(configFolder, filename, contents) {
	const absolutePath = path.join(configFolder, filename);
	switch (path.extname(filename)) {
		case ".json":
			await promisify(fs.writeFile)(absolutePath, JSON.stringify(contents));
			break;
		case ".js":
		case ".coffee":
			await promisify(fs.writeFile)(absolutePath, `module.exports=${JSON.stringify(contents)}`);
			break;
		default:
		// do nothing
	}

	return absolutePath;
}

describe("terminal-commands", function () {
	beforeEach(async function () {
		this.configFolder = await promisify(temp.mkdir)("terminal-commands-");
		atom.project.setPaths([this.configFolder]);
		atom.config.set("terminal-commands.configFile", path.join(this.configFolder, "not-exist.json"));
		await atom.packages.activatePackage("terminal-commands");
	});
	afterEach(async function () {
		await promisify(temp.cleanup)();
	});

	describe("on activate", function () {
		it("should add terminal-commands:edit-config command", function () {
			expect("terminal-commands:edit-config").toBeARegisteredCommand();
		});

		it("should not watch the configFile if it does not exist", async function () {
			const unwatch = promisificator();
			terminalCommands.onUnwatch(unwatch.callback);
			await unwatch.promise;
		});

		it("should watch and load the configFile if it exists", async function () {
			await atom.packages.deactivatePackage("terminal-commands");
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.json", {}));
			const loaded = promisificator();
			const watching = promisificator();

			const terminalCommands = (await atom.packages.activatePackage("terminal-commands")).mainModule;
			terminalCommands.onLoaded(loaded.callback);
			terminalCommands.onWatching(watching.callback);
			await Promise.all([loaded.promise, watching.promise]);
		});
	});
	describe("json config", function () {
		it("should load a the config file", async function () {
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.json", {"test:json": "test json"}));

			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);
			await loaded.promise;

			expect("test:json").toBeARegisteredCommand();
		});
	});
	describe("js config", function () {
		it("should load a the config file", async function () {
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.js", {"test:js": "test js"}));

			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);
			await loaded.promise;

			expect("test:js").toBeARegisteredCommand();
		});
	});
	describe("coffee config", function () {
		it("should load a the config file", async function () {
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.coffee", {"test:coffee": "test coffee"}));

			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);
			await loaded.promise;

			expect("test:coffee").toBeARegisteredCommand();
		});
	});
	describe("configFile changed", function () {
		beforeEach(async function () {
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.json", {"test:json": "test json"}));

			const watching = promisificator();
			terminalCommands.onWatching(watching.callback);
			await watching.promise;
		});

		it("should load the new config on setting changed", async function () {
			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);

			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.js", {"test:js": "test js"}));

			await loaded.promise;

			expect("test:json").not.toBeARegisteredCommand();
			expect("test:js").toBeARegisteredCommand();
		});

		it("should reload the config when modified", async function () {
			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);

			await createConfig(this.configFolder, "terminal-commands.json", {"test:json2": "test json2"});

			await terminalCommands.isModified([{action: "modified"}]);
			await loaded.promise;

			expect("test:json").not.toBeARegisteredCommand();
			expect("test:json2").toBeARegisteredCommand();
		});

		it("should unwatch the config when deleted", async function () {
			const unwatch = promisificator();
			terminalCommands.onUnwatch(unwatch.callback);

			await promisify(fs.unlink)(path.join(this.configFolder, "terminal-commands.json"));

			try {
				await terminalCommands.isModified([{action: "deleted"}]);
			} catch (err) {
				// this should error
			}
			await unwatch.promise;

			expect("test:json").not.toBeARegisteredCommand();
		});
	});
	describe("editConfig", function () {
		it("should create and watch configFile if not exist", async function () {
			await terminalCommands.editConfig();

			await promisify(fs.access)(terminalCommands.configFile);
		});
		it("should open configFile if exists", async function () {
			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.js", {"test:js": "test js"}));

			spyOn(atom.workspace, "open");

			await terminalCommands.editConfig();

			expect(atom.workspace.open.calls.mostRecent().args[0]).toBe(terminalCommands.configFile);
		});
		it("should open configFile if not exists with defaultConfig.json text", async function () {
			spyOn(atom.workspace, "open");

			await terminalCommands.editConfig();

			expect(atom.workspace.open.calls.mostRecent().args[0]).toBe(terminalCommands.configFile);

			const configText = await promisify(fs.readFile)(terminalCommands.configFile, "utf8");
			const defaultText = await promisify(fs.readFile)(path.resolve(__dirname, "../lib/default-config.json"), "utf8");

			expect(configText).toBe(defaultText);
		});
	});
	describe("runCommands function", function () {
		beforeEach(async function () {
			const loaded = promisificator();
			terminalCommands.onLoaded(loaded.callback);

			atom.config.set("terminal-commands.configFile", await createConfig(this.configFolder, "terminal-commands.js", {
				"test:string": "test test",
				"test:array": ["test 1", "test 2"],
				"test:file": "test ${file}",
				"test:files": "test ${files}",
				"test:dir": "test ${dir}",
				"test:project": "test ${project}",
			}));

			terminalCommands.consumeRunInTerminal({
				run: jasmine.createSpy()
			});

			this.dir = path.join(this.configFolder, "testdir");

			this.files = [
				path.join(this.configFolder, "testdir", "test1.js"),
				path.join(this.configFolder, "testdir", "test2.js"),
			];

			spyOn(terminalCommands, "getPaths").and.returnValues(this.files);

			await loaded.promise;

			this.dispatch = promisificator();
			atom.commands.onDidDispatch(() => {
				this.dispatch.callback();
			});
		});

		it("should run a string", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:string");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith(["test test"]);
		});
		it("should run an array", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:array");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith(["test 1", "test 2"]);
		});
		it("should replace filesPlaceholder", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:file");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith([`test ${this.files[0]}`]);
		});
		it("should replace filePlaceholder", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:files");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith([`test ${this.files.join(" ")}`]);
		});
		it("should replace dirPlaceholder", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:dir");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith([`test ${this.dir}`]);
		});
		it("should replace projectPlaceholder", async function () {
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:project");

			await this.dispatch.promise;

			expect(terminalCommands.terminal.run).toHaveBeenCalledWith([`test ${this.configFolder}`]);
		});
		it("should error if no project to replace projectPlaceholder", async function () {
			atom.project.setPaths([]);
			spyOn(atom.notifications, "addError");
			atom.commands.dispatch(atom.views.getView(atom.workspace), "test:project");

			await this.dispatch.promise;

			expect(atom.notifications.addError).toHaveBeenCalled();
			expect(terminalCommands.terminal.run).not.toHaveBeenCalled();
		});
	});
	describe("terminal command objects", function () {
		beforeEach(function () {
			this.loadConfig = function (json) {
				spyOn(terminalCommands, "requireConfigFile").and.callFake(() => {
					terminalCommands.json = json;
				});
				terminalCommands.loadConfig();
			};

			spyOn(terminalCommands, "runCommands").and.returnValues(() => {});
		});

		it("should load a string as a command", function () {
			this.loadConfig({ "test:test": "test" });
			expect("test:test").toBeARegisteredCommand();
			expect(terminalCommands.runCommands).toHaveBeenCalledWith("test");
		});
		it("should load an array as a set of commands", function () {
			this.loadConfig({ "test:test": ["test1", "test2"] });
			expect("test:test").toBeARegisteredCommand();
			expect(terminalCommands.runCommands).toHaveBeenCalledWith(["test1", "test2"]);
		});
		it("should load an object with .commands", function () {
			this.loadConfig({ "test:test": { commands: "test" } });
			expect("test:test").toBeARegisteredCommand();
			expect(terminalCommands.runCommands).toHaveBeenCalledWith("test");
		});
		it("should load an object with .key", function () {
			this.loadConfig({ "test:test": { commands: "test", key: "alt-t" } });
			expect("test:test").toBeARegisteredCommand();
			expect("test:test").toBeARegisteredKeyBinding({ key: "alt-t" });
			expect(terminalCommands.runCommands).toHaveBeenCalledWith("test");
		});
		it("should load an object with .selector", function () {
			this.loadConfig({ "test:test": { commands: "test", key: "alt-t", selector: "body" } });
			expect("test:test").not.toBeARegisteredCommand();
			expect("test:test").toBeARegisteredCommand(document.body);
			expect("test:test").not.toBeARegisteredKeyBinding({ key: "alt-t" });
			expect("test:test").toBeARegisteredKeyBinding({ key: "alt-t", target: document.body });
			expect(terminalCommands.runCommands).toHaveBeenCalledWith("test");
		});
		it("should load an object with .priority", function () {
			this.loadConfig({ "test:test": { commands: "test", key: "alt-t", priority: 100 } });
			expect("test:test").toBeARegisteredCommand();
			expect("test:test").not.toBeARegisteredKeyBinding({ key: "alt-t" });
			expect("test:test").toBeARegisteredKeyBinding({ key: "alt-t", priority: 100 });
			expect(terminalCommands.runCommands).toHaveBeenCalledWith("test");
		});
	});
});

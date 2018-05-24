/** @babel */

import { CompositeDisposable, watchPath, Emitter } from "atom";
import fs from "fs-plus";
import path from "path";
import { promisify } from "promisificator";
import config from "./config";
import TerminalCommand from "./TerminalCommand";

export default {
	config,
	activate() {
		this.emitter = new Emitter();

		require("atom-package-deps").install("terminal-commands");

		this.subscriptions = new CompositeDisposable();

		this.subscriptions.add(atom.commands.add("atom-workspace", "terminal-commands:edit-config", this.editConfig.bind(this)));
		this.subscriptions.add(atom.commands.add("atom-workspace", "terminal-commands:load-config", async () => {
			if (await this.configExists()) {
				await this.watchConfig();
			} else {
				this.unwatchConfig();
				this.configError(`Cannot find '${this.configFile}'`);
			}
		}));

		this.subscriptions.add(atom.config.observe("terminal-commands.configFile", async (value) => {
			this.configFile = fs.absolute(value);

			if (await this.configExists()) {
				await this.watchConfig();
			} else {
				this.unwatchConfig();
			}
		}));

		this.subscriptions.add(atom.config.observe("terminal-commands.filesPlaceholder", (value) => {
			this.filesPlaceholder = new RegExp(this.escapeRegexp(value), "g");
		}));

		this.subscriptions.add(atom.config.observe("terminal-commands.filePlaceholder", (value) => {
			this.filePlaceholder = new RegExp(this.escapeRegexp(value), "g");
		}));

		this.subscriptions.add(atom.config.observe("terminal-commands.dirPlaceholder", (value) => {
			this.dirPlaceholder = new RegExp(this.escapeRegexp(value), "g");
		}));

		this.subscriptions.add(atom.config.observe("terminal-commands.projectPlaceholder", (value) => {
			this.projectPlaceholder = new RegExp(this.escapeRegexp(value), "g");
		}));

	},

	deactivate() {
		this.subscriptions.dispose();
		this.unwatchConfig();
		this.terminal = null;
		this.configFile = null;
	},

	onUnwatch(callback) {
		return this.emitter.on("unwatch", callback);
	},

	onWatching(callback) {
		return this.emitter.on("watching", callback);
	},

	onLoaded(callback) {
		return this.emitter.on("loaded", callback);
	},

	onModified(callback) {
		return this.emitter.on("modified", callback);
	},

	async createConfig() {
		try {
			const defaultConfig = await promisify(fs.readFile)(path.resolve(__dirname, "./default-config.json"));
			await promisify(fs.writeFile)(this.configFile, defaultConfig);
		} catch (err) {
			atom.notifications.addError("Cannot create config file", { description: err.message });
			throw err;
		}
	},

	async configExists() {
		try {
			await promisify(fs.access)(this.configFile);
			return true;
		} catch (err) {
			return false;
		}
	},

	async editConfig() {
		if (!(await this.configExists())) {
			await this.createConfig();
			this.watchConfig();
		}

		return atom.workspace.open(this.configFile, {searchAllPanes: true});
	},

	unwatchConfig() {
		if (this.configSubscriptions) {
			this.configSubscriptions.dispose();
			this.configSubscriptions = null;
		}
		if (this.commandSubscriptions) {
			this.commandSubscriptions.dispose();
			this.commandSubscriptions = null;
		}
		this.emitter.emit("unwatch");
	},

	async isModified(events) {
		this.emitter.emit("modified");
		const isModified = events.every(e => e.action === "modified");

		if (!isModified && !(await this.configExists())) {
			this.unwatchConfig();
		}
		this.loadConfig(this.configFile);
	},

	async watchConfig() {
		if (this.configSubscriptions) {
			this.configSubscriptions.dispose();
		}
		this.configSubscriptions = new CompositeDisposable();

		this.loadConfig();

		this.configSubscriptions.add(await watchPath(this.configFile, {}, this.isModified.bind(this)));

		this.emitter.emit("watching");
	},

	loadConfig() {
		if (this.commandSubscriptions) {
			this.commandSubscriptions.dispose();
		}
		this.commandSubscriptions = new CompositeDisposable();
		this.requireConfigFile();

		for (const command in this.json) {
			const terminalCommand = new TerminalCommand(this.json[command]);

			if (terminalCommand.key) {
				const keyBindings = {};
				keyBindings[terminalCommand.selector] = {};
				keyBindings[terminalCommand.selector][terminalCommand.key] = command;
				this.commandSubscriptions.add(atom.keymaps.add("terminal-commands", keyBindings, terminalCommand.priority));
			}
			this.commandSubscriptions.add(atom.commands.add(terminalCommand.selector, command, this.runCommands(terminalCommand.commands)));

			const contextItem = {};
			contextItem[terminalCommand.selector] = [{
				label: "Terminal Commands",
				submenu: [{label: command, command}]
			}];
			this.commandSubscriptions.add(atom.contextMenu.add(contextItem));
			this.commandSubscriptions.add(atom.menu.add([{
				label: "Packages",
				submenu: [{
					label: "Terminal Commands",
					submenu: [{label: command, command}]
				}]
			}]));
		}
		this.emitter.emit("loaded");
	},

	requireConfigFile() {
		this.json = null;

		try {
			this.json = require(this.configFile);
			delete require.cache[this.configFile];

			let relativeFilePath = path.relative(path.join(process.cwd(), "resources", "app", "static"), this.configFile);
			if (process.platform === "win32") {
				relativeFilePath = relativeFilePath.replace(/\\/g, "/");
			}
			delete snapshotResult.customRequire.cache[relativeFilePath];
		} catch (err) {
			this.configError(err.message);
			throw err;
		}
	},

	configError(message) {
		const notification = atom.notifications.addError(`Cannot load '${this.configFile}'`, {
			detail: message,
			dismissable: true,
			buttons: [{
				"onDidClick": () => {
					this.editConfig();
					notification.dismiss();
				},
				"text": "Edit Config"
			}]
		});
	},

	runCommands(commands) {
		let commandsArray = commands;
		if (!Array.isArray(commands)) {
			commandsArray = [commands];
		}

		return (e) => {
			const files = this.getPaths(e.target);
			const hasFiles = !!files[0];
			const dir = (hasFiles ? path.dirname(files[0]) : null);
			const [project] = (hasFiles ? atom.project.relativizePath(files[0]) : [null]);

			const errors = {};

			const error = (command, message) => {
				if (!errors[command]) {
					errors[command] = [];
				}
				errors[command].push(message);
			};

			const fullCommands = commandsArray.map(cmd => {
				let replacedCmd = cmd;
				if (this.filesPlaceholder) {
					if (!hasFiles && replacedCmd.match(this.filesPlaceholder)) {
						error(cmd, "No files found");
					} else {
						replacedCmd = replacedCmd.replace(this.filesPlaceholder, files.join(" "));
					}
				}
				if (this.filePlaceholder) {
					if (!hasFiles && replacedCmd.match(this.filePlaceholder)) {
						error(cmd, "No file found");
					} else {
						replacedCmd = replacedCmd.replace(this.filePlaceholder, files[0]);
					}
				}
				if (this.dirPlaceholder) {
					if (!dir && replacedCmd.match(this.dirPlaceholder)) {
						error(cmd, "No dir found");
					} else {
						replacedCmd = replacedCmd.replace(this.dirPlaceholder, dir);
					}
				}
				if (this.projectPlaceholder) {
					if (!project && replacedCmd.match(this.projectPlaceholder)) {
						error(cmd, "No project found");
					} else {
						replacedCmd = replacedCmd.replace(this.projectPlaceholder, project);
					}
				}
				return replacedCmd;
			});

			if (Object.keys(errors).length > 0) {
				let detail = "";
				for (const cmd in errors) {
					detail += `\n${cmd}:\n`;
					for (const err of errors[cmd]) {
						detail += `\t${err}\n`;
					}
				}
				console.error("Could not run commands", { detail });
				atom.notifications.addError("Could not run commands", { detail });
			} else if (this.terminal) {
				this.terminal.run(fullCommands);
			} else {
				atom.notifications.addError("No terminal loaded", { description: "Please install platformio-ide-terminal" });
			}
		};
	},

	escapeRegexp(s) {
		return s.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
	},

	/**
	 * Get the paths of the context target
	 * @param  {EventTarget} target The context target
	 * @return {string[]} The selected paths for the target
	 */
	getPaths(target) {
		if (!target) {
			return atom.project.getPaths();
		}

		const treeView = target.closest(".tree-view");
		if (treeView) {
			// called from treeview
			const selected = treeView.querySelectorAll(".selected > .list-item > .name, .selected > .name");
			if (selected.length > 0) {
				return [].map.call(selected, el => el.dataset.path);
			}
			return [];
		}

		const tab = target.closest(".tab-bar > .tab");
		if (tab) {
			// called from tab
			const title = tab.querySelector(".title");
			if (title && title.dataset.path) {
				return [title.dataset.path];
			}
			return [];
		}

		const textEditor = atom.workspace.getActivePaneItem();
		if (textEditor && typeof textEditor.getPath === "function") {
			// called from active pane
			return [textEditor.getPath()];
		}

		return [];
	},

	consumeRunInTerminal(terminal) {
		if (this.configFile) {
			this.terminal = terminal;
		}
	}
};

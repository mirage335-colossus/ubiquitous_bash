/** @babel */

export default class TerminalCommand {
	constructor(json) {
		let obj = json;

		if (!json.commands) {
			// convert string or array to commands object
			obj = { commands: json };
		}

		this.commands = obj.commands;
		this.selector = (obj.selector && obj.selector.toString()) || "atom-workspace";
		this.key = (obj.key && obj.key.toString()) || null;
		this.priority = parseInt(obj.priority, 10) || 0;
	}
}

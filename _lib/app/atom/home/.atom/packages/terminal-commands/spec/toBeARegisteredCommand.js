beforeEach(function () {
	jasmine.addMatchers({
		toBeARegisteredCommand: function () {
			return {
				compare: function (command, target) {
					const result = {};
					result.pass = atom.commands
						.findCommands({ target: target || atom.views.getView(atom.workspace) })
						.map(cmd => cmd.name)
						.includes(command);
					const not = (result.pass ? "not " : "");
					result.message = `Expected ${command} ${not}to be a registered command.`;
					return result;
				}
			};
		},
		toBeARegisteredKeyBinding: function () {
			return {
				compare: function (command, {key, target, priority = 0}) {
					const result = {};
					result.pass = atom.keymaps
						.findKeyBindings({ keystrokes: key, target: target || atom.views.getView(atom.workspace) })
						.filter(cmd => cmd.priority === priority)
						.map(cmd => cmd.command)
						.includes(command);
					const not = (result.pass ? "not " : "");
					result.message = `Expected ${command} ${not}to be a registered key binding.`;
					return result;
				}
			};
		},
	});
});

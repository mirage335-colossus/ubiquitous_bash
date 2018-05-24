/** @babel */

import path from "path";
import fs from "fs-plus";

export default {
	"configFile": {
		title: "Config File",
		description: "Must export a JSON object. Can end in '.coffee', '.json', '.js'",
		type: "string",
		default: path.join(fs.tildify(atom.getConfigDirPath()), "terminal-commands.json")
	},
	"dirPlaceholder": {
		title: "Directory Placeholder",
		description: "Replace this string with the first target path's directory.",
		type: "string",
		default: "${dir}"
	},
	"filesPlaceholder": {
		title: "Files Placeholder",
		description: "Replace this string with the target paths seperated by a space.",
		type: "string",
		default: "${files}"
	},
	"filePlaceholder": {
		title: "File Placeholder",
		description: "Replace this string with the first target path.",
		type: "string",
		default: "${file}"
	},
	"projectPlaceholder": {
		title: "Project Placeholder",
		description: "Replace this string with the first target path's project directory.",
		type: "string",
		default: "${project}"
	},
};

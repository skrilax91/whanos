// Run npm install befunge93
// To use this script


const Befunge = require('befunge93');
const fs = require('fs')
let befunge = new Befunge();
let fileToRead = process.stdin.fd;

befunge.onInput = (message) => {
	process.stdout.write(message);
	return fs.readFileSync(process.stdin.fd).toString();
};

befunge.onOutput = (output) => {
    process.stdout.write(output);
};

befunge.run(fs.readFileSync(fileToRead).toString());
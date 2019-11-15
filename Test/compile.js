const path = require('path');
const fs = require('fs');
const solc = require('solc');

const TeamManagementPath = path.resolve(__dirname, 'contracts', 'TeamManagement.sol');
const source = fs.readFileSync(TeamManagementPath, 'utf8');

module.exports = solc.compile(source, 1).contracts[':TeamManagement'];

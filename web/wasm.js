const consoleLog = (value) => console.log('consoleLog', value);

var wasm = {
    consoleLog,
    consoleLogF: consoleLog,
    consoleLogS: consoleLog,
}

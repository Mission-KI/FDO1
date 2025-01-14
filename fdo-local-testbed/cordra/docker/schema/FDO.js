exports.methods = {};
exports.methods.updateHandleRecord = updateHandleRecord;
const cordra = require("cordra");

function updateHandleRecord(object, context) {
    object.content.TMP = JSON.stringify(context.params);
    return object.content.name;
}

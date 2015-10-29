var Benchmark = require("benchmark");
var DisposableEmitter = require("../");

var de = new DisposableEmitter();

de.on("cycle", function () {});

new Benchmark("DisposableEmitter", function () {
    de.emit("cycle", "a");
    de.emit("cycle", "a", "b");
    de.emit("cycle", "a", "b", "c");
    de.emit("cycle", "a", "b", "c", "d");
    de.emit("cycle", "a", "b", "c", "d", "e");
    de.emit("cycle", "a", "b", "c", "d", "e", "f");
    de.emit("cycle", "a", "b", "c", "d", "e", "f", "g");
    de.emit("cycle", "a", "b", "c", "d", "e", "f", "g", "h");
})
.on("complete", function (e) {
    var bm = e.target;

    // console.log(bm);
    console.log(`
Benchmark ended.
    Cycles : ${bm.count}
    Elapsed : ${bm.times.elapsed} second.
    Mean time per cycle : ${bm.stats.mean}
`);
})
.run();

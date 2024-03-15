const fs = require("fs"),
  moment = require("moment");
exports.processData = (e, s) => {
  const o = fs.readFileSync("D:\\2024_February.txt", "utf8").split("\n"),
    t = [],
    r = [],
    n = "DD/MM/YYYY h:mm:ss A",
    a = ["20", "21", "22", "23", "00", "01", "02", "03", "04"],
    c = {};
  for (const e of o) {
    const s = e.trim();
    if ("" === s) continue;
    const o = s.split(": ")[0],
      i = moment(o, n).hour(),
      d =
        i >= 12
          ? moment(o, n).format("DD/MM/YYYY")
          : moment(o, n).subtract(1, "days").format("DD/MM/YYYY"),
      u = moment(o, n).format("HH");
    let l = "Other";
    if (s.includes("Access denied")) l = "Access denied";
    else {
      if (s.includes("Access granted")) {
        (l = "Access granted"),
          r.push(s),
          c[d]
            ? c[d].push({ time: u, accessType: l })
            : (c[d] = [{ time: u, accessType: l }]);
        continue;
      }
      s.includes("changed property") && (l = "Changed property");
    }
    const m = s.includes("Door")
      ? s.substring(s.indexOf("Door"), s.indexOf(" ", s.indexOf("Door")) + 3)
      : "N/A";
    t.push({
      originalDateTime: o,
      hourGreaterThan12: i >= 12,
      shiftDay: d,
      shiftHour: u,
      accessType: l,
      door: m,
    });
  }
  const i = t
      .filter(
        (e) =>
          !(
            ("Access denied" !== e.accessType || e.door.includes("40")) &&
            e.door.includes("41") &&
            e.door.includes("42") &&
            e.door.includes("43") &&
            e.door.includes("44") &&
            e.door.includes("45") &&
            e.door.includes("46") &&
            e.door.includes("47") &&
            e.door.includes("48") &&
            e.door.includes("49")
          )
      )
      .reduce(
        (e, s) => (
          e[s.shiftDay] || (e[s.shiftDay] = {}),
          e[s.shiftDay][s.shiftHour] ||
            (e[s.shiftDay][s.shiftHour] = { count: 0, doors: new Set() }),
          e[s.shiftDay][s.shiftHour].doors.has(s.door) ||
            (e[s.shiftDay][s.shiftHour].count++,
            e[s.shiftDay][s.shiftHour].doors.add(s.door)),
          e
        ),
        {}
      ),
    d = Object.keys(i).map((e, s) => {
      const o = new Date(e.split("/").reverse().join("-")).getDay(),
        t =
          0 === o || 6 === o
            ? a
            : ["21", "22", "23", "00", "01", "02", "03", "04"],
        r = 0 === o || 6 === o ? "Weekend" : "Weekday",
        n = [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
        ][o];
      let d = 0;
      for (const s of t) i[e] && i[e].hasOwnProperty(s) && d++;
      const u = t.filter((s) => !i[e].hasOwnProperty(s));
      return {
        id: s + 1,
        shiftDay: e,
        shiftCount: d,
        dayOfWeek: n,
        weekType: r,
        missingShift: u,
        missingShiftCount: u.length,
        ...Object.keys(i[e]).reduce(
          (s, o) => ("missingShift" !== o && (s[o] = i[e][o].count), s),
          {}
        ),
        underPerformance: [],
      };
    });
  for (const e of d)
    for (const s in e)
      "missingShift" !== s &&
        "underPerformance" !== s &&
        "shiftCount" !== s &&
        Number.isInteger(Number(s)) &&
        e[s] < 7 &&
        a.includes(s) &&
        e.underPerformance.push(s);
  s.json(d);
};

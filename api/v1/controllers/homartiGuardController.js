const fs = require("fs"),
  moment = require("moment");
exports.processData = (req, res) => {
  const data = fs.readFileSync("D:\\2024_January.txt", "utf8"),
    lines = data.split("\n"),
    results = [],
    format = "DD/MM/YYYY h:mm:ss A";
  for (const line of lines) {
    const parts = line.split(": "),
      originalDateTime = parts[0],
      hour = moment(originalDateTime, format).hour(),
      shiftDay =
        hour >= 12
          ? moment(originalDateTime, format).format("DD/MM/YYYY")
          : moment(originalDateTime, format)
              .subtract(1, "days")
              .format("DD/MM/YYYY"),
      shiftHour = moment(originalDateTime, format).format("HH");
    let accessType = "Other";
    if (line.includes("Access denied")) {
      accessType = "Access denied";
    } else if (line.includes("Access granted")) {
      accessType = "Access granted";
    } else if (line.includes("changed property")) {
      accessType = "Changed property";
    }
    const door = line.includes("Door")
      ? line.substring(
          line.indexOf("Door"),
          line.indexOf(" ", line.indexOf("Door")) + 3
        )
      : "N/A";
    results.push({
      originalDateTime,
      hourGreaterThan12: hour >= 12,
      shiftDay,
      shiftHour,
      accessType,
      door,
    });
  }
  const filteredData = results.filter(
      (item) =>
        (item.accessType === "Access denied" && !item.door.includes("40")) ||
        !item.door.includes("41") ||
        !item.door.includes("42") ||
        !item.door.includes("43") ||
        !item.door.includes("44") ||
        !item.door.includes("45") ||
        !item.door.includes("46") ||
        !item.door.includes("47") ||
        !item.door.includes("48") ||
        !item.door.includes("49")
    ),
    result = filteredData.reduce((acc, item) => {
      if (!acc[item.shiftDay]) {
        acc[item.shiftDay] = {};
      }
      if (!acc[item.shiftDay][item.shiftHour]) {
        acc[item.shiftDay][item.shiftHour] = { count: 0, doors: new Set() };
      }
      if (!acc[item.shiftDay][item.shiftHour].doors.has(item.door)) {
        acc[item.shiftDay][item.shiftHour].count++;
        acc[item.shiftDay][item.shiftHour].doors.add(item.door);
      }
      return acc;
    }, {}),
    resultArray = Object.keys(result).map((shiftDay) => {
      const date = new Date(shiftDay.split("/").reverse().join("-")),
        dayOfWeek = date.getDay(),
        shifts =
          dayOfWeek === 0 || dayOfWeek === 6
            ? ["20", "21", "22", "23", "00", "01", "02", "03", "04"]
            : ["21", "22", "23", "00", "01", "02", "03", "04"],
        weekType = dayOfWeek === 0 || dayOfWeek === 6 ? "Weekend" : "Weekday",
        dayNames = [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
        ],
        dayName = dayNames[dayOfWeek];
      let shiftCount = 0;
      for (const shift of shifts) {
        if (result[shiftDay] && result[shiftDay].hasOwnProperty(shift)) {
          shiftCount++;
        }
      }
      const missingShift = shifts.filter(
        (shift) => !result[shiftDay].hasOwnProperty(shift)
      );
      return {
        shiftDay,
        shiftCount,
        dayOfWeek: dayName,
        weekType,
        missingShift,
        missingShiftCount: missingShift.length,
        ...Object.keys(result[shiftDay]).reduce((acc, shiftHour) => {
          if (shiftHour !== "missingShift") {
            acc[shiftHour] = result[shiftDay][shiftHour].count;
          }
          return acc;
        }, {}),
        underPerformance: [],
      };
    });
  for (const item of resultArray) {
    for (const shiftHour in item) {
      if (
        shiftHour !== "missingShift" &&
        shiftHour !== "underPerformance" &&
        shiftHour !== "shiftCount" &&
        item[shiftHour] < 7
      ) {
        item.underPerformance.push(shiftHour);
      }
    }
  }
  res.json(resultArray);
};

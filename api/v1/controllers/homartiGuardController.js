const fs = require("fs");
const moment = require("moment");

exports.processData = (req, res) => {
  // Read the file
  const data = fs.readFileSync("D:\\2023_December.txt", "utf8");

  // Split the file into lines
  const lines = data.split("\n");

  // Create an empty array to store the objects
  const results = [];

  // Specify the format of the date string
  const format = "DD/MM/YYYY h:mm:ss A";

  // Loop through each line
  for (const line of lines) {
    // Split the line into parts
    const parts = line.split(": ");

    // Get the original date and time
    const originalDateTime = parts[0];

    // Get the hour
    const hour = moment(originalDateTime, format).hour();

    // Get the shift day
    const shiftDay =
      hour >= 12
        ? moment(originalDateTime, format).format("DD/MM/YYYY")
        : moment(originalDateTime, format)
            .subtract(1, "days")
            .format("DD/MM/YYYY");

    // Get the shift hour
    const shiftHour = moment(originalDateTime, format).format("HH");

    // Get the access type
    let accessType = "Other";
    if (line.includes("Access denied")) {
      accessType = "Access denied";
    } else if (line.includes("Access granted")) {
      accessType = "Access granted";
    } else if (line.includes("changed property")) {
      accessType = "Changed property";
    }

    // Get the door
    const door = line.includes("Door")
      ? line.substring(
          line.indexOf("Door"),
          line.indexOf(" ", line.indexOf("Door")) + 3
        )
      : "N/A";

    // Add the object to the results array
    results.push({
      originalDateTime,
      hourGreaterThan12: hour >= 12,
      shiftDay,
      shiftHour,
      accessType,
      door,
    });
  }

  // Send the results as the response
  res.json(results);
};

// exports.timeData = (req, res) => {
//   // Get the data from the request body
//   const data = req.body.timeData;
//   console.log(data);
//   // Filter the data based on the criteria
//   const filteredData = data.filter(
//     (item) =>
//       (item.accessType === "Access denied" && !item.door.includes("40")) ||
//       !item.door.includes("41") ||
//       !item.door.includes("42") ||
//       !item.door.includes("43") ||
//       !item.door.includes("44") ||
//       !item.door.includes("45") ||
//       !item.door.includes("46") ||
//       !item.door.includes("47") ||
//       !item.door.includes("48") ||
//       !item.door.includes("49")
//   );

//   // Group the shift hours by shift day
//   const groupedData = filteredData.reduce((acc, item) => {
//       if (!acc[item.shiftDay]) {
//           acc[item.shiftDay] = [];
//       }
//       acc[item.shiftDay].push(item.shiftHour);
//       return acc;
//   }, {});

//   const result = {};

//   for (const shiftDay in data) {
//     result[shiftDay] = data[shiftDay].reduce((acc, hour) => {
//       if (!acc[hour]) {
//         acc[hour] = 0;
//       }
//       acc[hour]++;
//       return acc;
//     }, {});
//   }

//   // Send the results as the response
//   res.json(groupedData);
// };


exports.timeData = (req, res) => {
    // Get the data from the request body
    const data = req.body.timeData;

    // Filter the data based on the criteria
    const filteredData = data.filter(item =>
        item.accessType === "Access denied" &&
        !item.door.includes("40") ||
        !item.door.includes("41") ||
        !item.door.includes("42") ||
        !item.door.includes("43") ||
        !item.door.includes("44") ||
        !item.door.includes("45") ||
        !item.door.includes("46") ||
        !item.door.includes("47") ||
        !item.door.includes("48") ||
        !item.door.includes("49")
    );

    // Group the shift hours by shift day and count them
    const result = filteredData.reduce((acc, item) => {
        if (!acc[item.shiftDay]) {
            acc[item.shiftDay] = {};
        }
        if (!acc[item.shiftDay][item.shiftHour]) {
            acc[item.shiftDay][item.shiftHour] = 0;
        }
        acc[item.shiftDay][item.shiftHour]++;
        return acc;
    }, {});

    // Define the shifts for weekdays and weekends
    const weekdayShifts = ["21", "22", "23", "00", "01", "02", "03", "04"];
    const weekendShifts = ["20", "21", "22", "23", "00", "01", "02", "03", "04"];

    // Add the "missingShift" key
    for (const shiftDay in result) {
        const date = new Date(shiftDay.split("/").reverse().join("-"));
        const dayOfWeek = date.getDay();
        const shifts = dayOfWeek === 0 || dayOfWeek === 6 ? weekendShifts : weekdayShifts;
        result[shiftDay].missingShift = shifts.filter(shift => !result[shiftDay].hasOwnProperty(shift));
    }

    // Send the results as the response
    res.json(result);
};

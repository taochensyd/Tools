exports.postReplicationHealth = (req, res) => {
    console.log(req.body);
    res.send('Data received successfully.');
};

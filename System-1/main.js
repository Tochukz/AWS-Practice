const { exec } = require('child_process');
const fs = require('fs-extra');
const path = require('path');
require('dotenv').config();

const { createVPC, createSubnet } = require('./src/commands');

const { CREATE_VPC, CREATE_SUBNETS } = process.env;

const red = "\x1b[31m" ;
const green = "\x1b[32m";
const yellow = "\x1b[33m";
const white = "\x1b[37m" ;

const theHour = `logs/${new Date().toISOString().substr(0, 13)}`;
fs.ensureDir(path.join(__dirname, theHour), (err) => {
    if (err) {
      console.info(red, err.message, white);
      return false;
    }

    if (CREATE_VPC.trim() == 'true') {
      console.info('::: Creating VPC...');
      const createVPCCmd = createVPC();
      console.info(createVPCCmd);
      exec(createVPCCmd, (error, stdout, stderr) => {
        if (error || stderr ) {
            console.info(red, error.message || stderr, white);
            return false;
        }
        writeToFile('vpc.json', stdout);
        console.log(stdout);

        if (CREATE_SUBNETS.trim() == 'true') {
          createSubnet();
        }
      });
    } else if(CREATE_SUBNETS.trim() == 'true') {
      createSubnet();
    }
});

function createSubnet() {
    console.info('::: Creating Subnets...');
  fs.readJson(path.join(__dirname, `${theHour}/vpc.json`))
    .then(data => {
       const vpcID = data.Vpc. VpcId;
       const createSubnetCmd  = createSubnet(vpcID);
       
    })
    .catch(err => {
       console.info(red, err.message, white);
    });
}

function writeToFile(filename, output) {
    fs.writeFileSync(path.join(__dirname, `${theHour}/${filename}`), output);
}


const express = require('express')
const app = express()
require('dotenv').config()

const {
    Client
} = require('pg')
const client = new Client({
    database: process.env.DATABASE_NAME,
    user: process.env.DATABASE_USERNAME,
    password: process.env.DATABASE_PASSWORD,
    port: process.env.DATABASE_PORT,
    host: process.env.DATABASE_HOST
})
client.connect()


app.get('/test', async function (req, res) {
    const query = 'SELECT * FROM employee';
    client.query(query, (err, resp) => {
        if (err) {
            console.log(err.stack)
        } else {
            console.log(resp.rows[0], 'data from table')
            res.send(resp.rows[0])
        }
    })
})

app.listen(5000);
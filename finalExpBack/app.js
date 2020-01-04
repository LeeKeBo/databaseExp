let express = require('express');
let logger = require('morgan')
var bodyParser = require('body-parser')

let {dbRouter} = require('./router/dbRouter');
var app = express();

app.use('/static',express.static('images'));

app.listen(3000,function(){
    console.log("server listen in 3000")
})

app.use(bodyParser.json());
app.use(logger('dev'))
app.use('/db',dbRouter)


app.get('/',function(req,res){
    res.send("Hello World");
})
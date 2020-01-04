let express = require('express');
let dbFunc = require('../dao/db');
let dbRouter = express.Router();

dbRouter.get('/getProducts', (req, res, next) => {
    let queryRes = {};
    dbFunc.getProducts().then(result => {
        queryRes.pro = result;
        return dbFunc.getCustomers();
    }).then((result) => {
        queryRes.cus = result;
        return dbFunc.getEmployees();
    }).then((result) => {
        queryRes.emp = result;
        res.send(queryRes)
    })
        .catch(error => {
            res.send("查询出错，请稍后再试")
        })
})

dbRouter.get('/getLogs', (req, res, next) => {
    dbFunc.getLogs().then(result => {
        res.send(result);
    }).catch(error => {
        res.send("查询出错，请稍后重试");
    })
})

dbRouter.get('/getPurchases', (req, res, next) => {
    dbFunc.getPurchases().then(result => {
        res.send(result);
    }).catch(error => {
        res.send("查询出错，请稍后重试")
    })
})

dbRouter.get('/getCustomers', (req, res, next) => {
    dbFunc.getCustomers().then(result => {
        res.send(result);
    }).catch(error => {
        res.send("查询出错，请稍后重试")
    })
})

dbRouter.get('/showProducts', (req, res, next) => {
    dbFunc.showProducts().then(result => {
        res.send(result);
    }).catch(error => {
        console.log(error)
        res.send("查询出错，请稍后重试")
    })
})

dbRouter.post('/buy', (req, res, next) => {
    console.log(req.body)
    let data = req.body;

    dbFunc.add_purchase(data.cid, data.eid, data.pid, data.qty)
        .then(result => {
            let returnObj = {};
            if (result.change) {
                returnObj = { change: true, before: result.before, after: result.after }
            }
            returnObj.result="插入成功";
            returnObj.code = 1;
            res.send(returnObj);
        }).catch(error => {
            if (error.over) {
                res.send({ code: -1, result: "库存不足" });
            }
            else {
                res.send({ code: -1, result: "插入失败，请稍后重试" })
            }
        })
})

dbRouter.get('/reportMonthlySale', (req, res, next) => {
    // console.log(req)
    let pid = req.query.pid;
    dbFunc.report_monthly_sale(pid).then(result => {
        res.send(result);
    }).catch(error => {
        res.send("查询失败，请稍后重试")
    })
})

module.exports = {
    dbRouter: dbRouter,
}




let $conn = require('../conf/conf')
let mysql = require('mysql');
let promisify = require('util').promisify;
// console.log($conn)
let pool = mysql.createPool($conn.mysql, (err) => {
    console.log("create pool error", err);
});

let getConn = promisify(pool.getConnection.bind(pool));
pool.query = promisify(pool.query);


let getProducts = function () {
    return new Promise((resolve, reject) => {
        // pool.query('select * from products').then(result => {
        pool.query('select * from products').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}

let getCustomers = function () {
    return new Promise((resolve, reject) => {
        pool.query('select * from customers').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}

let getEmployees = function () {
    return new Promise((resolve, reject) => {
        pool.query('select * from employees').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}

let getLogs = function () {
    return new Promise((resolve, reject) => {
        pool.query('select * from logs').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}

let getPurchases = function () {
    return new Promise((resolve, reject) => {
        pool.query('select * from purchases').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}


let showProducts = function () {
    return new Promise((resolve, reject) => {
        pool.query('call show_products()').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    });
};

let reportMonthlySale = function (prid) {
    return new Promise((resolve, reject) => {
        pool.query('call report_monthly_sale(\'' + prid + '\')').then(result => {
            resolve(result);
        }).catch(error => {
            reject(error);
        })
    })
}

let addPurchase = function (cid, eid, pid, qty) {
    return new Promise((resolve, reject) => {
        let queryStr = "call add_purchase(?,?,?,?,?)";
        let qoh_threshold = 0, qoh = 0;;
        pool.query("select qoh,qoh_threshold from products where pid=?", pid)
            .then(result => {
                // 超过库存
                console.log(result[0])
                if (qty > result[0].qoh) {
                    result.over = true;
                    reject(result);
                }
                else {
                    qoh_threshold = result[0].qoh_threshold;
                    qoh = result[0].qoh;
                    // 获取当前purNo
                    return pool.query("select pur from purchases order by pur desc limit 1")
                }
            }).then(result => {
                let pur = parseInt(result[0].pur) + 1
                return pool.query(queryStr, [pur, cid, eid, pid, qty])
            })
            .then(result => {
                return pool.query("select qoh from products where pid=?", pid)
            }).then(result => {
                if(result[0].qoh > qoh){
                    result.change = true;
                    result.before = qoh;
                    result.after = result[0].qoh;
                }
                resolve(result)
            }).catch(error => {
                reject(error);
            })
    })
};

module.exports = {
    getProducts: getProducts,
    getCustomers: getCustomers,
    getEmployees: getEmployees,
    getLogs: getLogs,
    getPurchases: getPurchases,
    showProducts: showProducts,
    report_monthly_sale: reportMonthlySale,
    add_purchase: addPurchase
}

// reportMonthlySale('pr00').then((result) => {
//     console.log("success:", result);
// })
//     .catch((err) => {
//         console.log("query: ", err);
//     })

// showProducts().then(function(result){
//     // pool.end();
//     console.log("result: ",result);
// }).catch(function(err){
//     console.log("error: ",err);
// })

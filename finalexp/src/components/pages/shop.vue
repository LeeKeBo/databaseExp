<template>
    <div id="main" v-bind:style="{ height: ScreenHeight+'px' } ">
        <span> 顾客身份： </span>
        <el-select v-model="customer" placeholder="顾客" default-first-option>
            <el-option
                    v-for="item in customers"
                    :key="item.cid"
                    :label="item.cname"
                    :value="item.cid">
            </el-option>
        </el-select>
        <span> 员工身份: </span>
        <el-select v-model="employee" placeholder="员工" style="margin-right: 300px" default-first-option>
            <el-option
                    v-for="item in employees"
                    :key="item.eid"
                    :label="item.ename"
                    :value="item.eid">
            </el-option>
        </el-select>
        <el-row v-for="i in rows" :key="i" class="row">
            <el-col :span="4" v-for="(o, index) in cols" :key="o" class="col">
                <div class="container" v-if="((i-1)*cols+index)<total">
                    <div style="margin-right: 2px">
                        <el-image :src="things[(i-1)*cols+index].pics"
                                  class="image"></el-image>
                    </div>

                    <div>
                        <div style="text-align: center;padding-top: 8px">
                            <div class="text"><strong>产品名: </strong><span>{{things[(i-1)*cols+index].pname}}</span>
                            </div>
                            <div class="text"><strong>库存: </strong><span>{{things[(i-1)*cols+index].qoh}}</span></div>
                            <div class="text" v-if="((i-1)*cols+index)<total">
                                <strong>售价： </strong><s>￥{{(things[(i-1)*cols+index].original_price).toFixed(2)}} </s><strong
                                    style="color: red;font-size: large">
                                ￥{{(things[(i-1)*cols+index].original_price*(1-things[(i-1)*cols+index].discnt_rate)).toFixed(2)}}</strong>
                            </div>
                        </div>
                        <el-input-number v-model="qtys[(i-1)*cols+index]" prefix-icon="el-icon-edit"
                                         style="width: 45%;margin-right: 5px;margin-bottom: 5px"
                                         :min="0" :max="things[(i-1)*cols+index].qoh"  :step="1" step-strictly></el-input-number>
                        <el-button type="text" class="button" @click="buy((i-1)*cols+index)">立即购买</el-button>
                    </div>
                </div>
            </el-col>
        </el-row>
    </div>
</template>

<script>
    export default {
        name: "shop",
        mounted() {
            let that = this;
            this.ScreenHeight = document.documentElement.clientHeight - 60;
            this.axios.get('/db/getProducts')
                .then((response) => {
                    that.things = response.data['pro'];
                    that.employees = response.data['emp'];
                    that.customers = response.data['cus'];
                    for (let i = 0; i < that.things.length; i++) {
                        that.qtys[i] = 1;
                        that.things[i].pics = "/api" + that.things[i].pics;
                    }
                    that.employee = that.employees[0].eid;
                    that.customer = that.customers[0].cid;
                }).catch((error) => {
                that.$message.error(error);
            });

        },
        data() {
            return {
                qtys: [],
                cols: 5,
                ScreenHeight: 0,
                things: [],
                customers: [],
                employees: [],
                customer: '',
                employee: '',

            }
        },
        computed: {
            currentDate() {
                return new Date();
            },
            total() {
                return this.things.length;
            },
            rows() {
                return Math.ceil(this.total / this.cols);
            },
            currentCustomer() {
                for (let i = 0; i < this.customers.length; i++) {
                    if (this.customers[i].cid == this.customer)
                        return this.customers[i].cname;
                }
                return "NULL"
            }
        },
        methods: {
            buy(index) {
                let data = {
                    eid: this.employee,
                    cid: this.customer,
                    pid: this.things[index].pid,
                    qty: this.qtys[index],
                }
                this.axios.post('/db/buy', data)
                    .then(response => {
                        if (response.data['code'] == 1) {
                            this.things[index].qoh -= data.qty;
                            let result = this.currentCustomer + "购买了 " + this.things[index].pname + ",共" + data.qty + "件，实际花费" +
                                ((this.things[index].original_price * (1 - this.things[index].discnt_rate)) * data.qty).toFixed(2) + "元";
                            this.$message.success(result);
                            if (response.data['change']) {
                                let addQoh = this.things[index].pname + "进货了:" + response.data['before'] + " ===> " + response.data['after'];
                                // let that = this;
                                this.$nextTick().then(() => {
                                    this.$message.info(addQoh)
                                });
                                this.things[index].qoh = response.data['after'];
                            }
                        } else if (response.data['code'] == -1) {
                            this.$message.error(response.data['result']);
                        }

                    }).catch(error => {
                    console.log(error)
                })

            }
        }

    }
</script>

<style scoped>
    #main {
        /*width: 100%;*/
        padding-left: 10%;
        padding-top: 3%;
        /*text-align: center;*/
        /*padding: 30px;*/
        overflow: auto;
    }

    .row {
        margin-bottom: 5px;
        margin-top: 5px;
        padding-top: 5px;
    }

    .col {
        margin-left: 10px;
    }


    .image {
        width: 13.48vw;
        height: 13.5vw;
        /*padding-bottom: 100%;*/

    }

    .container {
        background-color: #e8dada;
        /*height: 400px;*/
        width: 90%;
        border: 2px solid black
    }

    .container:hover {
        border: 2px solid red;
    }

    .text {
        margin-top: 2px;
    }

</style>

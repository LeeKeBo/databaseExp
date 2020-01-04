<template>
    <div id="main">
        <el-select v-model="product" placeholder="产品" default-first-option @change="changeSelect">
            <el-option
                    v-for="item in products"
                    :key="item.pid"
                    :label="item.pname"
                    :value="item.pid">
            </el-option>
        </el-select>
        <div class="container">
            <el-table :data="tableData" >
                <el-table-column prop="ProductName" label="产品名"></el-table-column>
                <el-table-column prop="MONTH" label="月份"></el-table-column>
                <el-table-column prop="totalQuantity" label="销量"></el-table-column>
                <el-table-column prop="totalDollar" label="总收入"></el-table-column>
                <el-table-column prop="avgDollar" label="平均价格"></el-table-column>
            </el-table>
        </div>

    </div>
</template>

<script>
    export default {
        name: "report",
        mounted() {
            this.axios.get('/db/showProducts')
                .then(response => {

                    this.products = response.data[0];
                    this.product = this.products[0].pid;
                    this.axios.get('/db/reportMonthlySale', {
                        params: {
                            pid: this.product
                        }
                    })
                        .then(response => {
                            this.tableData = response.data[0];
                            console.log(this.tableData)
                        }).catch(error => {
                        console.log(error);
                        this.$message.error("查询失败，请稍后重试")
                    })
                }).catch(error => {
                console.log(error);
                this.$message.error("查询错误，请重试")
            })
        },
        data() {
            return {
                products: [],
                tableData: [],
                product: '',
            }
        },
        methods: {
            changeSelect(current) {
                this.axios.get('/db/reportMonthlySale', {
                    params: {
                        pid: current
                    }
                })
                    .then(response => {
                        console.log(response.data)

                        this.tableData = response.data[0];
                        console.log(this.tableData)
                    }).catch(error => {
                    console.log(error);
                    this.$message.error("查询失败，请稍后重试")
                })
            }
        }
    }
</script>

<style scoped>
    .container{
        width: 80%;
        margin-left: 10%;
        margin-top: 2%;
        text-align: center;
        padding: 30px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
    }
</style>

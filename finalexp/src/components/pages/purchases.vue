<template>
    <div>
        <div class="container">
            <el-table :data="tempList"  >
                <el-table-column prop="pur" label="订单编号"></el-table-column>
                <el-table-column prop="cid" label="顾客ID"></el-table-column>
                <el-table-column prop="eid" label="员工ID"></el-table-column>
                <el-table-column prop="pid" label="产品编号"></el-table-column>
                <el-table-column prop="qty" label="购买数量"></el-table-column>
                <el-table-column prop="ptime" label="购买时间"></el-table-column>
                <el-table-column prop="total_price" label="订单金额"></el-table-column>
            </el-table>
            <div id="pagination">
                <el-pagination
                        @current-change="handleCurrentChange" :current-page="currentTablePage" :total="totalSize" :page-size="pageSize"
                        layout="total , ->, prev, pager, next, jumper" >
                </el-pagination>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "purchases",
        mounted() {
            let that = this;
            this.axios.get('/db/getPurchases')
                .then(response => {
                    that.tableData = response.data;
                    for(let i =0 ;i<that.pageSize;i++){
                        if(that.tableData[i]){
                            that.tempList.push(that.tableData[i]);
                        }
                    }
                    that.totalSize = that.tableData.length;
                })
        },
        data(){
            return{
                tempList:[],
                tableData:[],
                currentTablePage:1,
                totalSize:10,
                pageSize:13
            }
        },
        methods:{
            handleCurrentChange(currentPage){
                this.currentTablePage = currentPage;
                let from = (currentPage - 1) * this.pageSize;
                let to = currentPage * this.pageSize;
                console.log(from,"=>",to);
                this.tempList = [];
                for (; from < to; from++) {
                    if (this.tableData[from]) {
                        this.tempList.push(this.tableData[from]);
                    }
                }
            },
        }
    }
</script>

<style scoped>
    .container{
        width: 80%;
        margin-left: 10%;
        margin-top: 3%;
        text-align: center;
        padding: 30px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    #pagination{
        margin-top: 4px;
    }
</style>

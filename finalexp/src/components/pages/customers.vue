<template>
    <div>
        <div class="container">
            <el-table :data="tempList"  >
                <el-table-column prop="cid" label="顾客"></el-table-column>
                <el-table-column prop="cname" label="用户名"></el-table-column>
                <el-table-column prop="city" label="城市"></el-table-column>
                <el-table-column prop="visits_made" label="购买次数"></el-table-column>
                <el-table-column prop="last_visit_time" label="上次购买时间"></el-table-column>

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
        name: "customers",
        data(){
            return{
                tempList:[],
                tableData:[],
                currentTablePage:1,
                totalSize:10,
                pageSize:13
            }
        },
        mounted() {
            let that = this;
            this.axios.get('/db/getCustomers')
            .then(response => {
                that.tableData = response.data;
                for(let i=0;i<that.pageSize;i++){
                    if(that.tableData[i]){
                        that.tempList.push(that.tableData[i]);
                    }
                }
                that.totalSize = that.tableData.length;
            })
            .catch(error => {
                that.$message.error(error)
            })
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

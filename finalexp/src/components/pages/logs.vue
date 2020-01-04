<template>
    <div id="main" style="height: 100%;">
        <div class="container">
            <el-table :data="tempList" >
                <el-table-column prop="logid" label="编号"></el-table-column>
                <el-table-column prop="who" label="操作用户"></el-table-column>
                <el-table-column prop="time" label="操作日期"></el-table-column>
                <el-table-column prop="table_name" label="操作表单"></el-table-column>
                <el-table-column prop="operation" label="操作类型"></el-table-column>
                <el-table-column prop="key_value" label="操作键值"></el-table-column>
            </el-table>
            <div id="pagination">
                <el-pagination
                        @current-change="handleCurrentChange" :current-page="currentTablePage" :total="totalSize"
                        :page-size="pageSize"
                        layout="total , ->, prev, pager, next, jumper">
                </el-pagination>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "logs",
        mounted() {
            let that = this;
            this.ScreenHeight = document.documentElement.clientHeight - 60;
            this.axios.get('/db/getLogs')
                .then((response) => {
                    that.tableData = response.data;
                    for (let i = 0; i < that.pageSize; i++) {
                        if (that.tableData[i]) {
                            that.tempList.push(that.tableData[i]);
                        }
                    }
                    that.totalSize = that.tableData.length;
                    console.log(that.tableData);

                }).catch((error) => {
                that.$message.error(error);
            })
        },
        data() {
            return {
                tempList: [],
                tableData: [],
                currentTablePage: 1,
                totalSize: 10,
                pageSize: 13,
            }
        },
        methods: {
            handleCurrentChange(currentPage) {
                this.currentTablePage = currentPage;
                let from = (currentPage - 1) * this.pageSize;
                let to = currentPage * this.pageSize;
                console.log(from, "=>", to);
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

    #main {
        height: 100%;
    }


    .container {
        width: 80%;
        margin-left: 10%;
        text-align: center;
        padding: 30px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    #pagination {
        margin-top: 4px;
    }

    #building-top .el-table tr {
        background: #AAB0B0;
    }


</style>

<template>
    <div id="main" v-bind:style="{ height: ScreenHeight+'px' }">
        <el-row v-for="i in rows" :key="i" class="row">
            <el-col :span="4" v-for="(o, index) in cols" :key="o" class="col">
                <div class="container" v-if="((i-1)*cols+index)<total">
                    <div style="margin-right: 2px">
                        <el-image :src="things[(i-1)*cols+index].src"
                                  class="image"></el-image>
                    </div>

                    <div>
                        <div style="text-align: center;padding-top: 8px">
                            <div class="text"><strong>产品名: </strong><span>{{things[(i-1)*cols+index].pname}}</span>
                            </div>
                            <div class="text"><strong>库存: </strong><span>{{things[(i-1)*cols+index].qoh}}</span></div>
                            <div class="text"  v-if="((i-1)*cols+index)<total">
                                <strong>售价： </strong><s>￥{{(things[(i-1)*cols+index].original_price).toFixed(2)}} </s><strong
                                    style="color: red;font-size: large"> ￥{{(things[(i-1)*cols+index].original_price*(1-things[(i-1)*cols+index].discnt_rate)).toFixed(2)}}</strong>
                            </div>
                        </div>

                        <el-button type="text" class="button" @click="buy(things[(i-1)*cols+index].pid)">立即购买
                        </el-button>
                    </div>
                </div>
            </el-col>
        </el-row>

        <el-dialog :visible.sync="buyVisiblity" >

        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "products",
        mounted() {
            let that = this;
            this.ScreenHeight = document.documentElement.clientHeight - 60;
            this.axios.get('/db/getProducts')
                .then((response) => {
                    that.things = response.data;
                }).catch((error) => {
                that.$message.error(error);
            })
        },
        data() {
            return {
                cols: 5,
                ScreenHeight: 0,
                things: [],
                buyVisiblity: false,

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
            }
        },
        methods:{
            buy(pid){
                this.axios.post('/db/buy',pid)
                    .then(response => {
                        console.log(response);
                    }).catch(error => {
                        console.log(error);
                })

                console.log(pid);
            }
        }


    }
</script>

<style scoped>
    #main {
        width: 100%;
        padding-left: 10%;
        padding-top: 3%;
        text-align: center;
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
        width: 14.7vw;
        height: 14.7vw;
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

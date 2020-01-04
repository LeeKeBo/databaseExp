<template>
    <div class="header">
        <div class="logo">
            <span>数据库大作业</span>
        </div>
        <div class="menu" >
            <el-menu mode="horizontal" background-color="#515964"
                     text-color="#fff" active-text-color="#ffd04b"
            router>
<!--                default-active="shop" @select="handleSelect"-->

                <template v-for="item in items">
                    <template v-if="item.sub">
                    </template>
                    <template v-else>
                        <el-menu-item :index="item.index" :key="item.index">
                            <!--                        <i :class="item.icon"></i>-->
                            <span slot="title">{{ item.title }}</span>
                        </el-menu-item>
                    </template>
                </template>

            </el-menu>
        </div>
    </div>
</template>

<script>
    export default {
        name: "v_header",
        data() {
            return {
                items: [
                    {
                        index: "shop",
                        title: '购物页',
                    },
                    {
                        index:'customers',
                        title:'顾客页',
                    },
                    {
                        index:'purchases',
                        title:'订单记录',
                    },
                    {
                        index:'logs',
                        title:'日志页'
                    },
                    {
                        index:'report',
                        title:'产品报表'
                    }

                ],
            }
        },
        methods: {
            handleSelect(key){
                this.$router.push('/'+key);
            },
        }
    }
</script>

<style scoped>
    .header {
        width: 100%;
        height: 60px;
        position: relative;
        font-size: 22px;
        background-color: #515964;

    }

    .logo {
        float: left;
        width: 15%;
        line-height: 60px;
        background-color: #515964;
        color: aquamarine;
    }

    .menu {
        float: left;
        width: 85%;
        padding-bottom: 0px;
    }

    /*去除底部白边*/
    .el-menu.el-menu--horizontal{
        border-bottom: 0px;
    }

</style>

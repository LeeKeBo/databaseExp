<template>
    <div id="app" >
        <v_header></v_header>
        <div id="mainContain" >
          <div id="routerView">
              <router-view :key="key"></router-view>
          </div>
        </div>
    </div>
</template>

<script>
    import v_header from './components/common/Header.vue';

    export default {
        name: 'app',
        components: {
            v_header
        },
        computed:{
            key(){
                return this.$route.path + Math.random()
            }
        }
    }
</script>

<style>

    * {
        margin: 0;
        padding: 0;
    }

    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-align: center;
        color: #2c3e50;
        height: 100%;
        width: 100%;
        position: absolute;
        top: 0px;
        bottom: 0px;
        z-index: 0;
        overflow:hidden; word-break:break-all;
    }

    #mainContain{
        background-image:url('../public/images/background.png');
        background-color: #515964;    background-size: 100% 100%;

        height: 100%;
        margin: 0;
        padding-top: 0px;
    }

    #routerView{
        padding-top: 25px;
    }
</style>

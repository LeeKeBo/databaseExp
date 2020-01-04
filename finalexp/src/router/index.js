import Vue from 'vue';
import Router from 'vue-router';

Vue.use(Router);

export default new Router({
    routes: [
        {
            path: '/',
            redirect: '/shop'
        },
        {
            path: '/logs',
            component: () => import('../components/pages/logs.vue'),
            meta: {title: '日志页'}
        },
        {
            path: '/customers',
            component: () => import('../components/pages/customers'),
            meta: {title: '顾客页'}
        },
        {
            path: '/purchases',
            component: () => import('../components/pages/purchases.vue'),
            meta: {title: '订单页'}
        },
        {
            path: '/shop',
            component: () => import('../components/pages/shop.vue'),
            meta: {title: '购物页'}
        },
        {
            path: '/products',
            component: () => import('../components/pages/products'),
            meta: {title: '产品页'}
        },
        {
            path: '/report',
            component: () => import('../components/pages/report'),
            meta: {title: '产品报表'}
        }


    ]
})
;

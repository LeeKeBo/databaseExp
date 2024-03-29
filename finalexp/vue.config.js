module.exports = {
    devServer: {
        port:8000,
        proxy: {
            '^/api': {
                target: 'http://localhost:3000/',
                changeOrigin:true,
                pathRewrite: {
                    '^/api': '/'
                }
            }
        },
    }
}

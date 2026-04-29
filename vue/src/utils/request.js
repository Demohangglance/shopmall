import axios from 'axios'
import router from "@/router"; // 导入路由实例，用于未登录时跳转登录页

// 创建一个新的axios实例
const request = axios.create({
    baseURL: process.env.VUE_APP_BASEURL,   // 后端接口基础地址（从环境变量获取，方便多环境切换）
    timeout: 30000 // 请求超时时间：30秒（超过该时间未响应则视为请求失败）
})

// request 拦截器
// 可以自请求发送前对请求做一些处理
// 比如统一加token，对请求参数统一加密
request.interceptors.request.use(config => {
    // 设置默认Content-Type为JSON格式（适用于大多数POST/PUT请求）
    config.headers['Content-Type'] = 'application/json;charset=utf-8';

    // 从localStorage获取用户信息（登录后存储的用户数据）
    let user = JSON.parse(localStorage.getItem("user") || '{}')
    // 将用户token添加到请求头（用于后端身份验证）
    config.headers['token'] = user.token

    return config // 返回处理后的配置
}, error => {
    // 请求发送失败时的错误处理（如网络错误）
    console.error('request error: ' + error) // 打印错误信息（调试用）
    return Promise.reject(error) // 将错误传递给调用者
});

// 响应拦截器（接口响应后的处理）
// 作用：统一处理响应数据、拦截错误状态码（如401未登录）等
request.interceptors.response.use(
    response => {
        let res = response.data; // 获取响应体数据

        // 兼容服务端返回的字符串类型数据（如果后端返回JSON字符串，自动解析为对象）
        if (typeof res === 'string') {
            res = res ? JSON.parse(res) : res
        }

        // 处理401未授权状态（token失效或未登录）
        if (res.code === '401') {
            router.push('/login') // 跳转到登录页
        }

        return res; // 将处理后的数据返回给调用者
    },
    error => {
        // 响应错误处理（如服务器500错误、超时等）
        console.error('response error: ' + error) // 打印错误信息（调试用）
        return Promise.reject(error) // 将错误传递给调用者
    }
)

// 导出自定义axios实例，供全局使用
export default request

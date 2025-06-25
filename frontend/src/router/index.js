import { createRouter, createWebHistory } from 'vue-router'

const routes = [
    {
        path: '/about',
        name: 'About',
        component: () => import('@/views/About.vue')
    },
    {
        path: '/generateCodeSignature',
        name: 'GenerateCodeSignature',
        component: () => import('@/views/GenerateCodeSignature.vue')
    },
    {
        path: '/refactorVariable',
        name: 'RefactorVariable',
        component: () => import('@/views/RefactorVariable.vue')
    },
    {
        path: '/generateDocument',
        name: 'GenerateDocument',
        component: () => import('@/views/GenerateDocument.vue')
    },
    {
        path: '/foldConstant',
        name: 'FoldConstant',
        component: () => import('@/views/FoldConstant.vue')
    },
    {
        path: '/result',
        name: 'Result',
        component: () => import('@/views/Result.vue')
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
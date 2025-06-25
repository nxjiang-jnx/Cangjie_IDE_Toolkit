<template>
  <div id="app">
    <TopBar />
    <div class="main-container">
      <SideMenu />
      <div class="content-area">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup>
import TopBar from './components/TopBar.vue'
import SideMenu from './components/SideMenu.vue'
</script>

<style>
.main-container {
  display: flex;
  padding: 20px;
  gap: 20px;
}

.content-area {
  flex: 1;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}
</style>
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  base: "/",
  plugins: [react()],
  preview: {
    port: 8080,
    strictPort: true,
  },
 server: {
    port: 8080,
    strictPort: true,
    host: true,
    origin: "http://tdc-workshop-app0910.eastus.cloudapp.azure.com:8080/",
  },
})

import { defineConfig } from 'vite'
import devServer from '@hono/vite-dev-server'

export default defineConfig(({ mode }) => {
  if (mode === 'client') {
    return {
      build: {
        lib: {
          entry: './src/client.ts',
          formats: ['es'],
          fileName: 'client',
          name: 'client',
        },
        rollupOptions: {
          output: {
            dir: './dist/client/assets',
          },
        },
        emptyOutDir: false,
        copyPublicDir: false,
      },
    }
  } else {
    return {
      build: {
        ssr: true,
        lib: {
          entry: './src/server.tsx',
          formats: ['es'],
          fileName: 'server',
          name: 'server',
        },
        rollupOptions: {
          output: {
            dir: './dist',
          },
        },
      },
      plugins: [
        devServer({
          entry: 'src/server.tsx',
        }),
      ],
    }
  }
})
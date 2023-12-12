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
            dir: './assets',
          },
        },
        emptyOutDir: false,
        copyPublicDir: false,
      },
    }
  } else {
    return {
      plugins: [
        devServer({
          entry: 'src/server.tsx',
        }),
      ],
    }
  }
})
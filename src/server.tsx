import { Hono } from 'hono'
import {renderToString} from 'react-dom/server'
import { App } from './app'

console.log(import.meta.env)

const app = new Hono()

app.get('/*', (c) => {
  return c.html(
    renderToString(
    <html>
      <head>
        {import.meta.env.PROD ? (
          <>
            <script type='module' src='/assets/client.js'></script>
          </>
        ) : (
          <>
            <script type='module' src='/src/client.tsx'></script>
          </>
        )}
      </head>
      <body>
        <div id='root'>
          <App />
        </div>
      </body>
    </html>
  ))
})

export default app

import { Hono } from 'hono'
import {renderToString} from 'react-dom/server'

console.log(import.meta.env)

const app = new Hono()

app.get('/', (c) => {
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
            <script type='module' src='/src/client.ts'></script>
          </>
        )}
      </head>
      <body>
        <h1>Hello World</h1>
      </body>
    </html>
  ))
})

export default app

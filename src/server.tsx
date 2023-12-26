import {renderToString} from 'react-dom/server'
import { App } from './app'

export function render() {
  console.log('render')
  return renderToString(<App />)
}
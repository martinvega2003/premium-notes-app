import dotenv from 'dotenv'
import app from './app'
import { prisma } from './database'

dotenv.config()

const PORT = process.env.PORT ? parseInt(process.env.PORT) : 5000

async function start() {
  try {
    await prisma.$connect()
    console.log('✅ Database connected')
    app.listen(PORT, () => {
      console.log(`🚀 Server listening on http://localhost:${PORT}`)
    })
  } catch (err) {
    console.error('❌ Failed to start server:', err)
    process.exit(1)
  }
}

start()
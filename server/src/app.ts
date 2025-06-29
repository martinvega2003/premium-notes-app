import express from 'express'
import cors from 'cors'
import { prisma } from './database'
import { authRouter } from './routes/auth.route'
import { errorMiddleware } from './middlewares/error.middleware'

const app = express()

app.use(cors())
app.use(express.json())

// Health-check: verifies DB connectivity
app.get('/health', async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`
    res.status(200).json({ status: 'OK' })
  } catch (err) {
    console.error('Health check failed:', err)
    res.status(500).json({ status: 'DB Unreachable' })
  }
})

// Mount your auth routes at /auth
app.use('/auth', authRouter)

// Global error handler
app.use(errorMiddleware)

export default app
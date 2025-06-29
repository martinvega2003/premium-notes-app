import { Router } from 'express'

export const authRouter = Router()

// Placeholder routes — real handlers will come later
authRouter.post('/register', (_req, res) => {
  res.status(501).json({ message: 'Not implemented' })
})
authRouter.post('/login', (_req, res) => {
  res.status(501).json({ message: 'Not implemented' })
})